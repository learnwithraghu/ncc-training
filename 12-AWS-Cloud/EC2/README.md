# EC2 HTML on Nginx

Commands used to run `html` on EC2:

```bash
cd
vi index.html
cat index.html
clear
sudo dnf update -y
sudo dnf install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl restart nginx
mv index.html /usr/share/nginx/html/
sudo systemctl restart nginx
cat /usr/share/nginx/html/index.html
mv index.html /usr/share/nginx/html/
cat /usr/share/nginx/html/index.html
clear
sudo systemctl restart nginx
history
```
