# GIT 
###########################################
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




#Nginx
##################################################################
apt-get install nginx
service nginx start
mkdir -p /var/www/logs/$projectname
touch /var/www/logs/$projectname/access.log
touch /var/www/logs/$projectname/error.log
echo "
server {
    listen 80;
    root /var/www/"$projectname";
    access_log /var/www/logs/"$projectname"/access.log;
    error_log /var/www/logs/"$projectname"/error.log;
    location / {
        proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        if (!-f $request_filename) {
            proxy_pass http://127.0.0.1:8000;
            break;
        }
    }
}" >> /etc/nginx/sites-available/$projectname.conf
ln -s /etc/nginx/sites-available/$projectname.conf /etc/nginx/sites-enabled/
nginx -t
service nginx reload
