# -*- coding: utf-8 -*-
from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.
def index(requset):
    return HttpResponse(u"欢迎光临 大菜果果")
