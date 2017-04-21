# TWS (two-way sync)

**点击这里[下载](https://github.com/ricynlee/tws/releases).**

TWS可以用来给本地文件夹做备份，比如让`D:\Data`和（移动硬盘）`E:\Data`保持同步，支持单向同步、双向同步、文件夹对比。同步思想就是只操作不同的数据，适合总量几百GB、平时会小幅度修改的数据同步。文件夹对比结果使用dtree在网页上树状显示。

类似的软件很多，但是总感觉界面复杂，不喜欢用；TWS的界面应该算是简单的。界面实际上只是一个接口，实现同步的是Python脚本。

TWS是一个对我而言比较实用，但是代码（尤其是界面部分）写的很烂的程序。而且界面主要还是用极其过时的Visual Basic 6.0做的。

***

TWS在制作时比较混乱，这里要写一个成形的软件目录树，提醒自己文件编译生成了放在哪里。
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
    |--- ...
```

***

* 目前感觉最要改进的  
  同步之前我可能先对比一下双方，对比完之后发现可以直接同步（就是类似git无需手动解决冲突），就开始同步。但是这次同步目前不能直接调用之前文件夹比对好的结果。
