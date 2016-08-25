# -*- coding: utf-8 -*-
"""
Created on Mon Aug 7 16:23:57 2016

@author: zhangbo

this is used for learing the location from the gps data:

id, longitude, latitude, time, radius

the algorithm use the same idea with hierarchical cluster algorithm,
but use the radius for calculating the distance.

And finally, return the location label with it is gps data.
"""
import math
import numpy as np

earth_radius = 6371.004 * 1000 #unit: meter

def cluster(data):
	'''data contains all the data and data is a list
	'''
	n = len(data)
	center = []
	# center: longitude, latitude, radius, center members, 
	# consume: longitude:[-180, 180], latitude:[0, 90]
	for i in range(n):
		longitude = data[1]
		latitude = data[2]
		upload_time = data[3]
		radius = data[4]	
		k = len(center)
	
		for j in range(k):
			#source: http://www.cnblogs.com/ycsfwhh/archive/2010/12/20/1911232.html
			#C = sin(MLatA)*sin(MLatB)*cos(MLonA-MLonB) + cos(MLatA)*cos(MLatB)
			#Distance = R*Arccos(C)*Pi/180
			center_longitude = center[j]['lon_sum'] / center[j]['members']
			center_latitude = center[j]['lat_sum'] / center[j]['members']
			center_radius = center[j]['radius_sum'] / center[j]['members']

			angle = math.sin(latitude) * math.sin(center_latitude) * math.cos(longitude - center_longitude) + math.cos(latitude) * math.cos(center_latitude)
			distance = earth_radius * math.acos(angle) * math.pi / 180
			if distance < (center_radius + radius):
				center[j]['lon_sum'] += longitude
				center[j]['lat_sum'] += latitude
				center[j]['radius_sum'] += radius
				center[j]['members'] += 1
				break #this means one gps data just belongs to one center
		#if there is no center that include this point, create a new center

		if k == 0 :
			lon_sum = longitude
			lat_sum = latitude
			radius_sum = radius
			members = 1
			center.append({"lon_sum":lon_sum, "lat_sum":lat_sum, "radius_sum": radius_sum, "members": members})
	return sorted(center, key=lambda k: k['members'], revers=True)






