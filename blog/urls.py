from django.conf.urls import *
from blog.views import home


urlpatterns = patterns('',
                      url(r'^$',home),
                      )
