
#define DEF_COMPONENTS(name, pr) components pr as PR_##name;

#define SIMPLE_PRIM_CONFIG(name, pr)  App.Primitive[name] -> PR_##name;
#define EVAL_PRIM_CONFIG(name, pr)    App.Eval[name]      -> PR_##name;
#define APPLY_PRIM_CONFIG(name, pr)   App.Apply[name]     -> PR_##name;
#define SEND_PRIM_CONFIG(name, pr)    App.Sender[name]    -> PR_##name;
#define RECEIVER_CONFIG(name, pr)     App.Receiver[name]  -> PR_##name;

implementation {
  components SensorSchemeC as App, MainC;
  components new PoolC(message_t, POOL_SIZE);

  components LedsC;
  components new TimerMilliC();

  SIMPLE_PRIM_LIST(DEF_COMPONENTS)
  EVAL_PRIM_LIST(DEF_COMPONENTS)
  APPLY_PRIM_LIST(DEF_COMPONENTS)
  SEND_PRIM_LIST(DEF_COMPONENTS)
  RECEIVER_LIST(DEF_COMPONENTS)

  App.Boot -> MainC;
  App.Pool -> PoolC;
  App.Leds -> LedsC;
  App.Timer -> TimerMilliC;
  
  SIMPLE_PRIM_LIST(SIMPLE_PRIM_CONFIG)
  EVAL_PRIM_LIST(EVAL_PRIM_CONFIG)
  APPLY_PRIM_LIST(APPLY_PRIM_CONFIG)
  SEND_PRIM_LIST(SEND_PRIM_CONFIG)
  RECEIVER_LIST(RECEIVER_CONFIG)
}
