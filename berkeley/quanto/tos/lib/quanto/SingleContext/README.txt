SingleContext is the interface to be used for resources that can only be
set to a single activity at any given time. The foremost example of this is
one (single-core) CPU. Contrast with MultiContext interface.

Each single-owner resource in the system should be represented by a SingleContext.

The set of components and modules here implement a KeyMap between globally known,
user-defined RESOURCE_CTX_IDs and a local keyspace for efficiency.

SingleContext is the interface.
SingleContextC is a generic configuration that is used once to define a resource (such as 
CPUContextC).
It maps one SingleContextG entry (parameterized by global id) to one SingleContextP
(parameterized by local id). The local id is defined to be unique from the 
string SINGLE_CONTEXT_UNIQUE defined in SingleContext.h



