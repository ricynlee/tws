# -*- encoding:gb2312 -*-

## Notes
# For use with Python 2.7 on Win32
# Encoding GB2312 (Compatible with cmd locale zh-CN)

## Copyright
# (C) 2017, Ricyn Lee ����ɭ

'''
File system operations
'''

## Codes begin ################################################################
import os, shutil

## ����
# �����ļ����ļ���
def fscpy(srcpath,dstpath):
    try:
        if os.path.isdir(srcpath):
            shutil.copytree(srcpath,dstpath)
            # �������ļ��޸�ʱ��,Ҫ��Ŀ��·��������(Ӧ�ñ�������)
        else:
            shutil.copy2(srcpath,dstpath)
            # �����ļ��޸�ʱ��(copy����������),Ŀ���ļ������򸲸�
        return True
    except:
        pass # ����ʧ��,��������δʵ��
        return False

# ɾ���ļ����ļ���
def fsdel(path):
    try:
        if os.path.isdir(path):
            shutil.rmtree(path)
        else:
            os.remove(path)
        return True
    except:
        pass # �ļ�ɾ��ʧ�ܴ�����,��δʵ��
        return False

# ��ȡ�ļ��޸�ʱ��
def getmod(filepath):
    r'����float,Խ��Խ��' # __doc__
    try:
        return os.path.getmtime(filepath)
    except:
        pass # ������δʵ��
        return None

# �������·��
def rmbase(base,path):
    path=path[len(base):]
    if len(path)==0:
        path="."+os.sep;
    elif path[0]==os.sep:
        path="."+path
    else:
        path="."+os.sep+path
    return path

# ·���ַ�������
def pathcat(path_a,path_b):
    return  path_a + \
            (os.sep if path_a[-1]!=os.sep else "") + \
            path_b.replace("."+os.sep,"")

# �ж�·���Ƿ���Ч�ļ���
def isdir(path):
    return os.path.exists(path) and (not os.path.isfile(path))

