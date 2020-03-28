#!/bin/bash
. /etc/profile
. ~/.bash_profile
intag=$1
imname=$2
detype=$3
servicename=$4
newtag=$(echo $intag|awk '{$1=substr($1,12)}1')
echo "the tag is ${newtag}"
oldtag=`grep "image: ${imname}" docker-compose.yml|awk NR==1|awk -F ":" '{print $NF}'`
echo "docker pull ${imname}:${newtag}"
docker pull ${imname}:${newtag}
if [ $? -eq 0 ]; then
     echo "pull image successfull!"
     sed -i "s#${imname}:${oldtag}#${imname}:${newtag}#g" docker-compose.yml
     if [ $? -eq 0 ]; then
        if [ "${detype}" = "1" ];then  #判断发布类型，1表示docker stack；0表示dokcer compose
           /usr/bin/docker stack deploy -c docker-compose.yml ${servicename} 2>&1
         else
           /usr/local/bin/docker-compose stop && /usr/local/bin/docker-compose rm -f
           /usr/local/bin/docker-compose up -d
        fi

     fi
     docker rm $(docker ps -q -f status=exited) 2>/dev/null
     rm $0
     exit 0
else
     echo "pull image failed! Please check if the image exists in the repository?"
     docker rm $(docker ps -q -f status=exited) 2>/dev/null
     rm $0
     exit 1
fi
