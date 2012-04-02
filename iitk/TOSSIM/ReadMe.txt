The files of this folder need to be replaced/copied in your tossim directory.

Description of files:

    To be replaced:
    ActiveMessageC.nc                   contains the configuration for switching the MAC protocol
    TossimRadioMsg.h                    contains structures of control packets
    sim_noise.c                         contains noise generation model (previous file has a bug)
                        
    To be copied:
        
    CSMA.nc                             contains code of CSMA
    CSMACA.nc                           contains code of CSMACA
    SMAC.nc                             contains code of SMAC
    TMAC.nc                             contains code of TMAC
    BMACP.nc                            contains code of BMAC+
    BMACwithack.nc                      contains code of BMAC
    
    Rest of the files are needed for PowerTOSSIM-Z. To know more about PowerTOSSIM-Z, visit: http://www.scss.tcd.ie/~carbajor/powertossimz/index.html
    
    Note: The current files donot remove duplicate packets. To enable MACs to remove duplicate packets, uncomment the lines in every MAC file.
          Search for the tag "duplicate packets" in the MAC file.   
    
