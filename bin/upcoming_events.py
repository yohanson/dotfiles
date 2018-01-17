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
			#print('attempting to fetch events for',cal.getName())
                        start = time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime(time.time()-30))
                        end = time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime(time.time()+8*3600))
                        result = cal.getEvents(start, end, 100)
                        #print('Got events',result,'got',len(cal.events))
			for event in cal.events:
                            if event.json['IsAllDay']:
                                continue
                            if event.json['IsCancelled']:
                                continue
                            starttime_local = time.localtime(time.mktime(event.getStart())-time.timezone)
                            request_template = { 'viewmodel' : 'ICalendarItemDetailsViewModelFactory', 'ItemID' : event.json['Id'] }
                            url = url_base + urllib.urlencode(request_template).replace('_', '%2B').replace('-', '%2F')
                            if event.json['Location']['DisplayName'].find('webex') > -1 or \
                                    event.getBody().find('.webex.com/join') > -1:
                                location = 'webex'
                            else:
                                location = 'offline'
                            if (len(sys.argv) > 1) and (sys.argv[1] == '--verbose'):
                                print(time.strftime("%Y-%m-%dT%H:%M:%S", starttime_local) + " " + url + " " + location + " " + event.getSubject().encode('utf-8') + event.getBody().encode('utf-8'))
                                print(event.json)
                            else:
                                print(time.strftime("%Y-%m-%dT%H:%M:%S", starttime_local) + " " + url + " " + location + " " + event.getSubject().encode('utf-8'))
