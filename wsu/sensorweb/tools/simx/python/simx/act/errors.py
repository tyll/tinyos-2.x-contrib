import traceback

class LoadException(Exception):
    def __init__(self, exception=None, stack_list=None, command=""):
        self.exception = exception
        self.stack_list = stack_list or []
        self.command = command

    def __str__(self):
        return "LoadException: %s\n   command was: %s" % \
            (self.exception, self.command)

    def print_exception(self):
        print str(self)
        for line in traceback.format_list(self.stack_list):
            print line
