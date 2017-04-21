# -*- encoding:gb2312 -*-

## Notes
# For use with Python 2.7 on Win32
# Encoding GB2312 (Compatible with cmd locale zh-CN)

## Copyright
# (C) 2017, Ricyn Lee 李锐森

## Codes begin ################################################################
import sys, re

CMD_USAGE = \
'''TwoWaySync命令行用法
tws --left $LEFT_FOLDER     # 左侧文件夹,必选选项
    --right $RIGHT_FOLDER   # 右侧文件夹,必选选项
    --report $REPORT_FILE   # 报告文件路径,
                            # 若不指定或留空,报告到屏幕
    --source=$SRC           # 同步源: l|left|r|right|m|mutual,
                            # 若不指定,则只生成比对报告'''
## 全局量
class OPT:
    left      = ''
    right     = ''
    operation = 0  # 0:报告; 1:左到右; 2:右到左; 3:更新同步, Optional
    report    = '' # 报告文件路径, Optional
## 函数
# 获取选项
def getoa():
    global OPT
    getopt = lambda paramstr: paramstr[paramstr.find('=')+1:]
    match  = lambda pattern, arg: True if re.match(pattern,arg) else False
    try:
        for i in range(1,len(sys.argv)):
            arg=sys.argv[i]
            if match('--left',arg):
                OPT.left=sys.argv[i+1]
            elif match('--right',arg):
                OPT.right=sys.argv[i+1]
            elif match('--report',arg):
                OPT.report=sys.argv[i+1]
            elif match('--source=',arg):
                src=getopt(arg)
                if src.lower() in ('l','left'):
                    OPT.operation=1
                elif src.lower() in ('r','right'):
                    OPT.operation=2
                elif src.lower() in ('m','mutual'):
                    OPT.operation=3
                else: # 参数非法
                    return False
            elif match('--',arg): # 出现非法选项
                return False
    except: # 解析出错
        return False
    if OPT.left and OPT.right:
        return True
    else: # 缺少必选选项
        return False
