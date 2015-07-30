# -*- coding: utf-8 -*-
from django.shortcuts import render, render_to_response
from django.http import HttpResponse
from django.template import Template, Context
from django.template.loader import get_template

import datetime
# Create your views here.
def home(requset):
    return HttpResponse(u"欢迎光临~ 大菜果果Blog!")
    
def current_datetime(request):
    now = datetime.datetime.now()
    t = Template("<Html><body>It is now {{current_date}}.</body></html>")
    html = t.render(Context({'current_date':now}))
    return HttpResponse(html)
    
def say_hello(request):
    t = Template("<Html><body>Hello ! {{name}}!</body></html>")
    return HttpResponse(t.render(Context({'name':"xiaoming"})))
    
def temp_current_time(request):
    now = datetime.datetime.now()
    t = get_template('hello.html')
    html = t.render(Context({'current_date':now}))
    return HttpResponse(html)
    
def render_current_time(request):
    now = datetime.datetime.now()
    return render_to_response('hello.html', {'current_date':now})
    
def localusetime(request):
    """use local()"""
    current_date = datetime.datetime.now()
    return render_to_response('hello.html', {'current_date':locals()})

