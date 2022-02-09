import subprocess

from fpgaCounter.models import Counter

def ReadCounter():
    countVal = 0
    countVal = int(subprocess.check_output(['./testProject'], stderr=subprocess.STDOUT, timeout=None))
    Counter.reading = countVal
    
    return True