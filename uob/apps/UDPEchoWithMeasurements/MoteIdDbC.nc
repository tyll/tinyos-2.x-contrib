/* -*- mode:c++; indent-tabs-mode: nil -*- */
/**
 * 48 bit ID chips to USB ID and wanted TOS_NODE_ID
 */
/**
 * @author: Markus Becker (mab@comnets.uni-bremen.de)
 */

configuration MoteIdDbC {
    provides interface MoteIdDb;
}
implementation {
    components
        MoteIdDbP;

    MoteIdDb = MoteIdDbP;
}
