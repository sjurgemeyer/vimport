"Configuration options
if !exists('g:vimport_map_keys')
    let g:vimport_map_keys = 1
endif

if !exists('g:vimport_insert_shortcut')
    let g:vimport_insert_shortcut='<leader>i'
endif

if !exists('g:vimport_list_file')
    let s:current_file=expand("<sfile>:h")
    let g:vimport_list_file = s:current_file . '/vimports.txt'
endif

if !exists('g:vimport_seperators')
    let g:vimport_seperators = ['domain', 'services', 'groovy', 'java', 'taglib', 'controllers', 'integration', 'unit']
endif

if !exists('g:vimport_auto_organize')
    let g:vimport_auto_organize = 1
endif

if !exists('g:vimport_auto_remove')
    let g:vimport_auto_remove = 1
endif

if !exists('s:vimport_import_lists') " filetypes mapped to files to use for class lookup
    :let s:vimport_import_lists = {'java':[], 'groovy':[], 'kotlin':[]}
endif

if !exists('g:vimport_file_extensions') " extensions to search when looking for imports via file
    let g:vimport_file_extensions = ['groovy', 'java', 'kt', 'kts']
endif

if !exists('g:vimport_search_path')
    let g:vimport_search_path = '.'
endif

if !exists('g:vimport_filetype_import_files')

    let s:current_file=expand("<sfile>:h:h") . "/data"
echom s:current_file
    let g:vimport_filetype_import_files = {
        \ 'java': [s:current_file . '/vimports_java.txt'],
        \ 'groovy': [s:current_file . '/vimports_java.txt', s:current_file . '/vimports_groovy.txt', s:current_file . '/vimports_grails.txt'],
        \ 'kotlin': [s:current_file . '/vimports_kotlin.txt']
    \ }
endif

function! InsertImport()
    :let original_pos = getpos('.')
    let classToFind = expand("<cword>")

    let filePathList = GetFilePathListFromFiles(classToFind)

    "Looking up class in text file
    if filePathList == []
       for line in s:vimport_import_lists[&filetype]
           let tempClassList = split(line, '\.')
           if len(tempClassList) && tempClassList[-1] == classToFind
                :call add(filePathList, line)
           endif
       endfor
    endif

    let pathList = []
    for f in filePathList
        let shouldCreateImport = ShouldCreateImport(f)
        if (shouldCreateImport)
            :call add(pathList, f)
        else
            return
        endif
    endfor
    let x = CreateImports(pathList)

    call setpos('.', original_pos)
endfunction

function! GetFilePathListFromFiles(classToFind)
    let filePathList = []
    for extension in g:vimport_file_extensions
        let searchString = '**/' . a:classToFind . '.' . extension
        let paths = globpath(g:vimport_search_path, searchString, 1)
        let multiplePaths = split(paths, '\n')
        for p in multiplePaths
            let package = GetPackageFromFile(p)
            let fullPath =  package . '.' . a:classToFind
            if (index(filePathList, fullPath) == -1)
                :call add(filePathList,fullPath)
            endif
        endfor
    endfor
    return filePathList
endfunction

function! CreateImports(pathList)
    if a:pathList == []
        echoerr "no file found"
    else
        for pa in a:pathList
            :let pos = getpos('.')
            :call VimportCreateImport(pa)
            :execute "normal " . (pos[1] + 1) . "G"
        endfor
        if (g:vimport_auto_remove)
            :call RemoveUnneededImports()
        endif
        if (g:vimport_auto_organize)
            :call OrganizeImports()
        endif
        if len(a:pathList) > 1
            echom "Warning: Multiple imports created!"
            for pa in a:pathList
                echom pa
            endfor
        endif
    endif
endfunction

function! VimportCreateImport(path)
    let import = 'import ' . a:path
    let extension = expand("%:e")
    if (extension == 'java')
        let formattedImport = import . ';'
    else
        let formattedImport = import
    endif

    let packageLine = GetPackageLineNumber(expand("%:p"))
    echom packageLine
    if packageLine > -1
        :execute "normal " . (packageLine + 1) . "Go"
    else
        :execute "normal gg"
    endif
    :execute "normal I" . formattedImport . "\<Esc>"
endfunction

function! ShouldCreateImport(path)
    let currentpackage = GetCurrentPackage()
    let importPackage = RemoveFileFromPackage(a:path)
    if importPackage != ''
        if importPackage != currentpackage
            :let starredImport = search(importPackage . "\\.\\*", 'nw')
            if starredImport > 0
                echom importPackage . '.* exists'
                return 0
            else
                :let existingImport = search(a:path . '\s*$', 'nw')
                if existingImport > 0
                    echom 'import already exists'
                    return 0
                else
                endif
            endif
        else
            echom "File is in the same package"
            return 0
        endif
    endif
    return 1
endfunction

function! GetCurrentPackage()
    return GetPackageFromFile(expand("%:p"))
endfunction

function! GetCurrentPackageFromPath()
    return ConvertPathToPackage(expand("%:r"))
endfunction

function! RemoveFileFromPackage(fullpath)
    return join(split(a:fullpath,'\.')[0:-2],'.')
endfunction

function! ConvertPathToPackage(filePath)
    let splitPath = split(a:filePath, '/')

    let idx = len(splitPath)
    for sep in g:vimport_seperators
        let tempIdx = index(splitPath, sep)
        if tempIdx > 0
            if tempIdx < idx
                let idx = tempIdx + 1
            endif
        endif
    endfor
    let trimmedPath = splitPath[idx :-1]

    return join(split(join(trimmedPath, '.'),'\.')[0:-2], '.')
endfunction

function! GetPackageFromFile(filePath)
    let packageDeclaration = GetPackageLine(a:filePath)
    let package = split(packageDeclaration, '\s')[-1]
    let package = substitute(package, ';', '', '')
    return package

endfunction

function! GetPackageLine(filePath)
    let fileLines = readfile(a:filePath, '', 20) " arbitrary limit on number of lines to read
    let line = match(fileLines, "^package")
    return fileLines[line]
endfunction

function! GetPackageLineNumber(filePath)
    let fileLines = readfile(a:filePath, '', 20) " arbitrary limit on number of lines to read
    let line = match(fileLines, "^package")
    return line
endfunction

command! InsertImport :call InsertImport()
map <D-i> :InsertImport <CR>

function! OrganizeImports()
    :let pos = getpos('.')

    let lines = GrabImportBlock()
    if lines == []
        " No imports to organize
        return
    endif

    :let currentprefix = ''
    :let currentline = ''
    :let firstline = ''

    for line in lines
        let pathList = split(line, '\.')

        if len(pathList) > 1
            let newprefix = pathList[0]
            if currentline == line
            else
                :let currentline = line
                if currentline == ''
                else
                    if currentprefix == newprefix
                    else
                        let currentprefix = newprefix
                        if firstline == ''
                            let firstline = line
                        else
                            :execute "normal I\<CR>"
                        endif
                    endif
                    :execute "normal I" . line . "\<CR>"
                endif
            endif
        endif
    endfor
    call setpos('.', pos)
endfunction
command! OrganizeImports :call OrganizeImports()

function! GrabImportBlock()

    :execute "normal gg"
    :let start = search("^import")
    :let end = search("^import", 'b')
    if start == 0
        return []
    endif
    :let lines = sort(getline(start, end))

    :execute "normal " . start . "G"
    if end == start
        :execute 'normal "_dd'
    else
        :execute 'normal "_d' . (end-start) . "j"
    endif
    return lines
endfunction

function! CountOccurances(searchstring)
    let co = []

    :let pos = getpos('.')
    :execute "normal gg"
    while search(a:searchstring, "W") > 0
        :call add(co, 'a')
    endwhile
    call setpos('.', pos)

    return len(co)
endfunction

function! RemoveUnneededImports()

    :let pos = getpos('.')
    let lines = GrabImportBlock()
    if lines == []
        " No imports to organize
        return
    endif

    :let updatedLines = []
    for line in lines
        let trimmedLine = TrimString(line)
        if len(trimmedLine) > 0
            " Also split on spaces for things like
            " import com.MyClass as MyAwesomeClass
            let tempString = substitute(line, '\s', '\.', 'g')
            let classname = substitute(split(tempString, '\.')[-1], ';', '', '')
            " echoerr classname . " " . CountOccurances(classname)
            if classname == "*" || CountOccurances(classname) > 0
                :call add(updatedLines, substitute(line, '^\(\s\*\)','',''))
            endif
        endif
    endfor
    ":execute "normal " . start . "G0"
    for line in updatedLines
        :execute "normal I" . line . "\<CR>"
    endfor
    call setpos('.', pos)
endfunction

command! RemoveUnneededImports :call RemoveUnneededImports()

function! TrimString(str)
    return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

"Loading of imports from a file
function! VimportLoadImports(filetype)
    let importFiles = g:vimport_filetype_import_files[a:filetype]
    for importFile in importFiles
        if filereadable(importFile)
            for line in readfile(importFile)
                if len(line) > 0
                    if line[0] != '"'
                        :call add(s:vimport_import_lists[a:filetype], line)
                    endif
                endif
            endfor
        endif
    endfor
endfunction

command! VimportLoadImports :call VimportLoadImports()

:call VimportLoadImports('java')
:call VimportLoadImports('groovy')
:call VimportLoadImports('kotlin')

"Key mappings
if g:vimport_map_keys
    execute "nnoremap"  g:vimport_insert_shortcut ":call InsertImport()<CR>"
endif


