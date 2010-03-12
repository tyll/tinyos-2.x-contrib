"""
Nifty utility functions for dealing with different sensor sources.
"""

import types
from warnings import warn


def multi_config(motes, source, streamer, **extra):
    """
    Return a dictionary of callbacks for mote sensor configuration.

    The dictionary can be used to feed mote sensor configuration with
    a single lookup after the motes have booted.

    motes can be a list of mote numbers, a range, or a single integer.

    source is a file object, or a string that specifies the file to
    load (as per Reader.as_file). If source is is a string (filename)
    and contains a %, then the used filename is the evalutation of: f
    % mote_number. That is, when f = "dat%02d.txt" (see printf), mote
    with ID 1 will load "dat01.txt" and mote with ID 99 will load
    "dat99.txt".

    **WARNING** If source is a file object it will be shared across
    all motes! (this is likely NOT wanted)

    streamer_gen is a function used to generate the streamer; see
    Streamer. streamer_gen is passed the source and any extra supplied
    keyword arguments.
    """
    # single mote is really a list of one mote
    if isinstance(motes, int):
        motes = (motes,)

    if not motes:
        warn("no motes specified")
        return

    # determine mode string (may be needed)
    open_mode = streamer.file_mode if hasattr(streamer, "file_mode") else "rb"

    def personalize_source(source, num):
        if isinstance(source, types.StringTypes):
            if source.find("%") >= 0:
                return open(source % num, open_mode)
            else:
                return open(source, open_mode)

    config = {}
    for num in motes:
        _source = personalize_source(source, num) or source
        config[num] = streamer(_source, **extra).generator()

    return config
