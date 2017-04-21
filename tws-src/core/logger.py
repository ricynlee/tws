# -*- encoding:gb2312 -*-

## Notes
# For use with Python 2.7 on Win32
# Encoding GB2312 (Compatible with cmd locale zh-CN)

## Copyright
# (C) 2017, Ricyn Lee ����ɭ

## Codes begin ################################################################
import sys, time

## ȫ����
LOG_OBJECT = None
LOG_TIMESTAMP = False

## ����
# ��Ϣ���
def log_begin(timestamp=False,log_path=''): # log_pathΪ�ձ�ʾ�������Ļ
    global LOG_OBJECT, LOG_TIMESTAMP
    try:
        if log_path:
            LOG_OBJECT=open(log_path,'wt')
        else:
            LOG_OBJECT=sys.stdout
        LOG_TIMESTAMP=timestamp
    except:
        pass # ��Log�ļ�����,��������δʵ��
        print('Log error')

def log_end():
    global LOG_OBJECT
    if LOG_OBJECT and LOG_OBJECT!=sys.stdout:
        LOG_OBJECT.close()

def log(msg):
    global LOG_OBJECT, LOG_TIMESTAMP
    if not LOG_OBJECT:
        return # û��log_begin�Ͳ����
    log_timestamp = lambda: '%s' % time.ctime()
    ts=(log_timestamp()+': ') if LOG_TIMESTAMP else ''
    LOG_OBJECT.write('%s%s\n' % (ts, msg))
