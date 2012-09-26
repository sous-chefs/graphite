#!/usr/bin/env python

# cribbed from https://gist.github.com/97863dc8171c7b473c94#file_set_admin_password.py

import os,sys
sys.path.append("<%= node['graphite']['doc_root']%>/graphite")
os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'
from django.contrib.auth.models import User

username = sys.argv[1]
password = sys.argv[2]

try:
    u = User.objects.get(username__exact=username)
    u.set_password(password)
    u.save()
except:
    print "%s is not a user" % username
