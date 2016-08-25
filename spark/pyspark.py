# -*- coding: utf-8 -*-
"""
Created on Wed Aug 10 09:37:42 2016

@author: zhangbo
"""

import numpy as np


#连接服务器

sql_query = HiveContext(sc)
query = "select imei, wallpaper_id from temp.wallpaper_history where action='set' and dt='20160822' and length(imei)=15 group by imei, wallpaper_id limit 100"
df = sql_query.sql(query).cache()
df.count()

#计算共现矩阵
df.sort("imei", ascending=False)
#组织数据为笛卡尔积的结构，同时设定为key
occurrence = df.join(df).map(lambda x: ((x[1],x[3]), 1))
occurrence.count()
occurrence.take(30)

#合并数据，对key相同的数据累加
occurrence_matrix = occurrence.reduceByKey(lambda x,y: x+y)
occurrence_matrix.count()
occurrence_matrix.take(10)
users = df.collect()

#共现矩阵是对称矩阵，排序可以减少合并的数据量
def sort_by_id(x):
	id_1 = int(x[1])
	id_2 = int(x[3])
	if id_1 <= id_2:
		res = ((id_1, id_2), 1)
	else:
		res = ((id_2, id_1), 1)
	return res

occurrence_2 = df.join(df).map(sort_by_id)
occurrence_2.count()
occurrence_matrix_2 = occurrence_2.reduceByKey(lambda x,y: x+y)
occurrence_matrix_2.count()
occurrence_matrix_2.take(100)



######################################################################
######################################################################
######################################################################
sql_query = HiveContext(sc)
query = "select imei, wallpaper_id from temp.wallpaper_history where action='set' and dt='20160822' and length(imei)=15 group by imei, wallpaper_id"
df = sql_query.sql(query).cache()
df.count()
df = df.map(list)

users_action_day = df.groupByKey()
users_action_day.count()
users_action_day.take(3)

item_frequency_day = df.map(lambda x:(x[1], 1)).reduceByKey(lambda x,y: x+y).sortBy(lambda x: x[1],ascending=False)
item_frequency_day.take(10)

#item_frequency_week = 
#item_frequency_week.take(20)

def users_to_matrix(user_items):
	wallpaper_list = [int(x) for x in user_items[1]]
	wallpaper_list = np.unique(wallpaper_list)
	wallpaper_list.sort()
	n = len(wallpaper_list)
	if n <= 1:
		return []
	result = []
	for i in range(n-1):
		for j in range(i+1, n):
			result.append([wallpaper_list[i], wallpaper_list[j]])
	return tuple(result)

def bbb(user_items):
	wallpaper_list = [int(x) for x in user_items[1]]
	wallpaper_list = np.unique(wallpaper_list)
	wallpaper_list.sort()
	return wallpaper_list

user_list = users_action_day.map(lambda x: x[0])
#user_history = get_user_history(user_list)

item_matrix_day = users_action_day.map(bbb)
item_matrix_day.take(3)





