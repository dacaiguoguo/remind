from django.conf.urls import *
from polls.views import home

 
urlpatterns = patterns('',
                      url(r'^$',home),
                      )
