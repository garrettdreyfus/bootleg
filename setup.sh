echo Repository name:
read projectname
#create Project repo
mkdir -p /var/www/$projectname
cd /var/www/$projectname
git init
git add .
git commit -m "initial empty commit"
#create hosted repo. 
mkdir -p /var/git/$projectname.git
cd /var/git/$projectname.git
git init --bare
cd /var/www/$projectname
git checkout master
git push /var/git/$projectname.git master
#add branch
echo '[remote "hub"]
url = /var/git/'$projectname.git'
fetch = +refs/heads/*:refs/remotes/hub/*
' >> /var/www/$projectname/.git/config
#add hook
touch /var/git/$projectname.git/hooks/post-update
echo "
echo
echo **** Pulling changes
echo

cd /var/www/$projectname || exit
unset GIT_DIR
git pull hub master

exec git-update-server-info" >> /var/git/$projectname.git/hooks/post-update
chmod +x /var/git/$projectname.git/hooks/post-update
