scripts of spark
====

# install spark
下载spark, 可能是由于网速的原因，如果下载spark的source code无法本地编译，所以直接下载编译好的版本。

	wget http://mirrors.cnnic.cn/apache/spark/spark-1.3.1/spark-1.3.1-bin-hadoop2.6.tgz
	tar -xvzf spark-1.3.1-bin-hadoop2.6.tgz
	cd spark-1.3.1-bin-hadoop2.6.tgz
	bin/pyspark  # bin/spark-shell打开Scala版本
	# 可以使用IPython 或者 IPython Notebook
	IPYTHON = 1 ./bin/pyspark
	IPYTHON_OPTS = "notebook" ./bin/pyspark

# 