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
if !exists('g:vimport_ignore_classnames')
    let g:vimport_ignore_classnames={'System':'', 'Groovy':''}
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

if !exists('g:vimport_import_groups')
    :let g:vimport_import_groups = []
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

    let result = InsertImportForClassName(classToFind)

    if !result
        echoerr "no file found"
    else
        call VimportCleanup()
    endif

    call setpos('.', original_pos)
endfunction

function VimportCleanup()
    if (g:vimport_auto_remove)
        :call RemoveUnneededImports()
    endif
    if (g:vimport_auto_organize)
        :call OrganizeImports()
        :call SpaceAfterPackage()
    endif
endfunction

function! InsertImportForClassName(classToFind)

    let localFilePaths = GetFilePathList(a:classToFind)
    let otherFilePaths = FindFileInList(a:classToFind, GetVimportFiles())
    let filePathList = localFilePaths + otherFilePaths

    let pathList = []
    for f in filePathList
        let shouldCreateImport = ShouldCreateImport(f)
        if (shouldCreateImport)
            :call add(pathList, f)
        else
            return
        endif
    endfor

    if pathList ==# []
        return 0
    else
        call CreateImports(pathList)
        return 1
    endif

endfunction

function! FindFileInList(className, list)
    let filePathList = []
    for line in a:list
        let tempClassList = split(line, '\.')
        if len(tempClassList) && tempClassList[-1] ==# a:className
            :call add(filePathList, line)
        endif
    endfor
    return filePathList
endfunction

function! GetVimportFiles()
    if g:vimport_lookup_gradle_classpath ==# 1
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
    echo "Searching CWD for matching files..."
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
            if package ==# ''
            else
                let fullPath =  package . '.' . a:classToFind
                if (index(filePathList, fullPath) ==# -1)
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
            if package ==# ''
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
    let chosenPath = a:pathList[0]
    if len(a:pathList) > 1
        call inputsave()
        let originalCmdHeight = &cmdheight
        let &cmdheight = len(a:pathList) + 1
        let index = 0
        let message = ""
        while index < len(a:pathList)
            let message = message . "[" . (index + 1) . "] " . a:pathList[index] . "\n"
            let index += 1
        endwhile
        let chosenIndex = input(message . 'Which import?: ')
        echom chosenIndex
        if chosenIndex ==# ''
            return
        endif
        let chosenPath = a:pathList[chosenIndex-1]
        let &cmdheight = originalCmdHeight
        redraw! "Prevent messages from stacking and causing a 'Press Enter..' message
        call inputrestore()
    endif
    :call VimportCreateImport(chosenPath)
endfunction

function! VimportCreateImport(path)
    let import = 'import ' . a:path
    let extension = expand("%:e")
    if (extension ==# 'java')
        let formattedImport = import . ';'
    else
        let formattedImport = import
    endif

    let packageLine = GetPackageLineNumber(expand("%:p"))
    if packageLine > -1
        :execute "normal " . (packageLine + 1) . "Go"
    else
        :execute "normal ggo"
    endif
    :execute "normal I" . formattedImport . "\<Esc>"
endfunction

function! ShouldCreateImport(path)
    let currentpackage = GetCurrentPackage()
    let importPackage = RemoveFileFromPackage(a:path)
    if importPackage != ''
        if importPackage != currentpackage
            :let starredImport = search(importPackage . "\\.\\*", 'nwc')
            if starredImport > 0
                return 0
            else
                :let existingImport = search(a:path . '\s*$', 'nwc')
                if existingImport > 0
                    return 0
                else
                endif
            endif
        else
            return 0
        endif
    endif
    return 1
endfunction

function! GetCurrentPackage()
    return GetPackageFromFile(expand("%:p"))
endfunction

function! RemoveFileFromPackage(fullpath)
    return join(split(a:fullpath,'\.')[0:-2],'.')
endfunction

function! GetPackageFromFile(filePath)
    let packageDeclaration = GetPackageLine(a:filePath)
    if packageDeclaration ==# ''
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
    let lines = SortImports(lines)

    :let currentprefix = ''
    :let currentline = ''
    :let firstline = ''

    for line in lines
        let pathList = split(line, '\.')

        if len(pathList) > 1
            let newprefix = pathList[0]
            if currentline ==# line
            else
                :let currentline = line
                if currentline ==# ''
                else
                    if currentprefix ==# newprefix
                    else
                        let currentprefix = newprefix
                        if firstline ==# ''
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

    :execute "normal gg^"
    :let packageStart = search("^package", 'c')
    if packageStart == 0
        return
    endif

    :let importStart = search("^import", 'c')
    if importStart == 0
        return
    endif

    :let expectedImportStart = (packageStart + 2)
    if importStart != expectedImportStart
        :execute "normal O"
    endif

    call setpos('.', pos)
endfunction

function! GrabImportBlock()

    :execute "normal gg^"
    :let start = search("^import", 'c')
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
    :execute "normal gg^"
    while search(a:searchstring, "W") > 0
        :call add(co, 'a')
    endwhile
    call setpos('.', pos)

    return len(co)
endfunction

function! SortImports(lines)
    let lines = sort(a:lines)
    let importGroups = {}
    let defaultGroup = []
    for importGroup in g:vimport_import_groups
        let importGroups[importGroup.name] = []
    endfor

    for line in lines
        let pathList = split(line, '\.')
        if len(pathList) > 0
            let importGroupName = ''
            for importGroup in g:vimport_import_groups
                if pathList[0] =~ importGroup.matcher
                    let importGroupName = importGroup.name
                    break
                endif
            endfor
            if importGroupName ==# ''
                :call add(defaultGroup, line)
            else
                :call add(importGroups[importGroupName], line)
            endif
        endif
    endfor

    for importGroup in g:vimport_import_groups
        let defaultGroup = defaultGroup + importGroups[importGroup.name]
    endfor
    return defaultGroup

endfunction

function! RemoveUnneededImports()

    :let pos = getpos('.')
    let lines = GrabImportBlock()
    if lines == []
        " No imports to organize
        return
    endif

    let lines = SortImports(lines)
    :let updatedLines = []
    for line in lines
        let trimmedLine = TrimString(line)
        if len(trimmedLine) > 0
            " Also split on spaces for things like
            " import com.MyClass as MyAwesomeClass
            let tempString = substitute(line, '\s', '\.', 'g')
            let classname = substitute(split(tempString, '\.')[-1], ';', '', '')
            " echoerr classname . " " . CountOccurances(classname)
            if classname ==# "*" || CountOccurances(classname) > 0
                :call add(updatedLines, substitute(line, '^\(\s\*\)','',''))
            endif
        endif
    endfor
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

    redraw! "Prevent messages from stacking and causing a 'Press Enter..' message
    echo "Loading classpath from Gradle..."
    call VimportCacheGradleClasspath()
    let root = VimportFindGradleRoot()
    let g:vimport_import_lists[root] = []
    let pythonScript = g:vimport_source_dir . "/data/createClassList.py"
    for line in readfile(g:vimport_gradle_cache_file)
        if strpart(line, strlen(line)-4) ==# '.jar'
            execute 'pyfile ' . pythonScript
        endif
    endfor
    redraw! "Prevent messages from stacking and causing a 'Press Enter..' message
    echo "Finished loading classpath from Gradle."
endfunction

function! VimportCacheGradleClasspath()

    let root = VimportFindGradleRoot()
    if empty(root)
    else
        let cwd = getcwd()
        execute 'cd ' . fnameescape(root)
        let initScript = g:vimport_source_dir . "/data/initgradle.gradle"
        let output = system('gradle -I ' . initScript . ' -PvimportExportFile=' . g:vimport_gradle_cache_file . ' echoClasspath')
        execute 'cd ' . cwd
    endif
endfunction

function! VimportFindGradleRoot()
    let root = expand('%:p')
    let previous = ""

    while root !=# previous

        let path = globpath(root, '*.gradle', 1)
        if path ==# ''
        else
            return fnamemodify(path, ':h')
        endif
        let previous = root
        let root = fnamemodify(root, ':h')
    endwhile
    return ''
endfunction

let s:classNames = []
function! AddToMatches(str)
    call add(s:classNames, a:str)
endfunction

function! VimportImportAll()

    :let start = search("^import", 'b') + 1 "Don't search the imports for class names

    :execute ":keeppatterns " . start . ",$s/\\v[^a-z](([A-Z]+[a-z0-9]+)+)/\\=AddToMatches(submatch(1))/gn"

    let list = s:classNames
    let list=filter(copy(list), 'index(list, v:val, v:key+1)==-1')

    for item in list
        call InsertImportForClassName(item)
    endfor

    call VimportCleanup()
    echo "Done with import all"

endfunction

command! VimportReloadImportCache :call VimportLoadImports(&filetype) "Cache imports from import files
command! VimportReloadGradleCache :call VimportLoadImportsFromGradle() "Reload the cache from the gradle build
command! VimportReloadFilepathCache :call RefreshFilePathListCache() "Reload the cache from local file system
command! VimportImportAll :call VimportImportAll() "Search the file for class names and run InsertImport on each one

command! RemoveUnneededImports :call RemoveUnneededImports() "Remove imports that aren't referenced in the file
command! InsertImport :call InsertImport() "Insert the import under the word
command! OrganizeImports :call OrganizeImports() "Sort the imports and put spaces between packages with different spaces
command! SpaceAfterPackage :call SpaceAfterPackage() " Add a space after the package

:call VimportLoadImports('java')
:call VimportLoadImports('groovy')
:call VimportLoadImports('kotlin')

"Key mappings
if g:vimport_map_keys
    execute "nnoremap" g:vimport_insert_shortcut ":call InsertImport()<CR>"
    execute "nnoremap" g:vimport_gradle_reload_shortcut ":call VimportLoadImportsFromGradle()<CR>"
endif
