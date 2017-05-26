# -*- encoding:gb2312 -*-

## Notes
# For use with Python 2.7 on Win32
# Encoding GB2312 (Compatible with cmd locale zh-CN)

## Copyright
# (C) 2017, Ricyn Lee ����ɭ

## Codes begin ################################################################
from filecmp import dircmp
from filesys import *
from logger import *
from arg2opt import *
import os, sys, time

## ȫ����
LEFT_ONLY_ITEMS  = [] # ��س�ʼ��Ϊ���б�
RIGHT_ONLY_ITEMS = []
DIFFERENT_FILES  = []

## ����
def cmp_iter(dc): # type(dc) is dircmp
    global  LEFT_ONLY_ITEMS, RIGHT_ONLY_ITEMS, DIFFERENT_FILES
    try:
        log('[i] ���� %s' % rmbase(OPT.left,dc.left))
        LEFT_ONLY_ITEMS += \
          [pathcat(rmbase(OPT.left, dc.left ),item) for item in dc.left_only]
        RIGHT_ONLY_ITEMS += \
          [pathcat(rmbase(OPT.right,dc.right),item) for item in dc.right_only]
        DIFFERENT_FILES += \
          [pathcat(rmbase(OPT.left, dc.left ),item) for item in dc.diff_files]
        for subdir in dc.subdirs.itervalues():
            cmp_iter(subdir)
    except:
        log('[X] �޷����� %s' % rmbase(OPT.left,dc.left))

def compare(left_root,right_root):
    LEFT_ONLY_ITEMS=[]
    RIGHT_ONLY_ITEMS=[]
    DIFFERENT_FILES=[]
    left_root  += (os.sep if left_root[-1]!=os.sep else "")
    right_root += (os.sep if right_root[-1]!=os.sep else "")
    cmp_iter(dircmp(left_root,right_root))

def report(file=''): # �ļ�Ϊ���򱨸浽��Ļ
    # Report file should NOT be manually modified
    global  LEFT_ONLY_ITEMS, RIGHT_ONLY_ITEMS, DIFFERENT_FILES
    try:
        if file:
            report_file=open(file,'w')
        else:
            report_file=sys.stdout
    except:
        pass # �򿪱����ļ�����,��������δʵ��
        log('[X] �޷����ʱ����ļ�')
        return

    # ��������
    report_timestamp = lambda: '%s' % time.strftime("%Y-%m-%d,%H:%M:%S",time.localtime())
    report_write = lambda s: report_file.write('%s' % s.decode('gbk').encode('utf-8'))

    report_write('REPORT@%s\n' % report_timestamp())
    report_write('LEFT=%s\n' % OPT.left)
    report_write('RIGHT=%s\n' % OPT.right)
    report_write('LEFT-ONLY ITEMS:\n')
    for i in LEFT_ONLY_ITEMS:
        if os.path.isdir(pathcat(OPT.left,i)):
            report_write('%s|D\n' % i)
        else:
            report_write('%s|F\n' % i)
    report_write('RIGHT-ONLY ITEMS:\n')
    for i in RIGHT_ONLY_ITEMS:
        if os.path.isdir(pathcat(OPT.right,i)):
            report_write('%s|D\n' % i)
        else:
            report_write('%s|F\n' % i)
    report_write('DIFFERENT FILES:\n')
    for i in DIFFERENT_FILES:
        if getmod(pathcat(OPT.left,i))>getmod(pathcat(OPT.right,i)):
            report_write('%s|L\n' % i)
        else:
            report_write('%s|R\n' % i)
    # �رձ����ļ�
    if report_file and report_file!=sys.stdout:
        report_file.close()

def read_report(file):
    # Report file should NOT be manually modified
    global  LEFT_ONLY_ITEMS, RIGHT_ONLY_ITEMS, DIFFERENT_FILES
    try:
        report_file=open(file,'r')
    except:
        pass # �򿪱����ļ�����,��������δʵ��
        log('[X] �޷����ʱ����ļ�')
        return

    # ��������
    report_timestamp = int(time.mktime(time.strptime(f.readline().replace('REPORT@','',1),"%Y-%m-%d,%H:%M:%S")))
    report_left = report_file.readline().replace('LEFT=','',1)
    report_right = report_file.readline().replace('RIGHT=','',1)

    LEFT_ONLY_ITEMS=[]
    RIGHT_ONLY_ITEMS=[]
    DIFFERENT_FILES=[]

    report_file.readline() # 'LEFT-ONLY ITEMS:'

    while(True): # left-only
        line = report_file.readline()
        if line=='RIGHT-ONLY ITEMS:':
            break
        LEFT_ONLY_ITEMS+=line.split("|")[0]

    while(True): # right-only
        line = report_file.readline()
        if line=='DIFFERENT FILES:':
            break
        RIGHT_ONLY_ITEMS+=line.split("|")[0]

    while(True): # different
        line = report_file.readline()
        if not line:
            break
        DIFFERENT_FILES+=line.split("|")[0]

    return report_timestamp,report_left,report_right

## ������
log_begin()

if not getoa():
    log('[X] �����д���')
    print CMD_USAGE
    log_end(); exit()

log('[i] ��ʼ�ȶ� ���:%s �Ҳ�:%s' % (OPT.left,OPT.right))
if OPT.report_as_cmp:
    try:
        report_timestamp,report_left,report_right=read_report(OPT.report)
        # �˴�����֤�����ļ�������
        log('[i] �Ѿ���ȡ�����ļ���Ϊ�ļ��бȶԽ��')
    except:
        log('[X] �޷�ʹ�ñ����ļ���Ϊ�ļ��бȶԽ��')
        log_end(); exit()
else:
    try:
        compare(OPT.left,OPT.right)
        log('[i] ��ɱȶ� ���ɲ��챨��')
    except:
        log('[X] �ļ��бȶ�ʧ��')
        log_end(); exit()

report(OPT.report)

if OPT.operation:
    log('[i] ��ʼͬ��')

if OPT.operation==1: # ��->��
    for i in LEFT_ONLY_ITEMS:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        log('[!] ����%s' % l)
        if not fscpy(l,r):
            log('[X] ����ʧ��')
    for i in RIGHT_ONLY_ITEMS:
        r=pathcat(OPT.right,i)
        log('[!] ɾ��%s' % r)
        if not fsdel(r):
            log('[X] ����ʧ��')
    for i in DIFFERENT_FILES:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        log('[!] ����%s' % r)
        if not fscpy(l,r):
            log('[X] ����ʧ��')
elif OPT.operation==2: # ��->��
    for i in LEFT_ONLY_ITEMS:
        l=pathcat(OPT.left,i)
        log('[!] ɾ��%s' % l)
        if not fsdel(l):
            log('[X] ����ʧ��')
    for i in RIGHT_ONLY_ITEMS:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        log('[!] ����%s' % r)
        if not fscpy(r,l):
            log('[X] ����ʧ��')
    for i in DIFFERENT_FILES:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        log('[!] ����%s' % l)
        if not fscpy(r,l):
            log('[X] ����ʧ��')
elif OPT.operation==3: # �໥����
    for i in LEFT_ONLY_ITEMS:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        log('[!] ����%s' % l)
        if not fscpy(l,r):
            log('[X] ����ʧ��')
    for i in RIGHT_ONLY_ITEMS:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        log('[!] ����%s' % r)
        if not fscpy(r,l):
            log('[X] ����ʧ��')
    for i in DIFFERENT_FILES:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        if getmod(l)<getmod(r):
            log('[!] ����%s' % l)
            if not fscpy(r,l):
                log('[X] ����ʧ��')
        else:
            log('[!] ����%s' % r)
            if not fscpy(l,r):
                log('[X] ����ʧ��')

log_end()
