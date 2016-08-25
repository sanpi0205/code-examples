# -*- coding: utf-8 -*-


from pyhive import hive
host = '0.0.0.0'
port = 10000

hiveConn = hive.connect(host=host, port=port)
cursor = hiveConn.cursor()

query = 'select * from table'
cursor.execute(query)
aa = cursor.fetchall()
print len(aa)
hiveConn.close()
