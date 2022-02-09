from django.contrib import admin

from .models import Question

from .models import Choice

from fpgaCounter.models import Counter

admin.site.register(Question)

admin.site.register(Choice)

admin.site.register(Counter)
