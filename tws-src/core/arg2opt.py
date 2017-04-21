# -*- encoding:gb2312 -*-

## Notes
# For use with Python 2.7 on Win32
# Encoding GB2312 (Compatible with cmd locale zh-CN)

## Copyright
# (C) 2017, Ricyn Lee ����ɭ

## Codes begin ################################################################
import sys, re

CMD_USAGE = \
'''TwoWaySync�������÷�
tws --left $LEFT_FOLDER     # ����ļ���,��ѡѡ��
    --right $RIGHT_FOLDER   # �Ҳ��ļ���,��ѡѡ��
    --report $REPORT_FILE   # �����ļ�·��,
                            # ����ָ��������,���浽��Ļ
    --source=$SRC           # ͬ��Դ: l|left|r|right|m|mutual,
                            # ����ָ��,��ֻ���ɱȶԱ���'''
## ȫ����
class OPT:
    left      = ''
    right     = ''
    operation = 0  # 0:����; 1:����; 2:�ҵ���; 3:����ͬ��, Optional
    report    = '' # �����ļ�·��, Optional
## ����
# ��ȡѡ��
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
                else: # �����Ƿ�
                    return False
            elif match('--',arg): # ���ַǷ�ѡ��
                return False
    except: # ��������
        return False
    if OPT.left and OPT.right:
        return True
    else: # ȱ�ٱ�ѡѡ��
        return False
