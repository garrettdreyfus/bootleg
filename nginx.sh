#Nginx
##################################################################
read projectname
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
cd ~
