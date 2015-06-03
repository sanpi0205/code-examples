#!/usr/bin/python 

# 资料来源：https://automatetheboringstuff.com/chapter8/

# 导入文件模块
import os

# 获得当前工作目录
os.getcwd()

# 列出当前工作目录文件
os.listdir(os.getcwd())
for fileName in os.listdir(os.getcwd()):
	print(fileName)

# 改变工作目录
os.chdir('/User') # 不同操作系统下文件目录的不同

# 查看文件大小
os.path.getsize('fileName')

# 检查文件与目录， 注意相对路径和据对路径
os.path.exists(path)
os.path.isfile(path)
os.path.isdir(path)

# 文件读写操作
log = open('development.log') #获得文件对象
errorFile = open('errorFile.txt', 'w') # 文件输出对象，参数可不同 'w'->'a'

errorNum = 0
for line in log.readlines():  # 按行读取文件内容
	if 'error' in line:
		errorNum += 1
		#print(line)
		errorFile.write(line)

errorFile.close()
log.close()

# 保存变量
import shelve
shelfFile = shelve.open('mydata')
cats = ['Zophie', 'Pooka', 'Simon']
shelfFile['cats'] = cats
shelfFile.close()
# 读取变量
shelfFile = shelve.open('mydata')
type(shelfFile)
shelfFile['cats']

# 列出文件中变量
list(shelfFile.keys())
list(shelfFile.values())
shelfFile.close()

# 用pprint.pformat()存储变量
import pprint
cats = [{'name': 'Zophie', 'desc': 'chubby'}, {'name': 'Pooka', 'desc': 'fluffy'}]
fileObj = open('myCats.py', 'w')
fileObj.write('cats = ' + pprint.pformat(cats) + '\n')
fileObj.close()
# 读取数据
import myCats
 myCats.cats
 