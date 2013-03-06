[![Build Status](https://travis-ci.org/thoughtworks/billbo.png?branch=master)](https://travis-ci.org/thoughtworks/billbo)

Help an institution that helps other people. They got a lot of bills to pay and we got a lot of ideas to share.

## Setup local environment

 - [Redis](http://redis.io/download) is required.

### To run locally for development

 - Start redis server `$ path/to/redis/src/redis-server`;
 - Run the application using shotgun `$ shotgun`;
 - Go to [localhost:9393](http://localhost:9393);

### If you want to deploy on the cloud

I'd recommend using [Appfog](http://appfog.com)

 - Create an account on [Appfog](http://appfog.com);
 - Create a Sinatra project;
 - Once it's created, go to Add-ons page and install Redis-Cloud;
 - In the Services tab add a Redis service;
 - Go to your command line and login in your appfog account running `$ af login`;
 - Then run `$ af update [appname]`;
 - Every time you want to push changes to your appfog app just run `$ af update [appname]` again;
