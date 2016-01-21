# Python常用代码总结

[toc]

## 频次统计

统计list中每个元素出现的频次

```python

#方法一： 返回dict
arr = ['a','a','b','b','b','c']

arrFrequency = {}
for element in arr:
	if element not in arrFrequency.keys():
		arrFrequency[element] = 1
	else:
		arrFrequency[element] += 1
	#或者使用dict的get方法，如果错误返回0
	#arrFrequency[element] = arrFrequency.get(element, 0) + 1 
print arrFrequency

#方法二： count函数，返回tuple
uniqueValues = set(arr)
arrFrequency = [(element, arr.count(element)) for element in uniqueValues]

```

个人认为使用dict方法效率更高

## dict排序

对dict中数据按照某个迭代器排序

```python
import operator

#接着上文例子中的数据，按照降序排列
sortedArray = sorted(arrFrequency.iteritems(), key=operator.itemgetter(1), reverse=True)

#按照升序排列
sortedArray = sorted(arrFrequency.iteritems(), key=operator.itemgetter(1))

```


