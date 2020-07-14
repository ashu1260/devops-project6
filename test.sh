#! /bin/bash 

statuscode=$(curl -o  /dev/null -s -w "%{http_code}"  192.168.99.103:32040/html/index.html)
echo $statuscode

if [ $statuscode == 200 ]
then
	echo "all good!"
	exit 1
else
      echo "something went wrong!"
        exit 0
fi
