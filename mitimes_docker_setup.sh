#!/bin/bash

echo Input AWS Secret Key ID:
read aws_secret_key_id
echo Input AWS Secret Key:
read aws_secret_key


mkdir -p ~/sites
cd ~/sites
git clone git@github.com:mitimes/yggdrasil.git
git clone git@github.com:mitimes/elasticsearch.git
git clone git@github.com:mitimes/api.git
git clone git@github.com:mitimes/web.git
git clone git@github.com:mitimes/client-hub.git
git clone git@github.com:mitimes/docker-postgresql.git


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

# FOR RECOMPILE ASSETS
cat > ~/sites/web/.env <<-EOM
export ASSETS_DIRECTORY="mitimes-assets"
export AWS_ACCESS_KEY_ID="${aws_secret_key_id}"
export AWS_SECRET_ACCESS_KEY="${aws_secret_key}"
export AWS_REGION="ap-southeast-2"
EOM

cat > ~/sites/client-hub/.env <<-EOM
export ASSETS_DIRECTORY="mitimes-assets"
export AWS_ACCESS_KEY="${aws_secret_key_id}"
export AWS_ACCESS_SECRET="${aws_secret_key}"
export AWS_REGION="ap-southeast-2"
EOM


echo Done with everything
