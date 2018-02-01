import zipfile
import sys
import string
import vim
import os.path

filename = vim.eval('line')

if os.path.isfile(filename):
    zf = zipfile.ZipFile(filename, 'r')
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
else:
    vim.command(':echom "filename ' + filename + ' was not found"')
