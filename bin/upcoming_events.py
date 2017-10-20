#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
o365libdir = '/home/mmikhailov/repos-ext/python-o365'
sys.path.append(o365libdir)
url_base = 'https://outlook.office.com/owa/?'

from O365 import *
import json
import time
import urllib


if __name__ == '__main__':
	veh = open(o365libdir + '/pw/veh.pw','r').read()
	vj = json.loads(veh)

	schedules = []
	json_outs = {}

	for veh in vj:
		e = veh['email']
		p = veh['password']

		schedule = Schedule((e,p))
		try:
			result = schedule.getCalendars()
		except:
			print('Login failed for',e)

		bookings = []

		for cal in schedule.calendars:
                        if cal.getName() == 'United States holidays':
                            continue
			#print('attempting to fetch events for',e)
                        start = time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime(time.time()-30))
                        end = time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime(time.time()+8*3600))
                        result = cal.getEvents(start, end, 100)
                        #print('Got events',result,'got',len(cal.events))
			for event in cal.events:
                            starttime_local = time.localtime(time.mktime(event.getStart())-time.timezone)
                            request_template = { 'viewmodel' : 'ICalendarItemDetailsViewModelFactory', 'ItemID' : event.json['Id'] }
                            url = url_base + urllib.urlencode(request_template).replace('_', '%2B').replace('-', '%2F')
                            print(time.strftime("%Y-%m-%dT%H:%M:%S", starttime_local) + " " + url + " " + event.getSubject().encode('utf-8'))
