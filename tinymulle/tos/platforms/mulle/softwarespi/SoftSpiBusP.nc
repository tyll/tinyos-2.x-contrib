/**
 * Mulle specific implementation of a software Spi bus.
 *
 * @author Henrik Makitaavola
 * @author Also some unknown author
 */
generic module SoftSpiBusP()
{
    provides interface SoftSpiBus as Spi;

    uses interface GeneralIO as SCLK;
    uses interface GeneralIO as MISO;
    uses interface GeneralIO as MOSI;
}
implementation
{
    async command void Spi.init()
    {
        call SCLK.makeOutput();
        call MOSI.makeOutput();
        call MISO.makeInput();
        call SCLK.clr();
    }

    async command void Spi.off()
    {
        // TODO(henrik): Exactly what should be set if SPI bus should be turned off?
        call SCLK.makeInput();
        call MISO.makeInput();
        call MOSI.makeInput();
        call SCLK.clr();
        call MISO.clr();
        call MOSI.clr();
    }

    async command uint8_t Spi.readByte()
    {
        uint8_t i;
        uint8_t data = 0xde;

        atomic
        {
            for(i=0 ; i < 8; ++i)
            {
                call SCLK.clr();
                data = (data << 1) | (uint8_t) call MISO.get();
                call SCLK.set();
            }
        }
        return data;
    }

    async command void Spi.writeByte(uint8_t byte)
    {
        uint8_t  i = 8;
        atomic
        {
            for (i = 0; i < 8 ; ++i)
            {
                if (byte & 0x80)
                {
                    call MOSI.set();
                }
                else
                {
                    call MOSI.clr();
                }
                call SCLK.clr();
                call SCLK.set();
                byte <<= 1;
            }
        }
    }

    async command uint8_t Spi.write(uint8_t byte)
    {
        uint8_t data = 0;
        uint8_t mask = 0x80;

        atomic do
        {
            if( (byte & mask) != 0 )
                call MOSI.set();
            else
                call MOSI.clr();

            call SCLK.clr();
            if( call MISO.get() )
                data |= mask;
            call SCLK.set();
        } while( (mask >>= 1) != 0 );

        return data;
    }
}
