************************
LESSON 1 - COMMAND LINES
************************

Command lines\
ls\
ls --color=no
ls --color=yes
ls --=auto
clear

ls command has multiple arguments that we can add to change the output of the command
"-"these are arguments
ls -l 	long list information about files
"-" dash means we will pass one letter argument like "l"
"--" the argument will contain mere than one letter, most likely an english word
"l" means long listing format

by default 
    - every permission has a hard link
    - every object has 1 hard link

Owner 
    -means who owns it at this moment not who created it
Group
    -owner belongs to the group (of users)
    -groupmates has specific access to the file
Size
    -file in bites

Date and time of last modification of the object

File Name

UID (user identifier) and GID - (Group identifier)

l -n command
    can be listed in a numeric way by entering ls -1
    it works like ls -l but it changes the user-friendly names to UIDs and GIDs

right now we listed all files in alphabetical order

dotfiles 
    - files that are hidden
    - Linux uses . on the beginning of the objects name called dotfiles

ls -a
    shows the dotfiles
    . means the current directory of the user
    .. the second dot means the parent directory

a  means all
A  means almost all

ls -A 
    shows all the content off the current directory in bare format with details like types, size, modified date and time, permissions, links, etc.

Linux allow to list and sort all files using different options.
    ls by alphabetical order

l   
    (long format): Shows detailed information for each file or directory, including permissions, owner, group, size, and timestamp.
t   
    (time sort): Sorts the list by time, with the newest files appearing first.
u   
    (access time): Modifies the sort to use the last access time of the file, instead of the default modification time. 

atime or command line - last time file accessed
mtime or command line 
    ls -lt (last time modified)
ctime or command line - last metadata modification (permissions change, location etc.)
    ls -ltc

                Timestamp - number of seconds passed from Unix epoch (Jan 1, 1970)
                example:
                $ date +%s
                1635797690
                $ date
                Mon 01 Nov 2021 08:14:52 PM UTC

date - shows the date

ls -lt 
    -t this argument sorts the files with the newest to last modification time

touch theNewestFile (creates a new file)
echo "hello world!" > file-02 (this will add something to the file)

S - capital S means sort

ls -s 
    shows the short list of files and space (size)
ls -ls
    list the short list
ls -lS list the short list by largest to smallest

-h or --human-readable
    ls -lh prints the size of the files not by bytes rather the more readable form K, M,or G
    h uses the powers of 1024 so, 1K is a 1 powered by 1024. we have another option
ls - --si
    which uses powers of 1000
ls -lSh 
    sort with h parameter

ls -1 vs ls -l
    obvious you don't use both together because the do the same thing, only difference is one is detailed and one is just the name
    -1 commands you only print one entry per line
    -l command you print a detailed listing of files each item on its own line so they are conflicting commands

--format
    usable when scripting, les is used for input for other parts of the script
ls --format=commas
    will print the files separated by commas
    you can use shorter syntax and write ls -m

Surprise! 
    -1 is also the  --format option
    in full use ls --format=long

ls -lQ 
    prints the filenames in quotes

--time-style
    changes the way the date is formated in long format
    ls -l
    ls -l --time-style=locale
    ls -l --time-style=iso
    ls -l --time-style=full-iso

*********************************
LESSON 2 - YOUR BEST FRIEND - man
*********************************

Basic commands

man 
    an interface to the system reference manuals

SYNOPSIS
       man [man options] [[section] page ...] ...
       man -k [apropos options] regexp ...
       man -K [man options] [section] term ...
       man -f [whatis options] page ...
       man -l [man options] file ...
       man -w|-W [man options] page ...

Description
	Is the system's manual pager. To search for things in the manual

Man -f ls 
	-When searching in man it only gives the first page of the manual. How to check what 		sections/pages we have available

man intro
man 1 intro 
man 8 intro
	above command is manual, page 8, intro

********************************
LESSON 3 - WORK WITH DIRECTORIES
********************************

ls -l 	check directory
mkdir	create directory ie. mkdir myfirstdirectory

creating multiple directories 
	create 10 directories, starting with testdir1 to testdir10. How to do it in one command?
		mkdir testdir{1..10} (*you can remove this directory using rmdir testdir{1..10})
	another approach way you can list the directories 
		mkdir mydirectory anotherdirectory thirddirectory

In order to create deeper structure, we have to use -p argument. This allows us to create the whole structure, without creating parent directory as first step.
	lmkdir -p parentdir/childdir{01..100}
take a look into the parent directory 	ls -l parentdir

MOVE BETWEEN DIRECTORIES
	cd parentdir 			to bring us to the parent directory
	ls				to list what inside
	pwd 				to show the directory yu are in now
	cd parentdir/childdir023 	to move two steps into the directory
	cd .. move back	cd../.. move back 2x

Absolute path 
		"/" represents the root of the path
		cd ../../../var/log/nginx	cd /var/log/nginx these represent the same thing
When We place / on the beginning of the path it informs the system about our intention to use absolute path. In the first example we use relative path. It simply means we are navigating from the current position.

To go back to the home directory
	cd	by itself is the shortest way to get back to the home directory
	cd ~	means home directory
	cd 	$HOME

Creating 100 hello directories command
	mkdir hello{001..100}

Remove all directories from /directory
	rmdir /directory/*

how to remove everything without confirming from /mydir/somedir
	rm -rf somedir
		

**********************************
LESSON 4 - CREATE AND DELETE FILES
**********************************

touch	(to create empty files in Linux)
*	To list all of them. wildcard character used how? 
	ie touch my{01..100}file created 100 files ls my*file prints them in terminal

?	any single numerical character
	touch try1 try2 try01 creates these 3 files but if I just wanted to list the first two
	I can use 	ls try? and it will list 	try1  try2

vim	is also another way to create new files
:qa	used in Vim/Vi to quit all open files without saving any changes


*********************************
LESSON 5 - PIPES AND REDIRECTIONS			DO THIS OVER AGAIN, I DON'T GET IT!
*********************************

used to send (or retrieve) some information sent from one command or script to another command or script
	Count number of lines in the file
	Select uniq values from one file and write it in another
	Find occurances of some string in the file or system
	and many more

COMMANDS

grep		searches for given patters in the output which may be the file or output from 			another 		command		ie. grep 'case' .bashrc will search for 		pattern 'case' in a file '.bashrc'

wc		commonly used fro counting lines but also: words, newlines, bytes

wc -l .bashrc	will count how many lines (-l argument) are in our .bashrc file

sort 		will sort the output in alphabetical order

sort numbers.txt


code breakdown
-rw-r--r-- 1 user group 1024 Oct 5 10:30 myfile.txt

	-rw-r--r--: File permissions (type, owner, group, others).
	1: Number of hard links to the file.
	user: Owner of the file.
	group: Group owner of the file.
	1024: Size of the file in bytes.
	Oct 5 10:30: Last modification date and time.
	myfile.txt: Name of the file or directory.

***************************
LESSON 6 - READING THE FILE
***************************

cat (concatenate) dictionary: to link together in a series or a chain
    can print all files but it's not smart to print binary files
    it is usable for text tiles

vim and view (vi)
    cant just prints the file. vi is fully functional, very powerful text editor
view    same as vim but runs in read only mode

dwfi4t0gjvg0eg5jqh58wgpoweh4w8ghbo;witheaigh
    is what one does when incidentally opens vi and doesn't have any idea how to quit.
:q  
    to exit vim press ESC and then :q - what means quit
:q!
    if you changed something in the file and don't want to save the changes
:wq
    If you want to save these changes, press :wq - write and quit
ESC
    we switch between modes in vim
        INSERT mode is used to edit the file
        COMMAND mode we can interact and do actions like save and quit
        VISUAL mode we can do a selection of text
            ie.     vim testfile  to show the file       
                    ESC and then :q!

more  
    cat shows everything a more managable option is more
    shows a small piece of the file and you can navigate forward by pressing return or enter * can't go backwards though
q   to quit this

less
    more sophisticated, this command gives better navigation. can move forward and back and can search for strings using / sign

more testfile    
    move forward using

Pipes
    What is interesting, we can use cat, more and less together with pipes.

cat testfile | more

cat testfile | less

head        head testfile 
    if you don't want to print the whole file. head shows the first 10 lines
head -n2    head -n2 testfile
      If we wish to see different number of lines, we can use -n argument and pass the number for lines

tail   
    tail does exactly the same thing as head does, but from the end of the file

******************************
LESSON 7 - COPY AND MOVE FILES
******************************

tree  
    recursively shows the content of a directory
    recursively means if there is a subdirectory, its content will be shown as well

cp  
    is the command to copy file
    cp source target

mv
    move file
    can also move directories
    
diff
    a way to compare 2 files ie. if you have files that have many lines and you want to see where they differ

**************************
LESSON 8 - THE TOP COMMAND
**************************

First line  -

Second line - Second line shows us information about processes in our system

Third line  - This line shows the CPU(s) utilization, splitted to specific types

**************************
LESSON 9 - THE ps COMMAND
**************************

ps  (process status)
    allows us to understand what the system is doing at this moment
    we can use arguments with this but with this it accepts arguments with or without the dash ie.  ps a    or    ps -a

PID 
    this is the process id.
TTY
    terminal associated with the process

TIME
    total time of CPU usage
CMD
    the command which is running

STATUSES
            D - uninterruptible sleep (usually IO)
            I - Idle kernel thread
            R - running or runnable (on run queue)
            S - interruptible sleep (waiting for an event to complete)
            T - stopped by job control signal
            t - stopped by debugger during the tracing
            X - dead (should never be seen)
            Z - defunct ("zombie") process, terminated but not reaped by its parent

some status may have a second letter here are the most important
            < - high-priority (not nice to other users)
            N - low-priority (nice to other users)
            s - is a session leader
            l - is multi-threaded
            + - is in the foreground process group

**************************
LESSON 9 - CREATE ALIASES
**************************

aliases     
        are used instead of writing out long format and with hidden files. It saves time with lines we need to repeat a lot
        ie. ls -al can become ll

alias (command)
        used to create
        ie to create an alias for ls    alias lh='ls -alh'
unalias lh     to remove alias lh

*you can create aliases as a current user but you are able to create aliases for all users.

