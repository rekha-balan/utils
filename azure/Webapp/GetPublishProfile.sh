az webapp deployment list-publishing-profiles -n WEBAPPNAME -g RGNAME --query '[].{username:userName,pwd:userPWD,host:publishUrl,url:destinationAppUrl} | [1]' -o table
