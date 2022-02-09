from django.db import models

# Create your models here.
import datetime

from django.db import models
from django.utils import timezone

class Counter(models.Model):
    reading = models.CharField(max_length=200)
    timestamp = models.DateTimeField('date published')
    
    def __str__(self):
        return self.reading

    def was_published_recently(self):
        return self.timestamp >= timezone.now() - datetime.timedelta(days=1)