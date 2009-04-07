/**
 * This driver implements an software I2C Master controller.
 *
 * @author Henrik Makitaavola
 */
#include "I2C.h"
generic module SoftI2CMasterPacketP()
{
    provides interface AsyncStdControl;
    provides interface I2CPacket<TI2CBasicAddr>;

    uses interface SoftI2CBus as I2C;
}
implementation
{
    enum
    {
        I2C_OFF          = 0,
        I2C_IDLE         = 1,
        I2C_BUSY         = 2,      
    } soft_i2c_state_t;

    uint8_t state = I2C_OFF;
    uint16_t _addr;
    uint8_t _len;
    uint8_t* _data;
    error_t _error;

    task void writeDoneTask()
    {
        atomic
        {
            state = I2C_IDLE;
            signal I2CPacket.writeDone( _error, _addr, _len,  _data);
        }
    }

    task void readDoneTask()
    {
        atomic
        {
            state = I2C_IDLE;
            signal I2CPacket.readDone( _error, _addr, _len,  _data);
        }
    }

    async command error_t AsyncStdControl.start()
    {
        atomic
        {
            if (state == I2C_OFF)
            {
                call I2C.init();
                state = I2C_IDLE;
                return SUCCESS;
            }
            else
            {
                return FAIL;
            }
        }
    }

    async command error_t AsyncStdControl.stop()
    {
        atomic
        {
            if (state == I2C_IDLE)
            {
                call I2C.off();
                state = I2C_OFF;
                return SUCCESS;
            }
            else
            {
                return FAIL;
            }
        }
    }

    async command error_t I2CPacket.read(i2c_flags_t flags,
            uint16_t addr,
            uint8_t len,
            uint8_t* data)
    {
        int i;
        atomic
        {
            if (state == I2C_IDLE)
            {
                state = I2C_BUSY;
            }
            else if (state == I2C_OFF)
            {

                return EOFF;
            }
            else
            {

                return EBUSY;
            }
        }
        atomic
        {
            if (len < 1) // A 0-length packet with no start and no stop....
            {
                state = I2C_IDLE;
                return FAIL;
            }

            if (flags & I2C_START)
            {
                call I2C.start();
                call I2C.writeByte(addr+1); 
            }

            // Read the information.
            for (i = 0; i < len-1; ++i)
            {
                data[i] = call I2C.readByte(true);
            }
            data[len-1] = call I2C.readByte(I2C_ACK_END);
            if (flags & I2C_STOP)
            {
                call I2C.stop();
            }

            //state = I2C_IDLE;
            _error = SUCCESS;
            _addr = addr;
            _len = len;
            _data = data;
        }
        post readDoneTask();

        return SUCCESS;
    }

    async command error_t I2CPacket.write(i2c_flags_t flags,
            uint16_t addr,
            uint8_t len,
            uint8_t* data)
    {
        int i;

        atomic
        {
            if (state == I2C_IDLE)
            {
                state = I2C_BUSY;
            }
            else if (state == I2C_OFF)
            {
                return EOFF;
            }
            else
            {

                return EBUSY;
            }
        }
        atomic
        {
            if (len < 1) // A 0-length packet with no start and no stop....
            {
                state = I2C_IDLE;
                return FAIL;
            }
            if (flags & I2C_START)
            {
                call I2C.start();
                call I2C.writeByte(addr);
            }

            // Send information.
            for (i = 0; i < len; ++i)
            {
                call I2C.writeByte(data[i]);
            }

            if (flags & I2C_STOP)
            {
                call I2C.stop();
            }
            //state = I2C_IDLE;


            _data = data;
            _addr = addr;
            _len = len;
            _error = SUCCESS;
        }
        post writeDoneTask();
        return SUCCESS;
    }



}
