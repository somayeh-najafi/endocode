pipeline{ 
        
         agent none
     
         stages{ 
                  stage ( 'build' )
                                   {
                                    agent{label 'docker'}      
                                    steps { 
                                           sh 'docker build -t custom_nginx .'
                                                   
                                          }
                                    }
              
                  stage ( 'deploy' )
                                    {
                                      agent{label 'docker'}
		   		      environment{IP_ADDRESS='192.168.178.73'}
                                      steps { 
                                             sh 'docker ps -f name=custom_nginx -q | xargs --no-run-if-empty docker container stop'
   					     sh 'docker container ls -a -f name=custom_nginx -q | xargs -r docker container rm '
					     sh 'docker run -itd -p 8080:80 custom_nginx:latest'
					     sh 'curl http://${IP_ADDRESS}:8080>${BUILD_NUMBER}_$(date +"%m_%d_%Y")_nginx.out'
				             archiveArtifacts artifacts: '*_nginx.out' , onlyIfSuccessful: true       

                                          
                                             }
                                     } 
                }

           post {
                  success { 
                            echo ' task successfully done!'
                          }
                  failure
                          {
                                 echo 'task failed!'
                          }

                 }
 
        }
