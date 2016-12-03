#!/usr/bin/python
import zipfile
import sys
import string
import vim

zf = zipfile.ZipFile(vim.eval("line"), 'r')
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
    formattedName = string.replace(className, '/', '.')[:-6]
    vim.command(':call add(list, "' + formattedName + '")')

