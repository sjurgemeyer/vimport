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
    let g:vimport_ignore_classnames={ 'java' : {}, 'groovy' : {}, 'kotlin' : {}, 'scala' : {}}
endif

if !exists('g:vimport_auto_organize')
    let g:vimport_auto_organize = 1
endif

if !exists('g:vimport_auto_remove')
    let g:vimport_auto_remove = 1
endif

if !exists('g:vimport_add_package_spaces')
    let g:vimport_add_package_spaces= 1
endif

if !exists('g:vimport_filetype_caches') " filetypes mapped to files to use for class lookup
    let g:vimport_filetype_caches = {
        \'java':{'imports': [] , 'ignores': {}},
        \ 'groovy':{'imports': [] , 'ignores': {}},
        \ 'kotlin': {'imports': [] , 'ignores': {}},
        \ 'scala': {'imports': [] , 'ignores': {}}
    \ }
endif

if !exists('g:vimport_import_groups')
    let g:vimport_import_groups = []
endif

if !exists('g:vimport_filepath_cache') " cache of local files
    let g:vimport_filepath_cache = {}
endif
if !exists('g:vimport_file_extensions') " extensions to search when looking for imports via file
    let g:vimport_file_extensions = ['groovy', 'java', 'kt', 'kts', 'scala']
endif

if !exists('g:vimport_search_path')
    let g:vimport_search_path = '.'
endif

if !exists('g:vimport_filetype_import_files')

    let s:current_file=expand("<sfile>:h:h") . "/data"
    let g:vimport_filetype_import_files = {
        \ 'java': [s:current_file . '/vimports_java.txt'],
        \ 'groovy': [s:current_file . '/vimports_java.txt', s:current_file . '/vimports_groovy.txt', s:current_file . '/vimports_grails.txt'],
        \ 'kotlin': [s:current_file . '/vimports_kotlin.txt'],
        \ 'scala': []
    \ }
endif

if !exists('g:vimport_filetype_ignore_files')
    let s:current_file=expand("<sfile>:h:h") . "/data"
    let g:vimport_filetype_ignore_files= {
        \ 'java': [s:current_file . '/vimport_ignore_java.txt'],
        \ 'groovy': [s:current_file . '/vimport_ignore_groovy.txt', s:current_file . '/vimport_ignore_java.txt'],
        \ 'kotlin': [],
        \ 'scala': []
    \ }
endif

if !exists('g:vimport_lookup_gradle_classpath')
    let g:vimport_lookup_gradle_classpath = 0
endif

if !exists('g:vimport_gradle_cache_file')
    let g:vimport_gradle_cache_file = g:vimport_source_dir . '/cache/gradleClasspath'
endif

function! InsertImport()
    let classToFind = expand("<cword>")

    let result = s:DetermineImportForClassName(classToFind)

    if result == ''
        redraw! "Prevent messages from stacking and causing a 'Press Enter..' message
        echoerr "no import was found"
    else
	call s:WriteImportBlock([result])
        call OrganizeImports(g:vimport_auto_remove, g:vimport_auto_organize)
    endif
endfunction


function! s:DetermineImportForClassName(classToFind)

    let localFilePaths = s:GetFilePathList(a:classToFind)
    let otherFilePaths = s:FindFileInList(a:classToFind, s:GetAvailableImports())
    let filePathList = localFilePaths + otherFilePaths

    let pathList = []
    for f in filePathList
        let shouldCreateImport = ShouldCreateImport(f)
        if (shouldCreateImport)
            call add(pathList, f)
        else
            return 1
        endif
    endfor

    if pathList ==# []
        return ''
    else
        let import = s:DetermineImport(pathList)
	if import != ''
	    return s:FormatImport(import)
	endif
    endif

endfunction

function! s:FindFileInList(className, list)
    let filePathList = []
    for line in a:list
        let tempClassList = split(line, '\.')
        if len(tempClassList) && tempClassList[-1] ==# a:className
            call add(filePathList, line)
        endif
    endfor
    return filePathList
endfunction

function! s:GetAvailableImports()
    if g:vimport_lookup_gradle_classpath ==# 1
        let root = s:VimportFindGradleRoot()
    else
        let root = ''
    endif

    if root != ''
        if !s:HasImportKey(root)
            call VimportLoadImportsFromGradle()
        endif
        if s:HasImportKey(&filetype)
            let dirList = s:GetImportList(root)
            let typeList = s:GetImportList(&filetype)
            return dirList + typeList
        else
            return s:GetImportList(root)
        endif
    else
        return s:GetImportList(&filetype)
    endif
endfunction

function! s:HasImportKey(name)
    return has_key(g:vimport_filetype_caches, a:name)
endfunction

function! s:GetImportList(name)
    return g:vimport_filetype_caches[a:name]['imports']
endfunction

function! s:SetImportList(name, value)
    if (!has_key(g:vimport_filetype_caches, a:name))
        let g:vimport_filetype_caches[a:name] = { 'imports':[], 'ignores':{} }
    endif
    let g:vimport_filetype_caches[a:name]['imports'] = a:value
endfunction

function! s:ShouldIgnoreClass(class)
    let ignores = g:vimport_filetype_caches[&filetype]['ignores']
    return has_key(ignores, a:class)
endfunction

function! s:SetIgnoreList(name, value)
    if (!has_key(g:vimport_filetype_caches, a:name))
        let g:vimport_filetype_caches[a:name] = { 'imports':[], 'ignores':{} }
    endif
    let g:vimport_filetype_caches[a:name]['ignores'] = a:value
endfunction

function! s:GetFilePathList(classToFind)
    let cwd = getcwd()
    if !has_key(g:vimport_filepath_cache, cwd)
        call RefreshFilePathListCache()
    endif
    return s:FindFileInList(a:classToFind, g:vimport_filepath_cache[cwd])
endfunction

function! RefreshFilePathListCache()
    let filePathList = []
    for extension in g:vimport_file_extensions
        let searchString = '**/*.' . extension
        let paths = globpath(g:vimport_search_path, searchString, 1)
        let multiplePaths = split(paths, '\n')
        for p in multiplePaths
            let package = GetPackageFromFile(p)
            if package !=# ''
                let fullPath =  package . '.' . fnamemodify(p, ":t:r")
                call add(filePathList,fullPath)
            endif
        endfor
    endfor
    let cwd = getcwd()
    let g:vimport_filepath_cache[cwd] = filePathList
    return filePathList

endfunction

function! s:DetermineImport(pathList)
    let chosenPath = a:pathList[0]
    if len(a:pathList) > 1
        let index = 0
        let l:msg = ""
        while index < len(a:pathList)
            let l:msg = l:msg . "[" . (index + 1) . "] " . a:pathList[index] . "\n"
            let index += 1
        endwhile

        redraw! "Prevent messages from stacking and causing a 'Press Enter..' message
        let originalCmdHeight = &cmdheight
        call inputsave()
        let &cmdheight = len(a:pathList) + 1
        let chosenIndex = input(l:msg . 'Which import?: ')
        let &cmdheight = originalCmdHeight
        call inputrestore()
        redraw! "Prevent messages from stacking and causing a 'Press Enter..' message

        if chosenIndex !=# ''
            let chosenPath = a:pathList[chosenIndex-1]
        else
            return ''
        endif
    endif
    return chosenPath
endfunction

function! s:FormatImport(path)
    let import = 'import ' . a:path
    let extension = expand("%:e")
    if (extension ==# 'java')
        let formattedImport = import . ';'
    else
        let formattedImport = import
    endif
    return formattedImport
endfunction

function! ShouldCreateImport(path)
    let currentpackage = GetCurrentPackage()
    let importPackage = s:RemoveFileFromPackage(a:path)
    if importPackage != ''
        if importPackage != currentpackage
            " Stared imports include scala style _ imports
            let starredImport = search(importPackage . "\\.[\\*_]", 'nwc')
            if starredImport > 0
                return 0
            else
                let existingImport = search(a:path . '\s*$', 'nwc')
                if existingImport > 0
                    return 0
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

function! s:RemoveFileFromPackage(fullpath)
    return join(split(a:fullpath,'\.')[0:-2],'.')
endfunction

function! GetPackageFromFile(filePath)
    let packageDeclaration = s:GetPackageLine(a:filePath)
    if packageDeclaration ==# ''
        return ''
    endif
    let package = split(packageDeclaration, '\s')[-1]
    let package = substitute(package, ';', '', '')
    return package

endfunction

function! s:GetPackageLine(filePath)
    let fileLines = readfile(a:filePath, '', 20) " arbitrary limit on number of lines to read
    let line = match(fileLines, "^package")
    if line == -1
        return ''
    endif
    return fileLines[line]
endfunction

function! s:GetPackageLineNumberForCurrentFile()
    return s:GetPackageLineNumber(expand("%:p"))
endfunction

function! s:GetPackageLineNumber(filePath)
    let fileLines = readfile(a:filePath, '', 20) " arbitrary limit on number of lines to read
    let line = match(fileLines, "^package")
    return line
endfunction


function! OrganizeImports(remove, sort)
    let pos = getpos('.')

    let lines = GrabImportBlock()
    if lines == []
        " No imports to organize
        return
    endif

    let lines = s:RemoveDuplicates(lines)
    if (a:remove)
        let lines = s:RemoveUnneededImportsFromList(lines)
    endif
    if (a:sort)
        let lines = s:SortImports(lines)
    endif

    let result = s:WriteImportBlock([''] + lines  + [''])

    call setpos('.', pos)
endfunction

function! s:RemoveDuplicates(list)
    return filter(copy(a:list), 'index(a:list, v:val, v:key+1)==-1')
endfunction

function! s:VimportAddBlankLines(lines)
    let currentprefix = ''
    let currentline = ''
    let firstline = ''

    let lines = []
    for line in a:lines
        let pathList = split(line, '\.')
        if len(pathList) > 1
            let newprefix = pathList[0]
            if currentline !=# line
                let currentline = line
                if currentline !=# ''
                    if currentprefix !=# newprefix
                        let currentprefix = newprefix
                        if firstline ==# ''
                            let firstline = line
                        else
                            call add(lines, '')
                        endif
                    endif
                endif
            endif
            call add(lines, line)
        endif
    endfor
    return lines
endfunction

function! s:WriteImportBlock(lines)
    let packageLine = s:GetPackageLineNumberForCurrentFile()
    let failed = append(packageLine+1, a:lines)
endfunction

function! GrabImportBlock()

    let pos = getpos('.')
    execute "normal gg^"
    let start = search("^import", 'c')
    let end = search("^import", 'b')
    if start == 0
        return []
    endif
    let lines = getline(start, end)

    let newEnd = end+1
    while (s:TrimString(getline(newEnd)) == '' && newEnd <= line('$'))
    let end = newEnd
    let newEnd = newEnd + 1
    endwhile

    execute "normal " . (start-1) . "G"
    execute start . ',' . end . 'd_'
    call setpos('.', pos)
    return lines
endfunction

function! s:CountOccurances(searchstring)
    let co = []

    let pos = getpos('.')
    execute "normal gg^"
    while search(a:searchstring, "W") > 0
        call add(co, 'a')
    endwhile
    call setpos('.', pos)

    return len(co)
endfunction

function! s:SortImports(lines)
    let lines = sort(a:lines)
    let importGroups = {}
    let defaultGroup = []
    for importGroup in g:vimport_import_groups
        let importGroups[importGroup.name] = []
    endfor

    for line in lines
        let trimmedLine = s:TrimString(line)
        if len(trimmedLine) > 0
            let importGroupName = ''
            for importGroup in g:vimport_import_groups
                if trimmedLine =~ importGroup.matcher
                    let importGroupName = importGroup.name
                    break
                endif
            endfor
            if importGroupName ==# ''
                call add(defaultGroup, trimmedLine)
            else
                call add(importGroups[importGroupName], trimmedLine)
            endif
        endif
    endfor

    for importGroup in g:vimport_import_groups
        let defaultGroup = defaultGroup + importGroups[importGroup.name]
    endfor
    if g:vimport_add_package_spaces
        let defaultGroup = s:VimportAddBlankLines(defaultGroup)
    endif
    return defaultGroup

endfunction

function! RemoveUnneededImports()

    let pos = getpos('.')
    let lines = GrabImportBlock()
    if lines == []
        " No imports to organize
        return
    endif

    let updatedLines = s:RemoveUnneededImportsFromList(lines)

    let result = s:WriteImportBlock(updatedLines)



    call setpos('.', pos)
endfunction

function! s:RemoveUnneededImportsFromList(lines)
    let updatedLines = []
    for line in a:lines
        let trimmedLine = s:TrimString(line)
        if len(trimmedLine) > 0
            " Also split on spaces for things like
            " import com.MyClass as MyAwesomeClass
            let tempString = substitute(line, '\s', '\.', 'g')
            let classname = substitute(split(tempString, '\.')[-1], ';', '', '')
            " Always keep * and _ imports.  Also Scala's bracketed imports
            " until I create a better way to verify those
            if classname ==# "*" || classname ==# "_" || classname =~ "^\{" || s:CountOccurances(classname) > 0
                call add(updatedLines, substitute(line, '^\(\s\*\)','',''))
            endif
        else
            " Don't remove spaces
            call add(updatedLines, '')
        endif
    endfor
    return updatedLines
endfunction


function! s:TrimString(str)
    return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

"Loading of imports from a file
function! VimportLoadImports(filetype)
    let importFiles = g:vimport_filetype_import_files[a:filetype]
    let list = s:LoadListFromFileList(importFiles)
    call s:SetImportList(a:filetype, list)
endfunction

"Loading ignored classes from file
function! VimportLoadIgnores(filetype)
    let ignoreFiles = g:vimport_filetype_ignore_files[a:filetype]
    let list = s:LoadListFromFileList(ignoreFiles)

    let map = {}
    for l in list
        let map[l] = ''
    endfor
    call s:SetIgnoreList(a:filetype, map)
endfunction

function! s:LoadListFromFileList(fileList)
    let list = []
    for f in a:fileList
        if filereadable(f)
            for line in readfile(f)
                if len(line) > 0
                    if line[0] != '"'
                        call add(list, line)
                    endif
                endif
            endfor
        endif
    endfor
    return list
endfunction

function! VimportLoadImportsFromGradle()

    redraw! "Prevent messages from stacking and causing a 'Press Enter..' message
    echo "Loading classpath from Gradle..."
    call s:VimportCacheGradleClasspath()
    let root = s:VimportFindGradleRoot()
    let list = []
    let pythonScript = g:vimport_source_dir . "/data/createClassList"
    for line in readfile(g:vimport_gradle_cache_file)
        if strpart(line, strlen(line)-4) ==# '.jar'
            if has("python")
                execute 'pyfile ' . pythonScript . '.py'
            elseif has("python3")
                execute 'py3file ' . pythonScript . '.py3'
            endif
        endif
    endfor
    call s:SetImportList(root, list)
    redraw! "Prevent messages from stacking and causing a 'Press Enter..' message
    echo "Finished loading classpath from Gradle."
endfunction

function! s:VimportCacheGradleClasspath()

    let root = s:VimportFindGradleRoot()
    if !empty(root)
        let cwd = getcwd()
        execute 'cd ' . fnameescape(root)
        let initScript = g:vimport_source_dir . "/data/initgradle.gradle"
        let output = system('gradle -I ' . initScript . ' -PvimportExportFile=' . g:vimport_gradle_cache_file . ' echoClasspath')
        execute 'cd ' . cwd
    endif
endfunction

function! s:VimportFindGradleRoot()
    let root = expand('%:p')
    let previous = ""

    while root !=# previous

        let path = globpath(root, '*.gradle', 1)
        let multiplePaths = split(path, '\n')
        for p in multiplePaths
            let filename = fnamemodify(path, ':t')
            if (filename != 'settings')
                let path = p
                break
            endif
        endfor
        if path !=# ''
            return fnamemodify(path, ':h')
        endif
        let previous = root
        let root = fnamemodify(root, ':h')
    endwhile
    return ''
endfunction

let s:classNames = []
function! s:AddToMatches(str)
    call add(s:classNames, a:str)
endfunction

function! VimportImportAll()

    let start = search("^import", 'b') + 1 "Don't search the imports for class names

    " search for the pattern and call AddToMatches for each match.  /n
    " prevents it from actually doing a replace
    " AddToMatches just populates s:classNames
    let s:classNames = []
    execute ":keeppatterns " . start . ",$s/\\v[^a-z](([A-Z]+[a-z0-9]+)+)/\\=s:AddToMatches(submatch(1))/gn"

    let classNameList = s:classNames
    " Filter duplicates
    let classNameList=filter(copy(classNameList), 'index(classNameList, v:val, v:key+1)==-1')

    let importList = []
    for item in classNameList
        if !s:ShouldIgnoreClass(item)
            call add(importList, s:DetermineImportForClassName(item))
        endif
    endfor

    call s:WriteImportBlock(importList)
    call OrganizeImports(g:vimport_auto_remove, g:vimport_auto_organize)
    echo "Done with import all"

endfunction

function VimportReloadAllCaches()
    :call VimportLoadImports(&filetype)
    :call VimportLoadImportsFromGradle()
    :call RefreshFilePathListCache()
endfunction

command! VimportReloadCaches : call VimportReloadAllCaches()
command! VimportReloadImportCache :call VimportLoadImports(&filetype) "Cache imports from import files
command! VimportReloadGradleCache :call VimportLoadImportsFromGradle() "Reload the cache from the gradle build
command! VimportReloadFilepathCache :call RefreshFilePathListCache() "Reload the cache from local file system
command! VimportImportAll :call VimportImportAll() "Search the file for class names and run InsertImport on each one

command! RemoveUnneededImports :call RemoveUnneededImports() "Remove imports that aren't referenced in the file
command! InsertImport :call InsertImport() "Insert the import under the word
command! OrganizeImports :call OrganizeImports(g:vimport_auto_remove, 1) "Sort the imports and put spaces between packages with different spaces

let s:defaultFileTypes = ['java', 'groovy', 'kotlin', 'scala']

for f in s:defaultFileTypes
    call VimportLoadImports(f)
    call VimportLoadIgnores(f)
endfor

"Key mappings
if g:vimport_map_keys
    execute "nnoremap" g:vimport_insert_shortcut ":call InsertImport()<CR>"
    execute "nnoremap" g:vimport_gradle_reload_shortcut ":call VimportLoadImportsFromGradle()<CR>"
endif
