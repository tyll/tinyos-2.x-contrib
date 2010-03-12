#
# Common wrapper to import simplejson from either the system library,
# if it is present or, failing that, from the version packaged in
# simx_dist. This ensures the distributed version is always tried
# last.
#
# Usage: from simx import json [as simplejson]
#

try:
    from simplejson import *
except ImportError:
    from simx.dist.simplejson import *
