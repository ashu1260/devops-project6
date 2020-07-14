job("job1-pullcode")
{
    description("This job will pull code from github")
    scm {
         github('ashu1260/task2', "master")
	}

   triggers{
         upstream("seed-job", 'SUCCESS')
          scm('@minute')
      
         }
    steps {
      
        shell('sudo cp * -f  /var/www/html')
     }
	
}


job("job2-create-rs")
{
    
   description("This job will create replicas according to code language")
   
    triggers {
         upstream("job1-pullcode", 'SUCCESS')
      
    }
   steps {
      
        shell(' sudo chmod +x /task6-setup.sh')
        shell( 'sudo sh /task6-setup.sh')
             
        
     }
	
    
}


job("job3-testing")
{
     description("This job will test your web-app")
   
    triggers {
         upstream("job2-create-rs", 'SUCCESS')
      
    }
   steps {
         shell(' sudo chmod +x /test.sh')
         shell( 'sudo sh /test.sh')
             
        
     }
	

}


job("job4-email-notify")
{
     description("This job will notify with email if something went wrong !")
   
    triggers {
         upstream("job3-testing", 'SUCCESS')
      
    }
  
  publishers {
        extendedEmail {
            recipientList('ashabulani@gmail.com')
            contentType('text/html')
            triggers {
               success{
                    subject('web-app Failed')
                    content('oops! something went wrong with your web-app.')
                    recipientList('ashabulani@gmail.com')
                    sendTo {
                        developers()
                        
                    }
                }
            }
        }
    }
  
  
  
  
  
        
}
