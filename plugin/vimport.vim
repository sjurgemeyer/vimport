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
    let g:vimport_ignore_classnames={
        \ 'java' : { 'AbstractMethodError':'', 'AbstractStringBuilder':'', 'Appendable':'', 'ApplicationShutdownHooks':'', 'ArithmeticException':'', 'ArrayIndexOutOfBoundsException':'', 'ArrayStoreException':'', 'AssertionError':'', 'AssertionStatusDirectives':'', 'AutoCloseable':'', 'Boolean':'', 'BootstrapMethodError':'', 'Byte':'', 'CharSequence':'', 'Character':'', 'CharacterData':'', 'CharacterData00':'', 'CharacterData01':'', 'CharacterData02':'', 'CharacterData0E':'', 'CharacterDataLatin1':'', 'CharacterDataPrivateUse':'', 'CharacterDataUndefined':'', 'CharacterName':'', 'Class':'', 'ClassCastException':'', 'ClassCircularityError':'', 'ClassFormatError':'', 'ClassLoader':'', 'ClassLoaderHelper':'', 'ClassNotFoundException':'', 'ClassValue':'', 'CloneNotSupportedException':'', 'Cloneable':'', 'Comparable':'', 'Compiler':'', 'ConditionalSpecialCasing':'', 'Deprecated':'', 'Double':'', 'Enum':'', 'EnumConstantNotPresentException':'', 'Error':'', 'Exception':'', 'ExceptionInInitializerError':'', 'Float':'', 'FunctionalInterface':'', 'IllegalAccessError':'', 'IllegalAccessException':'', 'IllegalArgumentException':'', 'IllegalMonitorStateException':'', 'IllegalStateException':'', 'IllegalThreadStateException':'', 'IncompatibleClassChangeError':'', 'IndexOutOfBoundsException':'', 'InheritableThreadLocal':'', 'InstantiationError':'', 'InstantiationException':'', 'Integer':'', 'InternalError':'', 'InterruptedException':'', 'Iterable':'', 'LinkageError':'', 'Long':'', 'Math':'', 'NegativeArraySizeException':'', 'NoClassDefFoundError':'', 'NoSuchFieldError':'', 'NoSuchFieldException':'', 'NoSuchMethodError':'', 'NoSuchMethodException':'', 'NullPointerException':'', 'Number':'', 'NumberFormatException':'', 'Object':'', 'OutOfMemoryError':'', 'Override':'', 'Package':'', 'Process':'', 'ProcessBuilder':'', 'ProcessEnvironment':'', 'ProcessImpl':'', 'Readable':'', 'ReflectiveOperationException':'', 'Runnable':'', 'Runtime':'', 'RuntimeException':'', 'RuntimePermission':'', 'SafeVarargs':'', 'SecurityException':'', 'SecurityManager':'', 'Short':'', 'Shutdown':'', 'StackOverflowError':'', 'StackTraceElement':'', 'StrictMath':'', 'String':'', 'StringBuffer':'', 'StringBuilder':'', 'StringCoding':'', 'StringIndexOutOfBoundsException':'', 'SuppressWarnings':'', 'System':'', 'SystemClassLoaderAction':'', 'Terminator':'', 'Thread':'', 'ThreadDeath':'', 'ThreadGroup':'', 'ThreadLocal':'', 'Throwable':'', 'TypeNotPresentException':'', 'UNIXProcess':'', 'UnknownError':'', 'UnsatisfiedLinkError':'', 'UnsupportedClassVersionError':'', 'UnsupportedOperationException':'', 'VerifyError':'', 'VirtualMachineError':'', 'Void':'' },
        \ 'groovy' : { 'AbstractMethodError':'', 'AbstractStringBuilder':'', 'Appendable':'', 'ApplicationShutdownHooks':'', 'ArithmeticException':'', 'ArrayIndexOutOfBoundsException':'', 'ArrayStoreException':'', 'AssertionError':'', 'AssertionStatusDirectives':'', 'AutoCloseable':'', 'Boolean':'', 'BootstrapMethodError':'', 'Byte':'', 'CharSequence':'', 'Character':'', 'CharacterData':'', 'CharacterData00':'', 'CharacterData01':'', 'CharacterData02':'', 'CharacterData0E':'', 'CharacterDataLatin1':'', 'CharacterDataPrivateUse':'', 'CharacterDataUndefined':'', 'CharacterName':'', 'Class':'', 'ClassCastException':'', 'ClassCircularityError':'', 'ClassFormatError':'', 'ClassLoader':'', 'ClassLoaderHelper':'', 'ClassNotFoundException':'', 'ClassValue':'', 'CloneNotSupportedException':'', 'Cloneable':'', 'Comparable':'', 'Compiler':'', 'ConditionalSpecialCasing':'', 'Deprecated':'', 'Double':'', 'Enum':'', 'EnumConstantNotPresentException':'', 'Error':'', 'Exception':'', 'ExceptionInInitializerError':'', 'Float':'', 'FunctionalInterface':'', 'IllegalAccessError':'', 'IllegalAccessException':'', 'IllegalArgumentException':'', 'IllegalMonitorStateException':'', 'IllegalStateException':'', 'IllegalThreadStateException':'', 'IncompatibleClassChangeError':'', 'IndexOutOfBoundsException':'', 'InheritableThreadLocal':'', 'InstantiationError':'', 'InstantiationException':'', 'Integer':'', 'InternalError':'', 'InterruptedException':'', 'Iterable':'', 'LinkageError':'', 'Long':'', 'Math':'', 'NegativeArraySizeException':'', 'NoClassDefFoundError':'', 'NoSuchFieldError':'', 'NoSuchFieldException':'', 'NoSuchMethodError':'', 'NoSuchMethodException':'', 'NullPointerException':'', 'Number':'', 'NumberFormatException':'', 'Object':'', 'OutOfMemoryError':'', 'Override':'', 'Package':'', 'Process':'', 'ProcessBuilder':'', 'ProcessEnvironment':'', 'ProcessImpl':'', 'Readable':'', 'ReflectiveOperationException':'', 'Runnable':'', 'Runtime':'', 'RuntimeException':'', 'RuntimePermission':'', 'SafeVarargs':'', 'SecurityException':'', 'SecurityManager':'', 'Short':'', 'Shutdown':'', 'StackOverflowError':'', 'StackTraceElement':'', 'StrictMath':'', 'String':'', 'StringBuffer':'', 'StringBuilder':'', 'StringCoding':'', 'StringIndexOutOfBoundsException':'', 'SuppressWarnings':'', 'System':'', 'SystemClassLoaderAction':'', 'Terminator':'', 'Thread':'', 'ThreadDeath':'', 'ThreadGroup':'', 'ThreadLocal':'', 'Throwable':'', 'TypeNotPresentException':'', 'UNIXProcess':'', 'UnknownError':'', 'UnsatisfiedLinkError':'', 'UnsupportedClassVersionError':'', 'UnsupportedOperationException':'', 'VerifyError':'', 'VirtualMachineError':'', 'Void' :'', 'BigDecimal':'', 'BigInteger':'', 'Bits':'', 'BufferedInputStream':'', 'BufferedOutputStream':'', 'BufferedReader':'', 'BufferedWriter':'', 'ByteArrayInputStream':'', 'ByteArrayOutputStream':'', 'CharArrayReader':'', 'CharArrayWriter':'', 'CharConversionException':'', 'Closeable':'', 'Console':'', 'DataInput':'', 'DataInputStream':'', 'DataOutput':'', 'DataOutputStream':'', 'DefaultFileSystem':'', 'DeleteOnExitHook':'', 'EOFException':'', 'ExpiringCache':'', 'Externalizable':'', 'File':'', 'FileDescriptor':'', 'FileFilter':'', 'FileInputStream':'', 'FileNotFoundException':'', 'FileOutputStream':'', 'FilePermission':'', 'FilePermissionCollection':'', 'FileReader':'', 'FileSystem':'', 'FileWriter':'', 'FilenameFilter':'', 'FilterInputStream':'', 'FilterOutputStream':'', 'FilterReader':'', 'FilterWriter':'', 'Flushable':'', 'IOError':'', 'IOException':'', 'InputStream':'', 'InputStreamReader':'', 'InterruptedIOException':'', 'InvalidClassException':'', 'InvalidObjectException':'', 'LineNumberInputStream':'', 'LineNumberReader':'', 'NotActiveException':'', 'NotSerializableException':'', 'ObjectInput':'', 'ObjectInputStream':'', 'ObjectInputValidation':'', 'ObjectOutput':'', 'ObjectOutputStream':'', 'ObjectStreamClass':'', 'ObjectStreamConstants':'', 'ObjectStreamException':'', 'ObjectStreamField':'', 'OptionalDataException':'', 'OutputStream':'', 'OutputStreamWriter':'', 'PipedInputStream':'', 'PipedOutputStream':'', 'PipedReader':'', 'PipedWriter':'', 'PrintStream':'', 'PrintWriter':'', 'PushbackInputStream':'', 'PushbackReader':'', 'RandomAccessFile':'', 'Reader':'', 'SequenceInputStream':'', 'SerialCallbackContext':'', 'Serializable':'', 'SerializablePermission':'', 'StreamCorruptedException':'', 'StreamTokenizer':'', 'StringBufferInputStream':'', 'StringReader':'', 'StringWriter':'', 'SyncFailedException':'', 'UTFDataFormatException':'', 'UncheckedIOException':'', 'UnixFileSystem':'', 'UnsupportedEncodingException':'', 'WriteAbortedException':'', 'Writer':'', 'AbstractPlainDatagramSocketImpl':'', 'AbstractPlainSocketImpl':'', 'Authenticator':'', 'BindException':'', 'CacheRequest':'', 'CacheResponse':'', 'ConnectException':'', 'ContentHandler':'', 'ContentHandlerFactory':'', 'CookieHandler':'', 'CookieManager':'', 'CookiePolicy':'', 'CookieStore':'', 'DatagramPacket':'', 'DatagramSocket':'', 'DatagramSocketImpl':'', 'DatagramSocketImplFactory':'', 'DefaultDatagramSocketImplFactory':'', 'DefaultInterface':'', 'FactoryURLClassLoader':'', 'FileNameMap':'', 'HostPortrange':'', 'HttpConnectSocketImpl':'', 'HttpCookie':'', 'HttpRetryException':'', 'HttpURLConnection':'', 'IDN':'', 'InMemoryCookieStore':'', 'Inet4Address':'', 'Inet4AddressImpl':'', 'Inet6Address':'', 'Inet6AddressImpl':'', 'InetAddress':'', 'InetAddressContainer':'', 'InetAddressImpl':'', 'InetAddressImplFactory':'', 'InetSocketAddress':'', 'InterfaceAddress':'', 'JarURLConnection':'', 'MalformedURLException':'', 'MulticastSocket':'', 'NetPermission':'', 'NetworkInterface':'', 'NoRouteToHostException':'', 'Parts':'', 'PasswordAuthentication':'', 'PlainDatagramSocketImpl':'', 'PlainSocketImpl':'', 'PortUnreachableException':'', 'ProtocolException':'', 'ProtocolFamily':'', 'Proxy':'', 'ProxySelector':'', 'ResponseCache':'', 'SdpSocketImpl':'', 'SecureCacheResponse':'', 'ServerSocket':'', 'Socket':'', 'SocketAddress':'', 'SocketException':'', 'SocketImpl':'', 'SocketImplFactory':'', 'SocketInputStream':'', 'SocketOption':'', 'SocketOptions':'', 'SocketOutputStream':'', 'SocketPermission':'', 'SocketPermissionCollection':'', 'SocketSecrets':'', 'SocketTimeoutException':'', 'SocksConsts':'', 'SocksSocketImpl':'', 'StandardProtocolFamily':'', 'StandardSocketOptions':'', 'URI':'', 'URISyntaxException':'', 'URL':'', 'URLClassLoader':'', 'URLConnection':'', 'URLDecoder':'', 'URLEncoder':'', 'URLPermission':'', 'URLStreamHandler':'', 'URLStreamHandlerFactory':'', 'UnknownContentHandler':'', 'UnknownHostException':'', 'UnknownServiceException':'', 'AbstractCollection':'', 'AbstractList':'', 'AbstractMap':'', 'AbstractQueue':'', 'AbstractSequentialList':'', 'AbstractSet':'', 'ArrayDeque':'', 'ArrayList':'', 'ArrayPrefixHelpers':'', 'Arrays':'', 'ArraysParallelSortHelpers':'', 'Base64':'', 'BitSet':'', 'Calendar':'', 'Collection':'', 'Collections':'', 'ComparableTimSort':'', 'Comparator':'', 'Comparators':'', 'ConcurrentModificationException':'', 'Currency':'', 'Date':'', 'Deque':'', 'Dictionary':'', 'DoubleSummaryStatistics':'', 'DualPivotQuicksort':'', 'DuplicateFormatFlagsException':'', 'EmptyStackException':'', 'EnumMap':'', 'EnumSet':'', 'Enumeration':'', 'EventListener':'', 'EventListenerProxy':'', 'EventObject':'', 'FormatFlagsConversionMismatchException':'', 'Formattable':'', 'FormattableFlags':'', 'Formatter':'', 'FormatterClosedException':'', 'GregorianCalendar':'', 'HashMap':'', 'HashSet':'', 'Hashtable':'', 'IdentityHashMap':'', 'IllegalFormatCodePointException':'', 'IllegalFormatConversionException':'', 'IllegalFormatException':'', 'IllegalFormatFlagsException':'', 'IllegalFormatPrecisionException':'', 'IllegalFormatWidthException':'', 'IllformedLocaleException':'', 'InputMismatchException':'', 'IntSummaryStatistics':'', 'InvalidPropertiesFormatException':'', 'Iterator':'', 'JapaneseImperialCalendar':'', 'JumboEnumSet':'', 'LinkedHashMap':'', 'LinkedHashSet':'', 'LinkedList':'', 'List':'', 'ListIterator':'', 'ListResourceBundle':'', 'Locale':'', 'LocaleISOData':'', 'LongSummaryStatistics':'', 'Map':'', 'MissingFormatArgumentException':'', 'MissingFormatWidthException':'', 'MissingResourceException':'', 'NavigableMap':'', 'NavigableSet':'', 'NoSuchElementException':'', 'Objects':'', 'Observable':'', 'Observer':'', 'Optional':'', 'OptionalDouble':'', 'OptionalInt':'', 'OptionalLong':'', 'PrimitiveIterator':'', 'PriorityQueue':'', 'Properties':'', 'PropertyPermission':'', 'PropertyPermissionCollection':'', 'PropertyResourceBundle':'', 'Queue':'', 'Random':'', 'RandomAccess':'', 'RandomAccessSubList':'', 'RegularEnumSet':'', 'ResourceBundle':'', 'Scanner':'', 'ServiceConfigurationError':'', 'ServiceLoader':'', 'Set':'', 'SimpleTimeZone':'', 'SortedMap':'', 'SortedSet':'', 'Spliterator':'', 'Spliterators':'', 'SplittableRandom':'', 'Stack':'', 'StringJoiner':'', 'StringTokenizer':'', 'SubList':'', 'TaskQueue':'', 'TimSort':'', 'TimeZone':'', 'Timer':'', 'TimerTask':'', 'TimerThread':'', 'TooManyListenersException':'', 'TreeMap':'', 'TreeSet':'', 'Tripwire':'', 'UUID':'', 'UnknownFormatConversionException':'', 'UnknownFormatFlagsException':'', 'Vector':'', 'WeakHashMap':'', 'AdaptingMetaClass':'', 'BenchmarkInterceptor':'', 'Binding':'', 'Buildable':'', 'Category':'', 'Delegate':'', 'DelegatingMetaClass':'', 'DeprecationException':'', 'EmptyRange':'', 'ExpandoMetaClass':'', 'ExpandoMetaClassCreationHandle':'', 'GString':'', 'Grab':'', 'GrabConfig':'', 'GrabExclude':'', 'GrabResolver':'', 'Grapes':'', 'GroovyClassLoader':'', 'GroovyCodeSource':'', 'GroovyInterceptable':'', 'GroovyLogTestCase':'', 'GroovyObject':'', 'GroovyObjectSupport':'', 'GroovyResourceLoader':'', 'GroovyRuntimeException':'', 'GroovyShell':'', 'GroovySystem':'', 'IllegalPropertyAccessException':'', 'Immutable':'', 'IntRange':'', 'Interceptor':'', 'Lazy':'', 'MapWithDefault':'', 'MetaArrayLengthProperty':'', 'MetaBeanProperty':'', 'MetaClass':'', 'MetaClassImpl':'', 'MetaClassRegistry':'', 'MetaClassRegistryChangeEvent':'', 'MetaClassRegistryChangeEventListener':'', 'MetaExpandoProperty':'', 'MetaMethod':'', 'MetaObjectProtocol':'', 'MetaProperty':'', 'MissingClassException':'', 'MissingFieldException':'', 'MissingMethodException':'', 'MissingPropertyException':'', 'Mixin':'', 'MutableMetaClass':'', 'Newify':'', 'NonEmptySequence':'', 'ObjectRange':'', 'PackageScope':'', 'ParameterArray':'', 'PropertyAccessInterceptor':'', 'PropertyValue':'', 'ProxyMetaClass':'', 'Range':'', 'ReadOnlyPropertyException':'', 'Reference':'', 'Script':'', 'Sequence':'', 'Singleton':'', 'SpreadListEvaluatingException':'', 'SpreadMap':'', 'SpreadMapEvaluatingException':'', 'StringWriterIOException':'', 'TracingInterceptor':'', 'Tuple':'', 'Writable':'', 'AbstractFactory':'', 'AllTestSuite':'', 'AntBuilder':'', 'AntBuilderLocator':'', 'BuilderSupport':'', 'CharsetToolkit':'', 'CliBuilder':'', 'ConfigBinding':'', 'ConfigObject':'', 'ConfigSlurper':'', 'Eval':'', 'Expando':'', 'Factory':'', 'FactoryBuilderSupport':'', 'FactoryInterceptorMetaClass':'', 'FileNameByRegexFinder':'', 'FileNameFinder':'', 'GroovyCollections':'', 'GroovyLog':'', 'GroovyMBean':'', 'GroovyScriptEngine':'', 'GroovyShellTestCase':'', 'GroovyTestCase':'', 'GroovyTestSuite':'', 'IFileNameFinder':'', 'IndentPrinter':'', 'JavadocAssertionTestBuilder':'', 'JavadocAssertionTestSuite':'', 'MapEntry':'', 'Node':'', 'NodeBuilder':'', 'NodeList':'', 'NodePrinter':'', 'ObjectGraphBuilder':'', 'ObservableList':'', 'ObservableMap':'', 'OptionAccessor':'', 'OrderBy':'', 'PermutationGenerator':'', 'ProxyGenerator':'', 'ResourceConnector':'', 'ResourceException':'', 'ScriptException':'', 'XmlNodePrinter':'', 'XmlParser':'', 'XmlSlurper':''},
        \ 'kotlin' : {}
    \ }
endif

if !exists('g:vimport_auto_organize')
    let g:vimport_auto_organize = 1
endif

if !exists('g:vimport_auto_remove')
    let g:vimport_auto_remove = 1
endif

if !exists('g:vimport_import_lists') " filetypes mapped to files to use for class lookup
    let g:vimport_import_lists = {'java':[], 'groovy':[], 'kotlin':[]}
endif

if !exists('g:vimport_import_groups')
    let g:vimport_import_groups = []
endif

if !exists('g:vimport_filepath_cache') " cache of local files
    let g:vimport_filepath_cache = {}
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
    let original_pos = getpos('.')
    let classToFind = expand("<cword>")

    let result = s:InsertImportForClassName(classToFind)

    if !result
        echoerr "no import was found"
    else
        call OrganizeImports(g:vimport_auto_remove, g:vimport_auto_organize)
    endif

    call setpos('.', original_pos)
endfunction


function! s:InsertImportForClassName(classToFind)

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
        return 0
    else
        call s:CreateImports(pathList)
        return 1
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
        if !has_key(g:vimport_import_lists, root)
            call VimportLoadImportsFromGradle()
        endif
        if has_key(g:vimport_import_lists, &filetype)
            return g:vimport_import_lists[root] + g:vimport_import_lists[&filetype]
        else
            return g:vimport_import_lists[root]
        endif
    else
        return g:vimport_import_lists[&filetype]
    endif
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

function! s:CreateImports(pathList)
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
        if chosenIndex ==# ''
            return
        endif
        let chosenPath = a:pathList[chosenIndex-1]
        let &cmdheight = originalCmdHeight
        redraw! "Prevent messages from stacking and causing a 'Press Enter..' message
        call inputrestore()
    endif
    call s:VimportCreateImport(chosenPath)
endfunction

function! s:VimportCreateImport(path)
    let import = 'import ' . a:path
    let extension = expand("%:e")
    if (extension ==# 'java')
        let formattedImport = import . ';'
    else
        let formattedImport = import
    endif

    let packageLine = s:GetPackageLineNumber(expand("%:p"))
    if packageLine > -1
        execute "normal " . (packageLine + 1) . "Go"
    else
        execute "normal ggo"
    endif
    execute "normal I" . formattedImport . "\<Esc>"
endfunction

function! ShouldCreateImport(path)
    let currentpackage = GetCurrentPackage()
    let importPackage = s:RemoveFileFromPackage(a:path)
    if importPackage != ''
        if importPackage != currentpackage
            let starredImport = search(importPackage . "\\.\\*", 'nwc')
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
    let line = s:GetPackageLineNumber(a:filePath)
    if line == -1
        return ''
    endif
    return getline(line)
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

    if (a:remove)
        let lines = s:RemoveUnneededImportsFromList(lines)
    endif
    if (a:sort)
        let lines = s:SortImports(lines)
    endif

    call s:VimportWriteImports(lines)
    call s:SpaceAfterPackage()

    call setpos('.', pos)
endfunction


function s:VimportWriteImports(lines)
    for line in a:lines
        execute "normal I" . line . "\<CR>"
    endfor
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

function! s:SpaceAfterPackage()
    let pos = getpos('.')

    execute "normal gg^"
    let packageStart = search("^package", 'c')
    if packageStart == 0
        return
    endif

    let importStart = search("^import", 'c')
    if importStart == 0
        return
    endif

    let expectedImportStart = (packageStart + 2)
    if importStart != expectedImportStart
        execute "normal O"
    endif

    call setpos('.', pos)
endfunction

function! GrabImportBlock()

    execute "normal gg^"
    let start = search("^import", 'c')
    let end = search("^import", 'b')
    if start == 0
        return []
    endif
    let lines = getline(start, end)

    execute "normal " . start . "G"
    if end == start
        execute 'normal "_dd'
    else
        execute 'normal "_d' . (end-start) . "j"
    endif
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
    return s:VimportAddBlankLines(defaultGroup)

endfunction

function! RemoveUnneededImports()

    let pos = getpos('.')
    let lines = GrabImportBlock()
    if lines == []
        " No imports to organize
        return
    endif

    let updatedLines = s:RemoveUnneededImportsFromList(lines)

    for line in updatedLines
        execute "normal I" . line . "\<CR>"
    endfor

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
            if classname ==# "*" || s:CountOccurances(classname) > 0
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
    for importFile in importFiles
        if filereadable(importFile)
            for line in readfile(importFile)
                if len(line) > 0
                    if line[0] != '"'
                        call add(g:vimport_import_lists[a:filetype], line)
                    endif
                endif
            endfor
        endif
    endfor
endfunction


function! VimportLoadImportsFromGradle()

    redraw! "Prevent messages from stacking and causing a 'Press Enter..' message
    echo "Loading classpath from Gradle..."
    call s:VimportCacheGradleClasspath()
    let root = s:VimportFindGradleRoot()
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
    execute ":keeppatterns " . start . ",$s/\\v[^a-z](([A-Z]+[a-z0-9]+)+)/\\=s:AddToMatches(submatch(1))/gn"

    let list = s:classNames
    " Filter duplicates
    let list=filter(copy(list), 'index(list, v:val, v:key+1)==-1')

    for item in list
        if !has_key(g:vimport_ignore_classnames[&filetype], item)
            call s:InsertImportForClassName(item)
        endif
    endfor

    call OrganizeImports(g:vimport_auto_remove, g:vimport_auto_organize)
    echo "Done with import all"

endfunction

command! VimportReloadImportCache :call VimportLoadImports(&filetype) "Cache imports from import files
command! VimportReloadGradleCache :call VimportLoadImportsFromGradle() "Reload the cache from the gradle build
command! VimportReloadFilepathCache :call RefreshFilePathListCache() "Reload the cache from local file system
command! VimportImportAll :call VimportImportAll() "Search the file for class names and run InsertImport on each one

command! RemoveUnneededImports :call RemoveUnneededImports() "Remove imports that aren't referenced in the file
command! InsertImport :call InsertImport() "Insert the import under the word
command! OrganizeImports :call OrganizeImports(g:vimport_auto_remove, 1) "Sort the imports and put spaces between packages with different spaces

call VimportLoadImports('java')
call VimportLoadImports('groovy')
call VimportLoadImports('kotlin')

"Key mappings
if g:vimport_map_keys
    execute "nnoremap" g:vimport_insert_shortcut ":call InsertImport()<CR>"
    execute "nnoremap" g:vimport_gradle_reload_shortcut ":call VimportLoadImportsFromGradle()<CR>"
endif
