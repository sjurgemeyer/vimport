"Configuration options
"
let g:vimport_source_dir=expand("<sfile>:h:h")

if !exists('g:vimport_map_keys')
    let g:vimport_map_keys = 1
endif

if !exists('g:vimport_insert_shortcut')
    let g:vimport_insert_shortcut='<leader>i'
endif

if !exists('g:vimport_gradle_reload_shortcut')
    let g:vimport_gradle_reload_shortcut='<leader>r'
endif


if !exists('g:vimport_auto_organize')
    let g:vimport_auto_organize = 1
endif

if !exists('g:vimport_auto_remove')
    let g:vimport_auto_remove = 1
endif

if !exists('g:vimport_import_lists') " filetypes mapped to files to use for class lookup
    :let g:vimport_import_lists = {'java':[], 'groovy':[], 'kotlin':[]}
endif

if !exists('g:vimport_filepath_cache') " cache of local files
    :let g:vimport_filepath_cache = {}
endif
if !exists('g:vimport_file_extensions') " extensions to search when looking for imports via file
    let g:vimport_file_extensions = ['groovy', 'java', 'kt', 'kts']
endif

if !exists('g:vimport_search_path')
    let g:vimport_search_path = '.'
endif

if !exists('g:vimport_filetype_import_files')

    let s:current_file=expand("<sfile>:h:h") . "/data"
    let g:vimport_filetype_import_files = {
        \ 'java': [s:current_file . '/vimports_java.txt'],
        \ 'groovy': [s:current_file . '/vimports_java.txt', s:current_file . '/vimports_groovy.txt', s:current_file . '/vimports_grails.txt'],
        \ 'kotlin': [s:current_file . '/vimports_kotlin.txt']
    \ }
endif

if !exists('g:vimport_lookup_gradle_classpath')
    let g:vimport_lookup_gradle_classpath = 0
endif

if !exists('g:vimport_gradle_cache_file')
    let g:vimport_gradle_cache_file = g:vimport_source_dir . '/cache/gradleClasspath'
endif

function! InsertImport()
    :let original_pos = getpos('.')
    let classToFind = expand("<cword>")

    let filePathList = GetFilePathList(classToFind)

    "Looking up class in text file
    if filePathList == []
        let filePathList = FindFileInList(classToFind, GetVimportFiles())
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

function! FindFileInList(className, list)
    let filePathList = []
    for line in a:list
        let tempClassList = split(line, '\.')
        if len(tempClassList) && tempClassList[-1] == a:className
            :call add(filePathList, line)
        endif
    endfor
    return filePathList
endfunction

function! GetVimportFiles()
    if g:vimport_lookup_gradle_classpath == 1
        let root = VimportFindGradleRoot()
    else
        let root = ''
    endif

    if root != ''
        if !has_key(g:vimport_import_lists, root)
            call VimportLoadImportsFromGradle()
        endif
        if (has_key(g:vimport_import_lists, &filetype))
            return g:vimport_import_lists[root] + g:vimport_import_lists[&filetype]
        else
            return g:vimport_import_lists[root]
        endif
    else
        return g:vimport_import_lists[&filetype]
    endif
endfunction

function! GetFilePathList(classToFind)
    let cwd = getcwd()
    if has_key(g:vimport_filepath_cache, cwd)
    else
        call RefreshFilePathListCache()
    endif
    return FindFileInList(a:classToFind, g:vimport_filepath_cache[cwd])
endfunction

function! GetFilePathListFromFiles(classToFind)
    let filePathList = []
    for extension in g:vimport_file_extensions
        let searchString = '**/' . a:classToFind . '.' . extension
        let paths = globpath(g:vimport_search_path, searchString, 1)
        let multiplePaths = split(paths, '\n')
        for p in multiplePaths
            let package = GetPackageFromFile(p)
            if package == ''
            else
                let fullPath =  package . '.' . a:classToFind
                if (index(filePathList, fullPath) == -1)
                    :call add(filePathList,fullPath)
                endif
            endif
        endfor
    endfor
    return filePathList
endfunction

function! RefreshFilePathListCache()
    let filePathList = []
    for extension in g:vimport_file_extensions
        let searchString = '**/*.' . extension
        let paths = globpath(g:vimport_search_path, searchString, 1)
        let multiplePaths = split(paths, '\n')
        for p in multiplePaths
            let package = GetPackageFromFile(p)
            if package == ''
            else
                let fullPath =  package . '.' . fnamemodify(p, ":t:r")
                :call add(filePathList,fullPath)
            endif
        endfor
    endfor
    let cwd = getcwd()
    let g:vimport_filepath_cache[cwd] = filePathList
    return filePathList
endfunction

function! CreateImports(pathList)
    if a:pathList == []
        echoerr "no file found"
    else
        let chosenPath = a:pathList[0]
        if len(a:pathList) > 1
            call inputsave()
            let originalCmdHeight = &cmdheight
            let &cmdheight = len(a:pathList) + 1
            let index = 0
            let message = ""
            while index < len(a:pathList)
                let message = message . "[" . index . "] " . a:pathList[index] . "\n"
                let index += 1
            endwhile
            let chosenIndex = input(message . 'Which import?: ')
            let chosenPath = a:pathList[chosenIndex]
            let &cmdheight = originalCmdHeight
            call inputrestore()
        endif
        :let pos = getpos('.')
        :call VimportCreateImport(chosenPath)
        :execute "normal " . (pos[1] + 1) . "G"
        if (g:vimport_auto_remove)
            :call RemoveUnneededImports()
        endif
        if (g:vimport_auto_organize)
            :call OrganizeImports()
            :call SpaceAfterPackage()
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

"function! GetCurrentPackageFromPath()
    "return ConvertPathToPackage(expand("%:r"))
"endfunction

function! RemoveFileFromPackage(fullpath)
    return join(split(a:fullpath,'\.')[0:-2],'.')
endfunction

"function! ConvertPathToPackage(filePath)
    "let splitPath = split(a:filePath, '/')

    "let idx = len(splitPath)
    "for sep in g:vimport_seperators
        "let tempIdx = index(splitPath, sep)
        "if tempIdx > 0
            "if tempIdx < idx
                "let idx = tempIdx + 1
            "endif
        "endif
    "endfor
    "let trimmedPath = splitPath[idx :-1]

    "return join(split(join(trimmedPath, '.'),'\.')[0:-2], '.')
"endfunction

function! GetPackageFromFile(filePath)
    let packageDeclaration = GetPackageLine(a:filePath)
    if packageDeclaration == ''
        return ''
    endif
    let package = split(packageDeclaration, '\s')[-1]
    let package = substitute(package, ';', '', '')
    return package

endfunction

function! GetPackageLine(filePath)
    let fileLines = readfile(a:filePath, '', 20) " arbitrary limit on number of lines to read
    let line = match(fileLines, "^package")
    if line == -1
        return ''
    endif
    return fileLines[line]
endfunction

function! GetPackageLineNumber(filePath)
    let fileLines = readfile(a:filePath, '', 20) " arbitrary limit on number of lines to read
    let line = match(fileLines, "^package")
    return line
endfunction


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

function! SpaceAfterPackage()
    :let pos = getpos('.')

    :execute "normal gg"
    :let packageStart = search("^package")
    if packageStart == 0
        return
    endif

    :let importStart = search("^import")
    if importStart == 0
        return
    endif

    :let expectedImportStart = (packageStart + 2)
    if importStart != expectedImportStart
        :execute "normal O"
    endif

    call setpos('.', pos)
endfunction
command! SpaceAfterPackage :call SpaceAfterPackage()

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


function! TrimString(str)
    return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

"Loading of imports from a file
function! VimportLoadImports(filetype)

    "echo "Loading imports for " . a:filetype . "..."
    call VimportCacheGradleClasspath()
    let importFiles = g:vimport_filetype_import_files[a:filetype]
    for importFile in importFiles
        if filereadable(importFile)
            for line in readfile(importFile)
                if len(line) > 0
                    if line[0] != '"'
                        :call add(g:vimport_import_lists[a:filetype], line)
                    endif
                endif
            endfor
        endif
    endfor
endfunction


function! VimportLoadImportsFromGradle()

    echo "Loading classpath from Gradle..."
    call VimportCacheGradleClasspath()
    let root = VimportFindGradleRoot()
    let g:vimport_import_lists[root] = []
    let pythonScript = g:vimport_source_dir . "/data/createClassList.py"
    for line in readfile(g:vimport_gradle_cache_file)
        if strpart(line, strlen(line)-4) == '.jar'
            execute 'pyfile ' . pythonScript
        endif
    endfor
endfunction

function! VimportCacheGradleClasspath()
    let root = VimportFindGradleRoot()
    execute 'cd ' . fnameescape(root)
    let initScript = g:vimport_source_dir . "/data/initgradle.gradle"
    let output = system('gradle -I ' . initScript . ' -PvimportExportFile=' . g:vimport_gradle_cache_file . ' echoClasspath')
endfunction

function! VimportFindGradleRoot()
    let root = expand('%:p')
    let previous = ""
    while root !=# previous
        if filereadable(root . '/build.gradle')
            return root
        endif
        let previous = root
        let root = fnamemodify(root, ':h')
    endwhile
    return ''
endfunction

command! VimportReloadImportCache :call VimportLoadImports(&filetype) "Cache imports from import files
command! VimportReloadGradleCache :call VimportLoadImportsFromGradle() "Reload the cache from the gradle build
command! RemoveUnneededImports :call RemoveUnneededImports() "Remove imports that aren't referenced in the file
command! InsertImport :call InsertImport() "Insert the import under the word
command! OrganizeImports :call OrganizeImports() "Sort the imports and put spaces between packages with different spaces
command! SpaceAfterPackage :call SpaceAfterPackage() " Add a space after the package

:call VimportLoadImports('java')
:call VimportLoadImports('groovy')
:call VimportLoadImports('kotlin')

"Key mappings
if g:vimport_map_keys
    execute "nnoremap"  g:vimport_insert_shortcut ":call InsertImport()<CR>"
    execute "nnoremap"  g:vimport_gradle_reload_shortcut ":call VimportLoadImportsFromGradle()<CR>"
endif


