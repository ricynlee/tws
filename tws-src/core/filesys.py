# -*- encoding:gb2312 -*-

## Notes
# For use with Python 2.7 on Win32
# Encoding GB2312 (Compatible with cmd locale zh-CN)

## Copyright
# (C) 2017, Ricyn Lee 李锐森

'''
File system operations
'''

## Codes begin ################################################################
import os, shutil

## 函数
# 拷贝文件或文件夹
def fscpy(srcpath,dstpath):
    try:
        if os.path.isdir(srcpath):
            shutil.copytree(srcpath,dstpath)
            # 保留子文件修改时间,要求目的路径不存在(应用背景满足)
        else:
            shutil.copy2(srcpath,dstpath)
            # 保留文件修改时间(copy函数不保留),目的文件存在则覆盖
        return True
    except:
        pass # 拷贝失败,错误处理尚未实现
        return False

# 删除文件或文件夹
def fsdel(path):
    try:
        if os.path.isdir(path):
            shutil.rmtree(path)
        else:
            os.remove(path)
        return True
    except:
        pass # 文件删除失败错误处理,尚未实现
        return False

# 获取文件修改时间
def getmod(filepath):
    r'返回float,越大越新' # __doc__
    try:
        return os.path.getmtime(filepath)
    except:
        pass # 错误处理未实现
        return None

# 保留相对路径
def rmbase(base,path):
    path=path[len(base):]
    if len(path)==0:
        path="."+os.sep;
    elif path[0]==os.sep:
        path="."+path
    else:
        path="."+os.sep+path
    return path

# 路径字符串连接
def pathcat(path_a,path_b):
    return  path_a + \
            (os.sep if path_a[-1]!=os.sep else "") + \
            path_b.replace("."+os.sep,"")

# 判断路径是否有效文件夹
def isdir(path):
    return os.path.exists(path) and (not os.path.isfile(path))

