This is a plugin for vim that allows you to easily add imports within java, groovy, grails and kotlin projects.

The plugin has a few different mechanisms for finding a class's package.  It can search the current working directory, search a text file that lists the full package and classname, or use a gradle build to determine the classpath and find the classes in jar files.  Note that the gradle functionality requires VIM with python support.

## Installation ##

### Vundle (http://github.com/gmarik/vundle) ###

Include the following line in your .vimrc

    Bundle 'sjurgemeyer/vimport'

Then, run

    :BundleInstall


### Pathogen (https://github.com/tpope/vim-pathogen) ###

Clone the plugin's git repository

    git clone git://github.com/sjurgemeyer/vimport.git ~/.vim/bundle/vimport

You can also just copy the files the old fashioned way, but I don't condone that type of behavior


## Usage ##
Please see /doc/vimport.txt for additional details on usage and configuration.
