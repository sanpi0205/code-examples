#coding=utf-8
#!/usr/bin/python


### 资料来源：http://nbviewer.ipython.org/gist/wrobstory/1eb8cb704a52d18b9ee8/Up%20and%20Down%20PyData%202014.ipynb

# 导入文件模块
import ggplot as gg
from ggplot import ggplot
import numpy as np
import pandas as pd

df = pd.read_csv('/Users/zhangbo/github/pydatasv2014/USGS_WindTurbine_201307_cleaned.csv')
min_heights = df[df['Rotor Diameter'] > 10]

(ggplot(gg.aes(x='Turbine MW', y='Rotor Swept Area'), data=min_heights[:500])
    + gg.geom_point(color='#75b5aa', size=75)
    + gg.ggtitle("Rotor Swept Area vs. Power")
    + gg.xlab("Power (MW)")
    + gg.ylab("Rotor Swept Area (m^2)"))
