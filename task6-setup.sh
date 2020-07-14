#!/bin/bash



if ls /var/www/html | grep .html 
then 
   echo "html pages"
     if  kubectl get rs | grep html-rs
      then
        echo "replicaset html-rs exists!"
	html=$(kubectl get pods -l app=httpd -o jsonpath="{.items[0].metadata.name}")
	kubectl cp /var/wwww/html  $html:/usr/local/apache2/htdocs

       
      else
          kubectl apply -f /html-rs.yml 
          kubectl expose rs html-rs --type=NodePort --port=80
          html=$(kubectl get pods -l app=httpd -o jsonpath="{.items[0].metadata.name}")
          state=$(kubectl get pods -l app=httpd -o jsonpath="{.items[0].status.phase}")

	  sleep 20

	  kubectl cp /var/www/html  $html:/usr/local/apache2/htdocs
      fi
  
elif ls /var/www/html | grep .php
then
  echo "php pages"
  
      if kubectl get rs | grep php-rs
      then
      
        echo "replicaset php-rs exists!"
        php=$(kubectl get pods -l app=myphpapp -o jsonpath="{.items[0].metadata.name}")
        kubectl cp /var/www/html  $php:/var/www/html
        
      else
      
          kubectl apply -f /php-rs.yml 
          kubectl expose rs php-rs --type=NodePort --port=80
          php=$(kubectl get pods -l app=myphpapp -o jsonpath="{.items[0].metadata.name}")
          state=$(kubectl get pods -l app=myphpapp -o jsonpath="{.items[0].status.phase}")
          
          sleep 20
                
	 kubectl cp /var/www/html  $php:/var/www/html
          
       fi
      
else 
       echo "respective resplicaset doesn't exists"
fi
