/* Copyright (c) 2009 Fan Zhang at LTU.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the (updated) modification history and the author appear in
 * all copies of this source code.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS  `AS IS'
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
 * OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */
/**
 * Potentiometer Voltage. The returned value represents the potentiometer voltage 
 * on the expansion board. The Vref is 1.3V and AVcc is 3.3V. The formula to convert
 * it to mV is: Vout=value * 1309 / 1023. the temperature is: (Vout-509)/6.45
 *
 * @author Fan Zhang <fanzha@ltu.se>
 */
module VoltageP
{
  provides interface M16c62pAdcConfig;
}
implementation
{
  async command uint8_t M16c62pAdcConfig.getChannel()
  {
    // select the AN0 = P10_0 to potentiometer on the expansion board,
    // AN17 = P0_7 to the DS600 on mulle
    return M16c62p_ADC_CHL_AN0;
  }

  async command uint8_t M16c62pAdcConfig.getPrecision()
  {
    return M16c62p_ADC_PRECISION_10BIT;
  }

  async command uint8_t M16c62pAdcConfig.getPrescaler()
  {
    return M16c62p_ADC_PRESCALE_2;
  }
}
