export PROMPT='$P$G'
export PYTHONPATH=`convertPath.py -w -v PYTHONPATH`
export PATH="`convertPath.py -u -v PYTHONROOTWIN`:/cygdrive/c/WINDOWS/system32:$PATH"
/usr/bin/cygstart cmd
