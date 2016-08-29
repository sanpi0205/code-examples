# -*- coding: utf-8 -*-
"""
Created on Thu Jul 28 17:33:42 2016

@author: zhangbo
"""

import pymongo

#moggo连接多个数据库
mongo_url = "mongodb://user:pass@ip_1:port_1,ip_2:port_2"
client = pymongo.MongoClient(mongo_url)

db = client.db
collection = db.collection

ids = collection.find({'_id':123456})



