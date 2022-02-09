from django.shortcuts import get_object_or_404, render
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse
from django.views import generic
from django.template import loader

import subprocess
from subprocess import call

from .models import Counter

countVar = 0

# Create your views here.
def Detail(request):
    global countVar
    template_name= loader.get_template('board.html')
    Counter.reading = "100"
    context = {'Counter' : countVar}
    return render(request, 'board.html', context)
        

def LED0_ON(request):
    call("../.././gpio_test -l 234")
    return HttpResponseRedirect(request.META.get('HTTP_REFERER', '/'))

def LED0_OFF(request):
    call("../.././gpio_test -l 0")
    return HttpResponseRedirect(request.META.get('HTTP_REFERER', '/'))

def HelloWorld(request):
    global countVar
    countVal = 0
    countVal = int(subprocess.check_output(["../.././custom_counter_de10_nano"], stderr=subprocess.STDOUT, timeout=None))
    Counter.reading = countVal
    countVar = countVal
    print(countVal)
    print(Counter.reading)
    print(countVar)
    return HttpResponseRedirect(request.META.get('HTTP_REFERER', '/'))