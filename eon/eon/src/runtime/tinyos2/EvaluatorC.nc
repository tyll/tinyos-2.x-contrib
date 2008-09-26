
module EvaluatorC
{
  provides
  {
  	interface Init;
    interface IEval;
  }
  uses
  	{
  		interface IEnergySrc;
		interface ILoadModel;
		interface IConsumeModel;
		interface IIdle;
	}

}

implementation
{

	enum {ST_STATE, ST_MAX, ST_GRADE, ST_DONE};
	
#ifndef NUMTIMEFRAMES
#define NUMTIMEFRAMES 12
#endif

//get the nth timescale--2^X;
#define ETIMESCALE(X) ((X < NUMTIMEFRAMES) ? (0x00000001 << X) : 1)

 uint8_t __thestate = STATE_BASE;
 double __thegrade = 0.0;
 bool __minalive = FALSE;
 bool __maxalive;
 int64_t __minenergy = 0;
 int64_t __maxenergy = 0;
 double __mingrade = 0.0;
 double __maxgrade = 1.0;
 int thestage;

 //PREDICT_STATE variables
 uint8_t ps_state;
 double ps_grade;
 int64_t *ps_energy_result;
 int ps_timeframe;
 uint64_t ps_waste_energy;
 uint32_t ps_battery_reserve;
 uint32_t ps_battery_capacity;
	
 //PREDICT_ENERGY variables
 int64_t pe_src_energy;
 int64_t pe_consumption;
 int64_t pe_load;
 int64_t pe_netenergy;
 int64_t pe_idleloss;
 int8_t pe_source;
 
 //GETGRADE VARS
 bool __gradealive;
 
// int __mystate;
bool busy = FALSE;
 
 	task void PE_DoneTask();
	task void PS_PredictTask();
	task void gotStateTask();
	task void getStateTask();
	task void gotMaxTask();
	task void getGradeTask();
	void predict_state_done(bool alive);

	command error_t Init.init()
	{
		busy = FALSE;
		return SUCCESS;
	}
	
	
	
	
	
	void predict_energy_done(int64_t energy)
	{
		int64_t newbattery;
		int64_t immediate_waste;
		bool dead;
		
		newbattery = ps_battery_reserve + energy - ps_waste_energy;
		if (ps_energy_result != NULL)
		{
			*ps_energy_result = newbattery;
		}
					
		if (newbattery <= (int64_t)ps_battery_capacity)
		{
			immediate_waste = 0;
		} else {
			immediate_waste = newbattery - ps_battery_capacity;
			newbattery = ps_battery_capacity;
		}
				
		//accumulate wasted energy	
		ps_waste_energy += immediate_waste;
						
		if (newbattery <= 0)
		{
			dead = TRUE;
			//printf("DEAD!\n");
		} else {
			dead = FALSE;
			//printf("Not Dead\n");
		}
					
		if (!dead)
		{
			ps_timeframe++;
			post PS_PredictTask();
			return;
		} else {
			predict_state_done(FALSE);
		}
	}
		
	task void PE_DoneTask()
	{
		pe_netenergy = pe_src_energy - ((pe_consumption * 1000LL) + pe_idleloss);
		predict_energy_done(pe_netenergy);
	}
	
	task void ConsumptionTask()
	{
		pe_consumption += call IConsumeModel.getConsumePrediction(ETIMESCALE(ps_timeframe), pe_load, ps_state, ps_grade, pe_source);
		pe_source++;
		if (pe_source < NUMSOURCES)
		{
			post ConsumptionTask();
			return;
		} else {
			post PE_DoneTask();
		}
	}
	
	bool predict_energy ()
	{
			
		pe_src_energy = call IEnergySrc.getEnergyPrediction(ETIMESCALE(ps_timeframe));
		pe_load = call ILoadModel.getLoadPrediction(ETIMESCALE(ps_timeframe));
		pe_idleloss = (call IIdle.getIdle() * ETIMESCALE(ps_timeframe) * 60 * 60);
		
		pe_consumption = 0;
		pe_source = 0;
		post ConsumptionTask();
		
		
		return TRUE;
	}
	
	void predict_state_done(bool alive)
	{
		if (thestage == ST_STATE)
		{
			if (alive || __thestate == STATE_BASE)
			{
				__minalive = alive;
				post gotStateTask();
				return;
			}
			__thestate++;
			post getStateTask();
			return;
		}
		if (thestage == ST_MAX)
		{
			__maxalive = alive;
			post gotMaxTask();
			return;
		}
		if (thestage == ST_GRADE)
		{
			__gradealive = alive;
			if (alive)
			{
				__mingrade = (__mingrade + __maxgrade)/2;
			} else {
				__maxgrade = (__mingrade + __maxgrade)/2;
			}
			post getGradeTask();	
		}
	}
	
	
	
	task void PS_PredictTask()
	{
		
		if (ps_timeframe >= NUMTIMEFRAMES)
		{
			//we made it
			predict_state_done(TRUE);
			return;
		}
			
		predict_energy();
		return;
	}

	
	bool predict_state(uint8_t state, double grade, int64_t *energy_result)
	{
		
		ps_state = state;
		ps_grade = grade;
		ps_energy_result = energy_result;
		ps_timeframe = 0;
		ps_waste_energy = 0;
		
		post PS_PredictTask();
		
		return TRUE;
	}
	
	
	task void getGradeTask()
	{
		
		double midgrade = __mingrade;
		
			
		if ((__maxgrade - __mingrade) > .001)
		{

			midgrade = (__mingrade + __maxgrade)/2;
			predict_state(__thestate, midgrade, NULL);
			return;
		}
		__thegrade = midgrade;	
		signal IEval.reeval_done(__thestate, __thegrade);
		thestage = ST_DONE;
		busy = FALSE;
	}
	
	task void gotStateTask()
	{
		if (!__minalive)
		{
			__thestate = STATE_BASE;
			__thegrade = 0.0;
			signal IEval.reeval_done(__thestate, __thegrade);
			busy = FALSE;
			return;
		}
		
		thestage = ST_MAX;
		predict_state(__thestate, 1.0, &__maxenergy);
		//busy = FALSE;
		//signal IEval.reeval_done(__thestate, 0.0);
	}
	
	task void gotMaxTask()
	{
		if (__maxalive)
		{
			__thegrade = 1.0;
			signal IEval.reeval_done(__thestate, __thegrade);
			busy = FALSE;
			return;
			
		} 
		__mingrade = 0.0;
		__maxgrade = 1.0;	
		thestage = ST_GRADE;
		post getGradeTask();
	}

	
	
	task void getStateTask()
	{
		predict_state(__thestate, 0.0, &__minenergy);
	}
	
	command error_t IEval.reeval_energy_level()
	{
		if (busy)
		{
			return FAIL;
		}
		__thestate = 0; //max state
		__minalive = FALSE;
		
		busy = TRUE;
		thestage = ST_STATE;
		
		ps_battery_reserve = call IEnergySrc.getBattery();
		ps_battery_capacity = call IEnergySrc.getBatteryCapacity();
		
		post getStateTask();
		return SUCCESS;
	}
	
	command error_t IEval.reportPathDone(uint16_t pathnum, uint8_t state, uint32_t energy)
	{
		error_t res;
		
		res = call ILoadModel.pathDone(pathnum);
		//if (energy != 0xFFFFFFFF)
		{
			res = call IConsumeModel.pathDone(pathnum, state, energy);
		}
		return res;
	}
}
