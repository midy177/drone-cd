#!/bin/bash
. /etc/profile
. ~/.bash_profile
images=registry-intl-vpc.cn-hongkong.aliyuncs.com/pizzausdego/pizza-usde
docker rmi -f ${images}:develop 2>&1
docker pull ${images}:develop 2>&1
oldtag=`grep "image: ${images}" docker-compose.yml|awk NR==1|awk -F ":" '{print $NF}'`
if [ "${oldtag}" = "02" ];then
   docker tag ${images}:develop ${images}:01 2>&1
   echo "开始修改tag"
   sed -i "s#${images}:${oldtag}#${images}:01#g" docker-compose.yml
   echo "开始执行滚动发布"
   docker stack deploy -c docker-compose.yml pizza 2> /dev/null
   docker rmi -f ${images}:02 2>&1
elif [ "${oldtag}" = "01" ];then
   docker tag ${images}:develop ${images}:02 2>&1
   echo "开始修改tag"
   sed -i "s#${images}:${oldtag}#${images}:02#g" docker-compose.yml
   echo "开始执行滚动发布"
   docker stack deploy -c docker-compose.yml pizza 2> /dev/null
   docker rmi -f ${images}:01 2>&1
else
	echo "编排文件异常！"
	exit 1
fi
docker service ls|grep pizza 2>&1
echo "开始清理异常退出的容器！"
docker rm $(docker ps -q -f status=exited) 2>/dev/null
docker rmi -f ${images}:develop 2>&1
