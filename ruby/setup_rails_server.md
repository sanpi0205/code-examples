安装配置Rails Server
===================

## 安装RVM
RMV是用于管理Ruby版本非常好用的工具，是Ruby on Rails开发必不可少的工具之一。
RVM安装命令为：

	\curl -sSL https://get.rvm.io | bash -s stable

参见 [RVM官网](http://www.rvm.io) 和 [Ruby China](https://ruby-china.org/topics/576) 的使用说明。
在安装好RVM后，建议修改RVM源为 [Ruby淘宝](http://ruby.taobao.org)，提高Ruby版本安装速度。

Mac修改RVM源

	sed -i .bak 's!cache.ruby-lang.org/pub/ruby!ruby.taobao.org/mirrors/ruby!' $rvm_path/config/db

Linux修改RVM源

	sed -i 's!cache.ruby-lang.org/pub/ruby!ruby.taobao.org/mirrors/ruby!' $rvm_path/config/db


## 安装 RUby
有了RVM后，安装Ruby将非常方便，RVM会自动安装Ruby依赖包，使用命令`rvm install 2.2.2`
即可从淘宝镜像网站安装最新Ruby版本。同时，查看当前安装版本可用命令 `rvm list`

安装好Ruby之后，建议修改gem源为Ruby淘宝，命令如下：

	gem sources -l
	gem sources --remove https://rubygems.org/
	gem sources -a https://ruby.taobao.org/
	gem sources -l


## 配置 gemset

