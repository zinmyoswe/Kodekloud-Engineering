
-------------------1. Git Install and Create Bare Repository -----------------------------
Install git package using yum on Storage server.
After that create a bare repository /opt/media.git (make sure to use exact name).

ssh natasha@ststor01
sudo su -

#This command would prompt the package manager to install Git without asking for confirmation (-y flag).
yum install -y git

#This command is used to list all installed packages that contain "Git" in their names
#Verify Installed git version & path where git need to initiated
rpm -qa | grep Git
ls /opt

#Make sure you init  bare  repo in given path 
cd opt

# Bare repositories are typically used for sharing changes between multiple repositories, such as in a centralized workflow or as a remote repository.
git init --bare media.git

ls
git status

-------------------2. Git Clone Repositories -----------------------------
The repo that needs to be cloned is /opt/ecommerce.git
Clone this git repository under /usr/src/kodekloudrepos directory. Please do not try to make any changes in repo.

ssh natasha@ststor01
sudo su -

#clone git repository under directory mentioned in your task 
cd /usr/src/kodekloudrepos
ls

#Clone
git clone /opt/ecommerce.git
ls

#Validate 
ls ecommerce/

-------------------4. Git Repository Update -----------------------------
Copy sample index.html file from jump host to storage server under cloned repository at /usr/src/kodekloudrepos, 
add/commit the file and push to master branch.

#SCP index.html file from jump server to the storage server  
sudo scp /tmp/index.html natasha@ststor01:/tmp

ssh natasha@ststor01
sudo su -

cd /usr/src/kodekloudrepos/cluster/
ls

#Copy html file from tmp to repo 
#The . at the end represents the current directory. 
cp /tmp/index.html .
ls

git add index.html
git commit -m "add index.html"
git push -u origin master

-------------------5. Git Delete Branches kodekloud -----------------------------

On Storage server in Stratos DC delete a branch named xfusioncorp_apps from /usr/src/kodekloudrepos/apps git repo. 
ssh natasha@ststor01
sudo su -

# Go to the Git repo folder path & check git status
cd /usr/src/kodekloudrepos/apps
git status

# Check existing branches and which one is default before deleting 
git branch -a

# Checkout to any other branch or master to change default branch
git checkout master

#Delete
git branch --delete xfusioncorp_apps

#Validate
git branch -a



---------------------------------------Level2-----------------------------
-------------------1. Git Install and Create Repository -----------------------------
Install git package using yum on Storage server.
After that create/init a git repository /opt/news.git (use the exact name as asked and make sure not to create a bare repository).

ssh natasha@ststor01
sudo su -

#Install git
yum install -y git

rpm -qa | grep Git

ls /opt
cd opt
git init news.git
ls

-------------------2. Git Create Branches -----------------------------
/usr/src/kodekloudrepos/official
On Storage server in Stratos DC create a new branch xfusioncorp_official from master branch in /usr/src/kodekloudrepos/official git repo.

ssh natasha@ststor01
sudo su -

cd /usr/src/kodekloudrepos/official

ls
#Checkout  to master, since its need to create a new branch from master
git checkout master

#Create a new branch from master as per the task
git Checkout -b xfusioncorp_official

git status

#Validate
git branch -a

-------------------3. Git Merge Branches -----------------------------
/opt/official.git. 
cloned at /usr/src/kodekloudrepos on storage server
1Create a new branch devops in /usr/src/kodekloudrepos/official repo from master 
2copy the /tmp/index.html file (on storage server itself)
3Add/commit this file in the new branch and merge back that branch to the master branch

ssh natasha@ststor01
sudo su -

ls /usr/src/kodekloudrepos/official
cd /usr/src/kodekloudrepos/official
git status

#Create a new branch as per the task from the master repo
#-b is create branch
git checkout -b devops
git status

#-a command will show you a list of all branches
git branch -a
cp /tmp/index.html .
ls
git add index.html
git commit -m "add index.html"

# Git Checkout master & merge to new branch
git checkout master
git merge devops


git push -u orgin deveops
git push -u orgin master
git status

-------------------4. Git Manage Remotes -----------------------------
 /opt/apps.git repo and cloned under /usr/src/kodekloudrepos/apps.
 update remote on /usr/src/kodekloudrepos/apps
1In /usr/src/kodekloudrepos/apps repo add a new remote dev_apps and 
 point it to /opt/xfusioncorp_apps.git repository.
2There is a file /tmp/index.html on same server; 
 copy this file to the repo and add/commit to master branch.
 3.Finally push master branch to this new remote origin.
 
#Navigate to the cloned directory 
cd /usr/src/kodekloudrepos/apps
ls

#add remote repo
git remote add dev_apps /opt/xfusioncorp_apps.Git

#Copy HTML file from tmp to repo and add
cp /tmp/index.html .
ls

#Git initialize the new remote repo
git init 
git add index.html
git commit -m "add index.html"
git push -u dev_apps master

-------------------5. Git Revert Some Changes -----------------------------
/usr/src/kodekloudrepos/demo 
In /usr/src/kodekloudrepos/demo git repository,
revert the latest commit ( HEAD ) to the previous commit (JFYI the previous commit hash should be with initial commit message ).

cd /usr/src/kodekloudrepos/demo 
git status
git log
git revert HEAD
git add .
git commit -m "revert demo"
git log