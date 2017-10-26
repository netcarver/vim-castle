Vim Configuration Settings
==========================

My vim config settings.


Management
----------

This repo is compatible with [homesick](https://github.com/technicalpickles/homesick), although I personally manage my
entire set of homesick configurations with [homeshick](https://github.com/andsens/homeshick) as I'm no Ruby user. As
such it is a *castle* (and is named to show it) that holds a ```home``` directory under which all its managed files
live.

*Homeshick* takes care of linking all the contained files to their corresponding locations in my real home directory.


[Pathogen](https://github.com/tpope/vim-pathogen) is used to manage most of the vim plugins I use. Each plugin gets its
own config file under .vim/config in which goes any specific setup.



Structure
---------

### home/.vimrc

This is my master vimrc file. In overview, it sets up Pathogen (which loads the plugins), configures some generic
defaults and then loads the plugin config files.

### home/.vim/config/*

Contains individual vim scripts for configuring each plugin.

### home/.vim/bundle/*

This directory contains the plugins I use.
