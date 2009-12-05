# Shared Context module for the Act environment

R = None  # Reply context
T = None   # Tossim Object

# Optional components
Sensor = None
Leds = None

def reply(message, target=None, track_id=0):
    if R:
        return R.reply(message, target=target, track_id=track_id)
    else:
        raise RuntimeError("No Reply Context")

def reply_context():
    return R

def set_reply_context(r):
    global R
    R = r

def init(env):
    global T, Sensor, Leds
    T = env.get('tossim', None)
    Sensor = env.get('sensor_control', None)
    Leds = env.get('led_control', None)
    pass

def init_local_context():
    return locals()


GLOBAL_CONTEXT = globals()
LOCAL_CONTEXT = init_local_context()
