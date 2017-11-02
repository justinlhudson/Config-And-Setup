@echo off

:: Add to target shorcut for 'cmd'
:: cmd.exe /K C:\path\to\env.cmd

:: Aliases
doskey clear=cls
doskey python=C:\<path>\anaconda\4.2.0\python $*
