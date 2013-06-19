[![Build Status](https://travis-ci.org/thoughtworks/billbo.png?branch=master)](https://travis-ci.org/thoughtworks/billbo)

Help an institution that helps other people. They got a lot of bills to pay and we got a lot of ideas to share.

## Setup local environment

 - <a href="http://redis.io/download" target="_blank">Redis</a> is required.

### To run locally for development

 - Start redis server `$ path/to/redis/src/redis-server`;
 - Run the application using shotgun `$ shotgun`;
 - Go to <a href="http://localhost:9393" target="_blank">localhost:9393</a>;

### If you want to deploy on the cloud

I'd recommend using <a href="http://appfog.com" target="_blank">Appfog</a>

 - Create an account on <a href="http://appfog.com" target="_blank">Appfog</a>;
 - Create a Sinatra project;
 - Once it's created, go to Add-ons page and install Redis-Cloud;
 - In the Services tab add a Redis service;
 - Go to your command line and login in your appfog account running `$ af login`;
 - Then run `$ af update [appname]`;
 - _If you're allowed to push to the original repository (thoughtworks/billbo), deployment will be automatic after each push and can be checked on <a href="http://billbo.aws.af.cm" target="_blank">billbo.aws.af.cm</a>;_

### Do you wanna help? 

 - Check out our <a href="https://trello.com/b/VMLleo9S" target="_blank">Trello board</a>;
