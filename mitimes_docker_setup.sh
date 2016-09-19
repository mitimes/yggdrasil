#!/bin/bash

echo Input e-mail:
read email
echo Input github username:
read github_username
echo Input github password:
read github_password
echo Input AWS Secret Key ID:
read aws_secret_key_id
echo Input AWS Secret Key:
read aws_secret_key

git config --global user.name $github_username
git config --global user.email $email

mkdir -p ~/sites
cd ~/sites

git clone https://${github_username}:${github_password}@github.com/mitimes/yggdrasil.git
git clone https://${github_username}:${github_password}@github.com/mitimes/elasticsearch.git
git clone https://${github_username}:${github_password}@github.com/mitimes/api.git
git clone https://${github_username}:${github_password}@github.com/mitimes/web.git
git clone https://${github_username}:${github_password}@github.com/mitimes/client-hub.git
git clone https://${github_username}:${github_password}@github.com/mitimes/docker-postgresql.git
git clone https://${github_username}:${github_password}@github.com/mitimes/jobs.git

echo "alias dc='docker-compose'" >> ~/.bash_profile
echo "alias dcupd='dc up -d'" >> ~/.bash_profile
echo "alias dstopa='docker stop $(docker ps -q)'" >> ~/.bash_profile
echo "alias dcstop='dc stop'" >> ~/.bash_profile
echo "alias dcrestart='dcstop && dcupd'" >> ~/.bash_profile
echo "alias mitimesstop='cd ~/sites && cd yggdrasil && dcstop && cd .. && cd api && dcstop && cd .. && cd web && dcstop && cd .. && cd client-hub && dcstop && cd ..'" >> ~/.bash_profile
echo "alias mitimescleanup='if [ -f ~/sites/web/tmp/pids/server.pid ] ; then 
rm ~/sites/web/tmp/pids/server.pid 
fi && if [ -f ~/sites/client-hub/tmp/pids/server.pid ] ; then 
rm ~/sites/client-hub/tmp/pids/server.pid 
fi'" >> ~/.bash_profile
echo "alias mitimesup='cd ~/sites && cd yggdrasil && dcupd && cd .. && cd api && dcupd && cd .. && cd web && dcupd && cd .. && cd client-hub && dcupd && cd ..'" >> ~/.bash_profile
echo "alias mitimesrestart='mitimesstop && mitimescleanup && mitimesup'" >> ~/.bash_profile

cd ~/sites/docker-postgresql
docker build -t mitimes/db . 

echo "export ASSETS_DIRECTORY=\"mitimes-assets\"" >> ~/sites/web/.env
echo "export AWS_ACCESS_KEY_ID=\"${aws_secret_key_id}\"" >> ~/sites/web/.env
echo "export AWS_SECRET_ACCESS_KEY=\"${aws_secret_key}\"" >> ~/sites/web/.env
echo "export AWS_REGION=\"ap-southeast-2\"" >> ~/sites/web/.env
echo "export DATABASE_PASSWORD=\"\"" >> ~/sites/web/.env
echo "export DATABASE_USERNAME=\"postgres\"" >> ~/sites/web/.env

echo "export ASSETS_DIRECTORY=\"mitimes-assets\"" >> ~/sites/client-hub/.env
echo "export AWS_ACCESS_KEY_ID=\"${aws_secret_key_id}\"" >> ~/sites/client-hub/.env
echo "export AWS_SECRET_ACCESS_KEY=\"${aws_secret_key}\"" >> ~/sites/client-hub/.env
echo "export AWS_REGION=\"ap-southeast-2\"" >> ~/sites/client-hub/.env
echo "export DATABASE_PASSWORD=\"\"" >> ~/sites/client-hub/.env
echo "export DATABASE_USERNAME=\"postgres\"" >> ~/sites/client-hub/.env

echo "export ASSETS_DIRECTORY=\"mitimes-assets\"" >> ~/sites/api/.env
echo "export AWS_ACCESS_KEY_ID=\"${aws_secret_key_id}\"" >> ~/sites/api/.env
echo "export AWS_SECRET_ACCESS_KEY=\"${aws_secret_key}\"" >> ~/sites/api/.env
echo "export AWS_REGION=\"ap-southeast-2\"" >> ~/sites/api/.env
echo "export DATABASE_PASSWORD=\"\"" >> ~/sites/api/.env
echo "export DATABASE_USERNAME=\"postgres\"" >> ~/sites/api/.env

echo "development:" >> ~/sites/web/config/database.yml
echo "  adapter: postgresql" >> ~/sites/web/config/database.yml
echo "  port: 5432" >> ~/sites/web/config/database.yml
echo "  username: <%= Rails.application.secrets.database_username %>" >> ~/sites/web/config/database.yml
echo "  encoding: unicode" >> ~/sites/web/config/database.yml
echo "  pool: 5" >> ~/sites/web/config/database.yml
echo "  password: <%= Rails.application.secrets.database_password %>" >> ~/sites/web/config/database.yml
echo "  host: db" >> ~/sites/web/config/database.yml

echo "development:" >> ~/sites/client-hub/config/database.yml
echo "  adapter: postgresql" >> ~/sites/client-hub/config/database.yml
echo "  port: 5432" >> ~/sites/client-hub/config/database.yml
echo "  username: <%= Rails.application.secrets.database_username %>" >> ~/sites/client-hub/config/database.yml
echo "  encoding: unicode" >> ~/sites/client-hub/config/database.yml
echo "  pool: 5" >> ~/sites/client-hub/config/database.yml
echo "  password: <%= Rails.application.secrets.database_password %>" >> ~/sites/client-hub/config/database.yml
echo "  host: db" >> ~/sites/client-hub/config/database.yml

echo "development:" >> ~/sites/web/config/secrets.yml
echo "  assets_directory: <%= ENV['ASSETS_DIRECTORY'] %>" >> ~/sites/web/config/secrets.yml
echo "  aws_access_key: <%= ENV['AWS_ACCESS_KEY'] %>" >> ~/sites/web/config/secrets.yml
echo "  aws_access_secret: <%= ENV['AWS_ACCESS_SECRET'] %>" >> ~/sites/web/config/secrets.yml
echo "  aws_region: <%= ENV['AWS_REGION'] %>" >> ~/sites/web/config/secrets.yml
echo "  database_password: <%= ENV['DATABASE_PASSWORD'] %>" >> ~/sites/web/config/secrets.yml
echo "  database_username: <%= ENV['DATABASE_USERNAME'] %>" >> ~/sites/web/config/secrets.yml
echo "  elasticsearch_url: 'http://elasticsearch:9200/'" >> ~/sites/web/config/secrets.yml
echo "  redis_url: <%= \"redis://redis:6379\" %>" >> ~/sites/web/config/secrets.yml
echo "  skeleton_key: 'password'" >> ~/sites/web/config/secrets.yml
echo "  secret_key_base: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'" >> ~/sites/web/config/secrets.yml

echo "development:" >> ~/sites/client-hub/config/secrets.yml
echo "  assets_directory: <%= ENV['ASSETS_DIRECTORY'] %>" >> ~/sites/client-hub/config/secrets.yml
echo "  aws_access_key: <%= ENV['AWS_ACCESS_KEY'] %>" >> ~/sites/client-hub/config/secrets.yml
echo "  aws_access_secret: <%= ENV['AWS_ACCESS_SECRET'] %>" >> ~/sites/client-hub/config/secrets.yml
echo "  aws_region: <%= ENV['AWS_REGION'] %>" >> ~/sites/client-hub/config/secrets.yml
echo "  database_password: <%= ENV['DATABASE_PASSWORD'] %>" >> ~/sites/client-hub/config/secrets.yml
echo "  database_username: <%= ENV['DATABASE_USERNAME'] %>" >> ~/sites/client-hub/config/secrets.yml
echo "  elasticsearch_url: 'http://elasticsearch:9200/'" >> ~/sites/client-hub/config/secrets.yml
echo "  redis_url: <%= \"redis://redis:6379\" %>" >> ~/sites/client-hub/config/secrets.yml
echo "  skeleton_key: 'password'" >> ~/sites/client-hub/config/secrets.yml
echo "  secret_key_base: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'" >> ~/sites/client-hub/config/secrets.yml

cd ~/sites && cd yggdrasil && docker-compose up -d && cd .. && cd api && docker-compose up -d && cd .. && cd web && docker-compose up -d && cd .. && cd client-hub && docker-compose up -d && cd ..

echo Done with everything
