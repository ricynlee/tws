# -*- encoding:gb2312 -*-

## Notes
# For use with Python 2.7 on Win32
# Encoding GB2312 (Compatible with cmd locale zh-CN)

## Copyright
# (C) 2017, Ricyn Lee 李锐森

## Codes begin ################################################################
import sys, time

## 全局量
LOG_OBJECT = None
LOG_TIMESTAMP = False

## 函数
# 信息输出
def log_begin(timestamp=False,log_path=''): # log_path为空表示输出到屏幕
    global LOG_OBJECT, LOG_TIMESTAMP
    try:
        if log_path:
            LOG_OBJECT=open(log_path,'wt')
        else:
            LOG_OBJECT=sys.stdout
        LOG_TIMESTAMP=timestamp
    except:
        pass # 打开Log文件出错,错误处理尚未实现
        print('Log error')

def log_end():
    global LOG_OBJECT
    if LOG_OBJECT and LOG_OBJECT!=sys.stdout:
        LOG_OBJECT.close()

def log(msg):
    global LOG_OBJECT, LOG_TIMESTAMP
    if not LOG_OBJECT:
        return # 没有log_begin就不输出
    log_timestamp = lambda: '%s' % time.ctime()
    ts=(log_timestamp()+': ') if LOG_TIMESTAMP else ''
    LOG_OBJECT.write('%s%s\n' % (ts, msg))
