from django.urls import path

from . import views
from fpgaCounter import views

app_name = 'fpgaCounter'
urlpatterns = [
    path('', views.Detail, name="Board"),
    path('LED0_ON', views.LED0_ON, name="scriptLEDON"),
    path('LED0_OFF', views.LED0_OFF, name="scriptLEDOFF"),
    path('HelloWorld', views.HelloWorld, name="HelloWorld"),
    ]