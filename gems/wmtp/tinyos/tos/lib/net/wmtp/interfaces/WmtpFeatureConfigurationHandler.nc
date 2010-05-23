/*
 * WMTP - Wireless Modular Transport Protocol
 *
 * Copyright (c) 2008 Luis D. Pedrosa and IT - Instituto de Telecomunicacoes
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 * Address:
 * Instituto Superior Tecnico - Taguspark Campus
 * Av. Prof. Dr. Cavaco Silva, 2744-016 Porto Salvo
 *
 * E-Mail:
 * luis.pedrosa@tagus.ist.utl.pt
 */

/**
 * Basic interface provided by WMTP feature modules to mamage their
 * configuration.
 *
 * This interface allows WMTP plugins to manage their configuration by setting
 * default values and converting a configuration part to and from a connection
 * specification.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

interface WmtpFeatureConfigurationHandler {
    /**
     * Initializes a connection specification with default values.
     *
     * @param ConnectionSpecification The connection specification to
     *                                initialize.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t InitializeConfiguration( WmtpConnectionSpecification_t *ConnectionSpecification );

    /**
     * Generates the configuration data that will be used to (re)configure
     * connections or individual packets.
     *
     * @param ConnectionSpecification The connection specification that holds
     *                                the configuration;
     * @param ConfigurationData Buffer to write the configuration data to;
     * @param ConfigurationDataSize Variable to fill in with the data's size.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GenerateConfigurationData( WmtpConnectionSpecification_t *ConnectionSpecification, void *ConfigurationData, uint8_t *ConfigurationDataSize );

    /**
     * (Re)Configures a connection using the provided configuration data.
     *
     * @param ConfigurationData Pointer to the configuration data;
     * @param ConfigurationDataSize Variable to fill in with the data's size.
     * @param ConnectionSpecification The connection specification to update
     *                                with the configuration;
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t HandleConfigurationData( void *ConfigurationData, uint8_t *ConfigurationDataSize, WmtpConnectionSpecification_t *ConnectionSpecification );

    /**
     * Calculates the size of the provided configuration data.
     *
     * @param ConfigurationData Pointer to the configuration data;
     * @param ConfigurationDataSize Variable to fill in with the data's size.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GetConfigurationDataSize( void *ConfigurationData, uint8_t *ConfigurationDataSize );
}
