# -*- encoding:gb2312 -*-

## Notes
# For use with Python 2.7 on Win32
# Encoding GB2312 (Compatible with cmd locale zh-CN)

## Copyright
# (C) 2017, Ricyn Lee 李锐森

## Codes begin ################################################################
from filecmp import dircmp
from filesys import *
from logger import *
from arg2opt import *
import os, sys, time

## 全局量
LEFT_ONLY_ITEMS  = [] # 务必初始化为空列表
RIGHT_ONLY_ITEMS = []
DIFFERENT_FILES  = []

## 函数
def cmp_iter(dc): # type(dc) is dircmp
    global  LEFT_ONLY_ITEMS, RIGHT_ONLY_ITEMS, DIFFERENT_FILES
    try:
        log('[i] 分析 %s' % rmbase(OPT.left,dc.left))
        LEFT_ONLY_ITEMS += \
          [pathcat(rmbase(OPT.left, dc.left ),item) for item in dc.left_only]
        RIGHT_ONLY_ITEMS += \
          [pathcat(rmbase(OPT.right,dc.right),item) for item in dc.right_only]
        DIFFERENT_FILES += \
          [pathcat(rmbase(OPT.left, dc.left ),item) for item in dc.diff_files]
        for subdir in dc.subdirs.itervalues():
            cmp_iter(subdir)
    except:
        log('[X] 无法访问 %s' % rmbase(OPT.left,dc.left))

def compare(left_root,right_root):
    left_root  += (os.sep if left_root[-1]!=os.sep else "")
    right_root += (os.sep if right_root[-1]!=os.sep else "")
    cmp_iter(dircmp(left_root,right_root))

def report(file=''): # 文件为空则报告到屏幕
    global  LEFT_ONLY_ITEMS, RIGHT_ONLY_ITEMS, DIFFERENT_FILES
    try:
        if file:
            report_file=open(file,'w')
        else:
            report_file=sys.stdout
    except:
        pass # 打开报告文件出错,错误处理尚未实现
        log('[X] 无法访问报告文件')
    # 报告内容
    report_timestamp = lambda: '%s' % time.ctime()
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
    # 关闭报告文件
    if report_file and report_file!=sys.stdout:
        report_file.close()

## 主程序
log_begin()

if not getoa():
    log('[X] 命令行错误')
    print CMD_USAGE
    log_end()
    exit()

log('[i] 开始比对 左侧:%s 右侧:%s' % (OPT.left,OPT.right))
compare(OPT.left,OPT.right)
log('[i] 完成比对 生成差异报告')

report(OPT.report)

if OPT.operation:
    log('[i] 开始同步')

if OPT.operation==1: # 左->右
    for i in LEFT_ONLY_ITEMS:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        log('[!] 备份%s' % l)
        if not fscpy(l,r):
            log('[X] 操作失败')
    for i in RIGHT_ONLY_ITEMS:
        r=pathcat(OPT.right,i)
        log('[!] 删除%s' % r)
        if not fsdel(r):
            log('[X] 操作失败')
    for i in DIFFERENT_FILES:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        log('[!] 更新%s' % r)
        if not fscpy(l,r):
            log('[X] 操作失败')
elif OPT.operation==2: # 右->左
    for i in LEFT_ONLY_ITEMS:
        l=pathcat(OPT.left,i)
        log('[!] 删除%s' % l)
        if not fsdel(l):
            log('[X] 操作失败')
    for i in RIGHT_ONLY_ITEMS:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        log('[!] 备份%s' % r)
        if not fscpy(r,l):
            log('[X] 操作失败')
    for i in DIFFERENT_FILES:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        log('[!] 更新%s' % l)
        if not fscpy(r,l):
            log('[X] 操作失败')
elif OPT.operation==3: # 相互更新
    for i in LEFT_ONLY_ITEMS:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        log('[!] 备份%s' % l)
        if not fscpy(l,r):
            log('[X] 操作失败')
    for i in RIGHT_ONLY_ITEMS:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        log('[!] 备份%s' % r)
        if not fscpy(r,l):
            log('[X] 操作失败')
    for i in DIFFERENT_FILES:
        l=pathcat(OPT.left,i)
        r=pathcat(OPT.right,i)
        if getmod(l)<getmod(r):
            log('[!] 更新%s' % l)
            if not fscpy(r,l):
                log('[X] 操作失败')
        else:
            log('[!] 更新%s' % r)
            if not fscpy(l,r):
                log('[X] 操作失败')

log_end()
