This directory contains the TinyOS 2.0 sources of an ad hoc hierarchical
point-to-point routing framework developed by Konrad Iwanicki.

Copyright:
(c) 2006-2008 Vrije Universiteit Amsterdam and Development Laboratories
(DevLab), Eindhoven, the Netherlands. All rights reserved.

Author:
Konrad Iwanicki <iwanicki@few.vu.nl>

License:
Can be found in the accompanying LICENSE.txt file.

Download:
http://www.few.vu.nl/~iwanicki/Ad_Hoc_Hierarchical_Routing/

Additional information:
K. Iwanicki and M. van Steen, ``On Hierarchical Routing in Wireless Sensor
Networks.'' In IPSN'09: Proceedings of the Eighth ACM/IEEE International
Conference on Information Processing in Sensor Networks, San Francisco,
California, USA, April 13-16, 2009. (available in the ACM Digital Library)


Description:

This software encompasses some selected parts of an ad hoc hierarchical
point-to-point routing framework for wireless sensor networks described
in the aforementioned IPSN'09 paper. The author has put all the effort
to extract and compose in a whole those parts of the framework for which
he had obtained a permission to publish.

This directory contains the TinyOS 2.0 sources resulting from that 
extraction and composition process. It consists of the following
subdirectories.

hierclust: Hierarchical clustering and routing.
  Contains the code responsible for building and maintaining a cluster
  hierarchy and for routing using such a hierarchy.

interfaces: Common interfaces used throughout the framework.
  Some standard stuff.

le: Link quality estimator.
  Contains a custom PRR link quality estimator that was developed to be
  published with the framework sources. It should enable relatively stable
  hierarchies.

sequencing: Packet sequencing functionality.
  Some standard stuff used for example by the link estimator.

utils: Utilities.
  Implementations of components shared across the protocol stack.

Each of these subdirectories contains its own README.txt file.

Have fun!
