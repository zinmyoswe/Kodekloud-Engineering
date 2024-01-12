G2403F95A5

G2403F95A5

	I01-240102-001896	ဆုယမင်းသက်
၇/ကတခ(နိုင်)၂၀၆၆၃၂	35000 MMK

The way to get started is to quit talking and begin doing.
Walt Disney
------------------------------- Linux -----------------------------------------

mkdir test #create the folder
rmdir test #remove the folder
touch test.txt #creat the file
touch  /home/bob/lfcs/lfcs.txt

Copy /tmp/Invoice directory (including all its contents) to /home/bob directory.
cp -r /tmp/Invoice  /home/bob/

Copy /home/bob/myfile.txt file to /home/bob/data/ directory, make sure to preserve its attributes.
cp --help
cp -a /home/bob/myfile.txt /home/bob/data/

Copy the /home/bob/lfcs directory (including all its content) into /home/bob/old-data/ directory.
cp -r /home/bob/lfcs /home/bob/old-data/

Move all content of /home/bob/lfcs directory to /home/bob/new-data/ directory
mv /home/bob/lfcs/* /home/bob/new-data/

Delete directory /home/bob/lfcs .
rm -rf /home/bob/lfcs

ln #link create -s mean symbiolic softlink 
Create a soft link to /tmp directory. Create this link in /home/bob directory and call it link_to_tmp.
ln -s /tmp /home/bob/link_to_tmp

#hardlink no need
Create a hard link to /tmp/hlink file. Create this link in /home/bob/ directory and call it hlink.
ln  /tmp/hlink /home/bob/hlink

There is a file called /home/bob/new_file, rename this to /home/bob/old_file.
mv /home/bob/new_file /home/bob/old_file

show full time modified 
ls --full-time

Create a directory named 9 under /tmp/1/2/3/4/5/6/7/8 directory. Please note that the structure of sub-directories, from 1 to 8 does not exist. 
However, mkdir has a command line option to automatically create all of these sub-directories automatically in one shot, instead of 9 consecutive commands. 
This option is described in the help output or manual pages as make parent directories as needed. 
Find out what the correct option is and use it to create the directory in one shot.
mkdir -p /tmp/1/2/3/4/5/6/7/8/9

cat spider.txt # display the content of the file
rm spider.txt -r # delete a file
rm -rf * #delete all of file in a directory
man

apropos a command to search the man page files in Unix and Unix-like operating systems
sudo mandb # use when apropos ssh is not work
mandb #refresh

grep = A command-line regex tool
grep #finding a matched word in a file
grep s.ing /usr/file.txt #will find word start with s, end with ing. eg. sting,sling
grep ^fruit /usr/file.txt #show all of word start with fruit eg.fruitcake
grep cat$ /usr/file.txt #end with cat word. eg. pussycat

grep '^sam' /home/bob/testfile.txt #start with sam
grep 'email$' /home/bob/testfile.txt #end with email

history # history

vim test.txt #open the file
click + i #insert file 
Esc+ :wq #save and quit from file

pwd #your current path location
ls # list the file
ll #list the file with description

cp testrename.txt testrename.txt.bak # copy the filename

#copy file to the other directory
cp test.txt /drives/d/2023\ Google\ IT\ Automation\ with\ python/Using\ python\ to\ operate\ with\ operation\ system/
cp filename.txt /home/username/Documents
cp filename1.txt filename2.txt filename3.txt /home/username/Documents

mv # move file to other directory
mv filename.txt /home/username/Documents
mv old_filename.txt new_filename.txt

zip -r dir.zip 3.txt test/ # creating zip with file and folder together
zip file.zip 1.txt 2.txt
zip -u file.zip 3.txt # adding file to existing zip
zip -m file.zip 1.txt
zip -e password.zip 1.txt # zip with password

unzip dir.zip -d forunzip/ #unzip to other directory

------------------------------- file-content-regular-expressions -----------------------------------------

1.Which of the following commands can be used to manipulate strings in a file?
sed command in UNIX stands for stream editor and it can perform lots of functions on file like searching, find and replace, insertion or deletion.

2.Which of the following commands you will use to display the top 5 lines of a file called myfile?
head -5 myfile.txt

3.Which of the following commands you can use to filter out the lines that contain a particular pattern?
grep
grep kyaw myfile.txt

4.How can we ignore the case (small or capital) differences while comparing two files using diff command?
diff -i

5.cut -d ';' -f 2 testfile.txt

6.Change all values enabled to disabled in /home/bob/values.conf config file.
sed -i 's/enabled/disabled/g' /home/bob/values.conf

7.While ignoring the case sensitivity, change all values disabled to enabled in /home/bob/values.conf config file.
For example, any string like disabled, DISABLED, Disabled etc must match and should be replaced with enabled.
sed -i 's/disabled/enabled/gi' /home/bob/values.conf

wc -l /home/bob/values.conf #count line number

8.Change all values enabled to disabled in /home/bob/values.conf config file from line number 500 to 2000.
sed -i '500,2000s/enabled/disabled/g' values.conf

9.Replace all occurrence of string #%$2jh//238720//31223 with $2//23872031223 in /home/bob/data.txt file.
sed -i 's~#%$2jh//238720//31223~$2//23872031223~g' /home/bob/data.txt

egrep #search the word
egrep -w, --word-regexp         force PATTERN to match only whole words

10.Filter out the lines that contain any word that starts with a capital letter and are then followed by exactly two lowercase letters in /etc/nsswitch.conf file 
and save the output in /home/bob/filtered1 file.
You can use the redirection to save your command's output in a file i.e [your-command] > /home/bob/filtered1
egrep -w '[A-Z][a-z]{2}' /etc/nsswitch.conf > /home/bob/filtered1

vi=nano same


12.Delete first 1000 lines from /home/bob/testfile file.
The steps can vary from editor to editor, but let's use vi editor:

Open file with vi editor:


vi /home/bob/testfile

Make sure cursor is on the very first line, then without entering into the insert mode, enter number 1000 and press dd immediately after that. FInally save the file.

13./home/bob/file1 and /home/bob/file2 are 99% identical. But there's 1 unique line that exists only in /home/bob/file1 or in /home/bob/file2.
Find that line and save the same in /home/bob/file3 file.
diff file1 file2 > file3
vi file3

14.In /home/bob/textfile file there's a number that has 5 digits. Save the same in /home/bob/number file.


You can use the redirection to save your command's output in a file i.e [your-command] > /home/bob/number
egrep '[0-9]{5}' textfile > /home/bob/number


#-c is count

15.How many numbers in /home/bob/textfile begin with a number 2, save the count in /home/bob/count file.
You can use the redirection to save your command's output in a file i.e [your-command] > /home/bob/count
grep -c '^2' textfile > /home/bob/count

16.How many lines in /home/bob/testfile file begin with string Section, regardless of case.
Save the count in /home/bob/count_lines file.
grep -ic '^SECTION' testfile > /home/bob/count_lines

18.Save last 500 lines of /home/bob/textfile file in /home/bob/last file.
tail -500  /home/bob/textfile > /home/bob/last

------------------------------- manage user accounts and group -----------------------------------------
1.Set the jane user account to expire on March 1, 2030
sudo usermod -e 2030-03-01 jane

2.Create a system account called apachedev
sudo useradd --system apachedev

3.Jane account i.e jane is expired.Unexpire the same and make sure it never expires again.
sudo usermod -e "" jane

4.Create a user account called jack and set its default login shell to be /bin/csh.
sudo useradd -s /bin/csh jack

5.Delete the user account called jack and ensure his home directory is removed.
sudo userdel -r jack

6.Mark the password for jane as expired to force her to immediately change it the next time she logs in.
sudo chage --lastday 0 jane

7.Add the user jane to the group called developers.
sudo usermod -a -G developers jane

8.Create a group named cricket and set its GID to 9875
sudo groupadd -g 9875 cricket

9.You already created group cricket in the previous question, now rename this group to soccer while preserving the same GID.
sudo groupmod -n soccer cricket

10.Create a user sam with UID 5322, also make it a member of soccer group.
sudo useradd -G soccer sam  --uid 5322

11.Update primary group of user sam and set it to rugby
sudo usermod -g rugby sam

12.Lock the user account called sam
sudo usermod -L sam

13.Delete the group called appdevs.
sudo groupdel appdevs

14.Make sure the user jane gets a warning at least 2 days before the password expires.
sudo chage -W 2 jane

------------------------------- configure user resource limits and user privileges -----------------------------------------
1. 'nproc' user limit case

2.How do we allow the user called trinity to execute any sudo command?
Using 'sudo gpasswd -a trinity wheel' command we can allow the user called trinity to execute any sudo command.

3.Modify the security limits file and make sure that the user called trinity can run no more than 30 processes in her session.
This should be both a hard limit and a soft limit, written in a single line.

Edit /etc/security/limits.conf file:

sudo vi /etc/security/limits.conf

And add below given line at the end of the file:

'trinity - nproc 30'

4.Identify all the security limits currently applied in our user's session and save the same in /home/bob/limits file.
You can use the redirection to save your command's output in a file i.e [your-command] > /home/bob/limits

ulimit -a is seeing all of user limit session
ulimit -a > /home/bob/limits

#visudo is for safely updating the /etc/sudoers file, 
#used by the sudo command for providing and managing privileged access.

5.Modify the sudoers file in such a way to allow the user called trinity to run any sudo command without needing to provide her password.

Edit /etc/sudoers file:

sudo visudo /etc/sudoers

And add below given line at the end of the file:

'trinity    ALL=(ALL)   NOPASSWD: ALL'

6.Modify the sudoers file again. Remove your previous entry for the user called trinity if it still exists.
Now add a new entry that allows trinity to only run the /usr/bin/mount command with sudo.

Edit /etc/sudoers file:

sudo visudo /etc/sudoers

Remove the previous entry for trinity user and add below given line at the end of the /etc/sudoers file:


'trinity ALL=(ALL) /usr/bin/mount'

7.Make changes in security limits file for user stephen so that he can create maximum filesize upto 4 MB. This should be a hard limit.
Edit /etc/security/limits.conf file:

sudo vi /etc/security/limits.conf

Add below given line at the end of the file:

'stephen hard fsize 4096'

8.Set a soft limit of 20 processes for everyone in the salesteam group.
Edit /etc/security/limits.conf file:

sudo vi /etc/security/limits.conf

add this line at the end of the file:

'@salesteam     soft    nproc     20'

9.Define a policy for all the users in the salesteam group to run any sudo command.
Edit /etc/sudoers file:

sudo visudo /etc/sudoers

Add below given line at the end of the file:

'%salesteam     ALL=(ALL)     ALL'

10.Define a policy, so that user trinity be able to run sudo commands as the user sam.
Edit /etc/sudoers file:

sudo visudo /etc/sudoers

Add below given line at the end of the file:

'trinity   ALL=(sam)   ALL'

11.We applied a hard limit of 10 processes for all the users under developers group, but somehow the limit isnt working. Look into the issue and fix the same.

Edit /etc/security/limits.conf file:


sudo vi /etc/security/limits.conf

Look for developers group entry and make sure it looks like this:

@developers     hard    nproc  10

12.Modify the sudoers file again. Remove your previous entry for the user called trinity if it still exists.
Now add a new entry that allows trinity to run all commands with sudo, but only after entering the password.
Edit /etc/sudoers file:

sudo visudo /etc/sudoers

Add below given line in /etc/sudoers file:

'trinity ALL=(ALL) ALL'

