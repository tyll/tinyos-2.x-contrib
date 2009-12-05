"""
Test the probe Loader.
"""

from simx.probe import Loader

def test_loader():
    """
    Basic Loader test, by it's lonesome, so that Loader can be assumed
    to be valid in other invidual tests (without needing to reload
    each time).
    """
    loader = Loader("MultihopOscilloscope_app.xml", None)
