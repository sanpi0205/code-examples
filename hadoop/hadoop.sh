#!/bin/sh

#  hadoop.sh
#  
#
#  Created by zhangbo on 15/5/27.
#

sudo apt-get update

#install ssh
sudo apt-get install ssh
# generate ssh key
ssh-keygen -t rsa -P ""
# check if ssh works
ssh localhost
# add public key in to authorized keys
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

# install java
sudo apt-get install openjdk-7-jdk

# download hadoop
wget http://mirrors.cnnic.cn/apache/hadoop/common/hadoop-2.7.0/hadoop-2.7.0.tar.gz
# unzip hadoop
tar xzvf hadoop-2.7.0.tar.gz

# create hadoop directory
sudo mkdir /usr/local/hadoop
cd hadoop-2.7.0.tar.gz
sudo mv * /usr/local/hadoop

# setup configuration file
# ~/.bashrc
# /usr/local/hadoop/etc/hadoop/hadoop-env.sh
# /usr/local/hadoop/etc/hadoop/core-site.xml
# /usr/local/hadoop/etc/hadoop/mapred-site.xml.template
# /usr/local/hadoop/etc/hadoop/hdfs-site.xml

# shwo the path of java
update-alternatives --config java
#
sudo vim ~/.bashrc

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

# set JAVA_HOME for hadoop
sudo vim /usr/local/hadoop/etc/hadoop/hadoop-env.sh
# config the java path
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64



