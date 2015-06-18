#!/usr/bin/python 
# -*- coding: utf8 -*-

from __future__ import print_function
import os
import mysql.connector
from mysql.connector import errorcode

DB_NAME = 'customes'

# 判断数据库是否存在，不存在则建立数据库
# source: http://dev.mysql.com/doc/connector-python/en/connector-python-example-ddl.html
# source: http://www.cnblogs.com/zhangzhu/archive/2013/07/04/3172486.html

cnx = mysql.connector.connect(user='root', password='', host='127.0.0.1')
cursor = cnx.cursor()

def create_dababase(cursor):
	try:
		cursor.execute("CREATE DATABASE {} DEFAULT CHARACTER SET 'utf8'".format(DB_NAME))
	except mysql.connector.Error as err:
		print( "创建数据库失败: {}".format(error) )
		exit(1)

try:
	print("创建数据库：{}".format(DB_NAME))
	cnx.database = DB_NAME
except mysql.connector.Error as err:
	if err.errno == errorcode.ER_BAD_DB_ERROR:
		create_dababase(cursor)
		cnx.database = DB_NAME
	else:
		print(err)
		exit(1)

TABLES= {}
# 创建企业表
TABLES['company'] = ( "CREATE TABLE `company` ( "
	"`id` int not null primary key auto_increment, "
	"`year` int, "
	"`month` int, "
	"`company_id` varchar(30), "
	"`owner_location_id` varchar(30), "
	"`commodity_name` varchar(200), "
	"`country_id` varchar(30), "
	"`amount_1` double, "
	"`unit_1` double, "
	"`amount_2` double, "
	"`unit_2` double, "
	"`rmb` double, "
	"`dollar` double, "
	"`tariff` double, "
	"`vat` double, "
	"`comsumption_tax` double, "
	"`fuel_tax` double,"
	"`antidumping_tax` double"
	")" )

# 创建商品表，注意如果商品表字段不同，则需补齐
TABLES['commodity'] = ( "CREATE TABLE `commodity` ("
	"`id` int not null primary key auto_increment, "
	"`year` int, "
	"`month` int, "
	"`commodity_id` varchar(30), "
	"`commodity_name` varchar(200), "
	"`country_id` varchar(30), "
	"`amount_1` double, "
	"`unit_1` double, "
	"`amount_2` double, "
	"`unit_2` double, "
	"`rmb` double, "
	"`dollar` double, "
	"`tariff` double, "
	"`vat` double, "
	"`comsumption_tax` double, "
    "`fuel_tax` double,"
	"`antidumping_tax` double"
	")" )

for name, ddl in TABLES.iteritems():
	#print(name)
	try:
		print("创建数据表: {}".format(name))
		cursor.execute(ddl)
	except mysql.connector.Error as err:
		if err.errno == errorcode.ER_TABLE_EXISTS_ERROR:
			print("数据表已经存在")
		else:
			print(err.msg)