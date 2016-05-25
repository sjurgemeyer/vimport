#!/usr/bin/python
import zipfile
import sys
import string

zf = zipfile.ZipFile(sys.argv[1], 'r')
classFiles = []
try:
    info = zf.infolist()
    for zi in info:
        fn = zi.filename
        if fn.endswith('.class'):
            classFiles.append(fn)
finally:
    zf.close()

classFiles.sort()
for className in classFiles:
    print string.replace(className, '/', '.')[:-6]
