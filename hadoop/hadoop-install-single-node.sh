#!/bin/sh

#  hadoop.sh
#  
#
#  Created by zhangbo on 15/5/27.
#

# 参见来源： http://www.bogotobogo.com/Hadoop/BigData_hadoop_Install_on_ubuntu_single_node_cluster.php

sudo apt-get update
sudo apt-get install vim



# add new user and group
sudo addgroup hadoop
sudo adduser --ingroup hadoop hduser
sudo adduser hduser sudo

# 切换用户
su hduser

#install ssh
sudo apt-get install ssh
# generate ssh key
ssh-keygen -t rsa -P ""
# check if ssh works
ssh localhost
exit
# add public key in to authorized keys
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

# install java
sudo apt-get install openjdk-7-jdk


# download hadoop
wget http://mirrors.cnnic.cn/apache/hadoop/common/hadoop-2.7.0/hadoop-2.7.0.tar.gz
# unzip hadoop
tar xzvf hadoop-2.7.0.tar.gz
cd hadoop-2.7.0

# create hadoop directory
sudo mkdir /usr/local/hadoop
sudo chown -R hduser:hadoop /usr/local/hadoop
sudo mv * /usr/local/hadoop

# setup configuration file
# ~/.bashrc
# /usr/local/hadoop/etc/hadoop/hadoop-env.sh
# /usr/local/hadoop/etc/hadoop/core-site.xml
# /usr/local/hadoop/etc/hadoop/mapred-site.xml.template
# /usr/local/hadoop/etc/hadoop/hdfs-site.xml

# shwo the path of java
update-alternatives --config java

# 修改初始文件
vim ~/.bashrc

# add the configuration information into ~/.bashrc at the bottom
#HADOOP VARIABLES START
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 #
export HADOOP_INSTALL=/usr/local/hadoop
export PATH=$PATH:$HADOOP_INSTALL/bin
export PATH=$PATH:$HADOOP_INSTALL/sbin
export HADOOP_MAPRED_HOME=$HADOOP_INSTALL
export HADOOP_COMMON_HOME=$HADOOP_INSTALL
export HADOOP_HDFS_HOME=$HADOOP_INSTALL
export YARN_HOME=$HADOOP_INSTALL
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib"
#HADOOP VARIABLES END

#
source ~/.bashrc

# 配置hadoop文件
# set JAVA_HOME for hadoop
vim /usr/local/hadoop/etc/hadoop/hadoop-env.sh
# config the java path
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

# 配置core-site.xml
sudo mkdir -p /app/hadoop/tmp
sudo chown hduser:hadoop /app/hadoop/tmp

vim /usr/local/hadoop/etc/hadoop/core-site.xml
# 增加配置文件
<configuration>
 <property>
  <name>hadoop.tmp.dir</name>
  <value>/app/hadoop/tmp</value>
  <description>A base for other temporary directories.</description>
 </property>

 <property>
  <name>fs.default.name</name>
  <value>hdfs://localhost:54310</value>
  <description>The name of the default file system.  A URI whose
  scheme and authority determine the FileSystem implementation.  The
  uri's scheme determines the config property (fs.SCHEME.impl) naming
  the FileSystem implementation class.  The uri's authority is used to
  determine the host, port, etc. for a filesystem.</description>
 </property>
</configuration>

# 配置 mapred-site.xml
cp /usr/local/hadoop/etc/hadoop/mapred-site.xml.template /usr/local/hadoop/etc/hadoop/mapred-site.xml

vim /usr/local/hadoop/etc/hadoop/mapred-site.xml

<configuration>
 <property>
  <name>mapred.job.tracker</name>
  <value>localhost:54311</value>
  <description>The host and port that the MapReduce job tracker runs
  at.  If "local", then jobs are run in-process as a single map
  and reduce task.
  </description>
 </property>
</configuration>

# 配置hdfs-site.xml
sudo mkdir -p /usr/local/hadoop_store/hdfs/namenode
sudo mkdir -p /usr/local/hadoop_store/hdfs/datanode
sudo chown -R hduser:hadoop /usr/local/hadoop_store

vim /usr/local/hadoop/etc/hadoop/hdfs-site.xml
<configuration>
 <property>
  <name>dfs.replication</name>
  <value>1</value>
  <description>Default block replication.
  The actual number of replications can be specified when the file is created.
  The default is used if replication is not specified in create time.
  </description>
 </property>
 <property>
   <name>dfs.namenode.name.dir</name>
   <value>file:/usr/local/hadoop_store/hdfs/namenode</value>
 </property>
 <property>
   <name>dfs.datanode.data.dir</name>
   <value>file:/usr/local/hadoop_store/hdfs/datanode</value>
 </property>
</configuration>


# 格式化hdfs文件
hadoop namenode -format
start-all.sh







