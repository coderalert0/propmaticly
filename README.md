# README

## Setup Instructions

```
ssh -i key.pem ubuntu@ec2-3-143-142-188.us-east-2.compute.amazonaws.com
```

#### Install packages
```
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl certbot python3-certbot-nginx gnupg2 postgresql-client dirmngr nginx build-essential libssl-dev zlib1g-dev libpq-dev nodejs npm libffi-dev libyaml-dev libreadline-dev
```

#### Install Ruby
```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~./.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
```

```
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 3.3.0
rbenv global 3.3.0
```

#### Clone repository
```
ssh-keygen -t ed25519 -C "coderalert0gmail.com"
cat ~/.ssh/id_ed25519.pub #add key to GitHub project
git clone git@github.com:coderalert0/propmaticly.git
```

```
vi ~/.bashrc
export RAILS_ENV=production
export RAILS_SERVE_STATIC_FILES=true
```

#### Create database
```
psql -h propmaticly-prod.crce46og4nsn.us-east-2.rds.amazonaws.com -U gopi -d postgres
CREATE DATABASE propmaticly_production
\q
rake db:create
rake db:migrate
rake db:seed
```

#### Setup Nginx
```
sudo vi /etc/nginx/sites-available/propmaticly
```

```
# Redirect HTTP to HTTPS for both domains
server {
    return 301 https://$host$request_uri;
}

include /etc/nginx/snippets/ssl-propmaticly.conf;

# Landing page (propmaticly.com)
server {
    listen 443 ssl;
    server_name propmaticly.com www.propmaticly.com;

    root /home/ubuntu/propmaticly/public/;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    error_page 404 /404.html;
    location = /404.html {
        root /home/ubuntu/propmaticly/public/404.html;
    }

    include /etc/nginx/snippets/ssl-propmaticly.conf;
}

# Rails App (app.propmaticly.com)
server {
    listen 443 ssl;
    server_name app.propmaticly.com;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location ~ ^/assets/ {
        root /home/ubuntu/propmaticly/public;
        expires max;
        add_header Cache-Control public;
    }

    error_page 500 502 503 504 /500.html;
    error_page 404 /404.html;

    include /etc/nginx/snippets/ssl-propmaticly.conf;
}
```

#### Install SSL Certificate
```
sudo certbot --nginx -d propmaticly.com -d www.propmaticly.com -d app.propmaticly.com
```

#### Create common certificate configuration
```
sudo vi /etc/nginx/snippets/ssl-propmaticly.conf
```

```
ssl_certificate /etc/letsencrypt/live/propmaticly.com/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/propmaticly.com/privkey.pem; # managed by Certbot
ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
```

```
sudo ln -s /etc/nginx/sites-available/propmaticly /etc/nginx/sites-enabled/propmaticly
sudo systemctl start nginx
```

#### Create Puma service
```
sudo vi /etc/systemd/system/puma.service
```

```
[Unit]
Description=Puma Rails App Server
After=network.target

[Service]
Environment="RAILS_ENV=production"
User=ubuntu
WorkingDirectory=/home/ubuntu/propmaticly
ExecStart=/home/ubuntu/.rbenv/shims/bundle exec puma -C config/puma.rb
Restart=always

[Install]
WantedBy=multi-user.target
```

```
sudo systemctl enable puma
sudo systemctl start puma
```

#### Create delayed job service
```
sudo vi /etc/systemd/system/delayed_job.service
```

```
[Unit]
Description=Delayed Job Background Worker
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/propmaticly
ExecStart=/home/ubuntu/.rbenv/shims/bundle exec bin/delayed_job start
ExecStop=/home/ubuntu/.rbenv/shims/bundle exec bin/delayed_job stop
Restart=always

[Install]
WantedBy=multi-user.target
```

```
sudo systemctl daemon-reload
sudo systemctl enable delayed_job
sudo systemctl start delayed_job
```

#### Setup CloudWatch agent
```
wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
```

#### Start server
```
scp -i ~propmaticly/config/master.key ubuntu@ec2-3-143-142-188.us-east-2.compute.amazonaws.com:/home/ubuntu/propmaticly/config/
whenever --update-crontab
bundle exec rails assets:precompile
bundle exec rails s
```

Might need to chmod some directories. Experienced issues with public/assets