# TWS (two-way sync)

**点击这里[下载](https://github.com/ricynlee/tws/releases).**

TWS可以用来给本地文件夹做备份，比如让`D:\Data`和（移动硬盘）`E:\Data`保持同步，支持单向同步、双向同步、文件夹对比。同步思想就是只操作不同的数据，适合总量几百GB、平时会小幅度修改的数据同步。文件夹对比结果使用dtree在网页上树状显示。

类似的软件很多，但是总感觉界面复杂，不喜欢用；TWS的界面应该算是简单的。界面实际上只是一个接口，实现同步的是Python程序。

TWS是一个对我而言比较实用，但是界面部分实现比较落后的程序：界面主要还是用极其过时的Visual Basic 6.0做的。

***

TWS release的文件目录。
```txt
tws-bin-amd64
|---tws.exe <主程序>
|---caller.exe <调用并等待Python脚本执行完成>
|---tws-report.dll <用于生成对比结果网页>
|---res <DIR,图像资源等>
|   |---about.exe   close-down.bmp  min-down.bmp
|   |---about.png   close-up.bmp    info-down.bmp
|   |---info-up.bmp min-up.bmp      msg-btn-up.bmp
|   |---going.bmp   to-go.bmp       msg-btn-down.bmp
|
|---core <DIR,实际同步文件的Python脚本>
|   |---arg2opt.py
|   |---filesys.py
|   |---logger.py
|   |---TwoWaySync.py
|
|---python <DIR,Python解释器>
|   |--- ...
|
|---report <DIR,用于生成对比报告的网页资源>
|   |--- ...
|---uninstall.bat <清理设置和中间文件（也可能是卸载）>
```

***

* VB6对学习GUI编程很友好,但是已经相当过时了.TWS提供了VB6定制GUI的方案,但是比对复杂的目录树很慢,实用价值有限.
