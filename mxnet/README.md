# mxnet使用列表

## 1.安装
### OS安装

参见官网安装说明，但[BLAS和LAPACK安装][blas_install]，需要单独说明。
更好的办法是使用`homebrew`安装， `brew install openblas`[参见ref][brew_install]。

安装好之后，如果Python使用的是Anaconda的话，可能仍然无法加载mxnet，在配置文件中[设置路径][mxnet_path]

```
vim ~/.bash_profile

# add mxnet path
export PYTHONPATH="/Users/zhangbo/tools/mxnet/python/"
```




1. [blas_install]: https://pheiter.wordpress.com/2012/09/04/howto-installing-lapack-and-blas-on-mac-os/
2. [brew_install]: http://www.binwang.me/2015-11-08-install-blas-library-for-mxnet.html
3. [mxnet_path]: http://askubuntu.com/questions/623578/installing-blas-package

