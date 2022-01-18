from django.shortcuts import get_object_or_404, render
from django.http import HttpResponseRedirect
from django.urls import reverse
from django.views import generic

from .models import Counter

# Create your views here.
class IndexView(generic.ListView):

    def get_queryset(self):
        """Return the last five published questions."""
        return Counter.objects.order_by('-pub_date')[:5]