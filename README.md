[![Build Status](https://travis-ci.org/thoughtworks/billbo.png?branch=master)](https://travis-ci.org/thoughtworks/billbo)

Help an institution that helps other people. They got a lot of bills to pay and we got a lot of ideas to share.

## Setup local environment

 - <a href="http://mongodb.org/" target="_blank">MongoDB</a> is required.

### To run locally for development

 - Start mongo server `$ path/to/mongo/mongod`;
 - Run the application using shotgun `$ shotgun`;
 - Go to <a href="http://localhost:9393" target="_blank">localhost:9393</a>;

### If you want to deploy on the cloud

I'd recommend using <a href="http://appfog.com" target="_blank">AppFog</a>

 - Create an account on <a href="http://appfog.com" target="_blank">AppFog</a>;
 - Install Appfog gem `af`;
 - Using your command line shell, go to directory where your forked billbo repository is;
 - Login in your Appfog account running `$ af login`;
 - Run `$ af push [appname] --runtime ruby193` and follow the instructions to create the app;
 - Once it's created, go to <a href="https://console.appfog.com" target="_blank">Appfog console</a> and install the MongoLab Add-on;
 - In the Services tab add a MongoDB service;
 - Then run `$ af update [appname]` and make sure your app restarted;
 - _If you're allowed to push to the original repository (thoughtworks/billbo), deployment will be automatic after each push and can be checked on <a href="http://billbo.aws.af.cm" target="_blank">billbo.aws.af.cm</a>;_

### Do you wanna help? 

 - Check out our <a href="https://trello.com/b/VMLleo9S/billbo" target="_blank">Trello board</a>;
