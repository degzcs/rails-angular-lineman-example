TRAZORO
====

This is the repository for Trazoro web app. In this repository you will find both the backend (API in rails) and frontend (AngularJS). The main objective of this app is trace the colombian gold and to verify that it is legal. This app don't try to legalize the gold, it is only a way to manage the gold documentation and to know where it come from and every person who interacts in this process.

## Dependencies

- rails 4.1.9
- ruby 2.3.1
- nodejs 5.7.1
- bower
- [linemanjs] (http://linemanjs.com)
- phantomjs 1.9.8
- image-magic 6.9.0
- Ghostscript
- Redis 3.2.6

NOTE: We used to use rbenv, nodenv and phantomenv to install dependencies.
NOTE: It is recommended to use `zsh` shell with `oh-my-zshell` plugin to this enviroment, it is very useful and handy.

## Phantonjs 1.9.8

We are using the phantonjs 1.9.8 version because it library from version 2.0.0 onwards
does not support upload files with capybara.

## Development

Once you have installed all dependecies you have to run the rails server to run the back-end and lineman for the front-end.

## Back-end

Go to folder project and install dependencies, as follows:

```sh
cd path/to/project/trazoro-web
bundle install
```

### Setup

You have to copy&paste the next cofiguration files and replace their values for the correct ones.

```sh
cp config/database.yml.example config/database.yml
cp config/app_config.yml.example config/app_config.yml
cp config/rucom_service.yml.example config/rucom_service.yml

```

Create the database and run the seeds

```sh
rake db:create
CREATE_LOCATIONS=yes rake db:setup

# Standard Seed
CREATE_LOCATIONS=yes rake db:seed

# Tax Module seed
rake db:seed:tax_module
```

NOTE: The `CREATE_LOCATIONS` variable is only necessary the first time that is run these tasks.

### Background Jobs
These jobs are handled by Sidekiq, that is why you have to preinstall redis. After that, you have to run the next command in order to exec those processes that are not in the main thread, like pdf generation.

```sh
bundle exec rerun --background --dir app,db,lib --pattern '{**/*.rb}' -- bundle exec sidekiq --verbose
```

## Front-end

Go to frontend folder and install node dependencies and run lineman command, as follows:

```sh
 cd path/project/trazoro-web/frontend/
 npm install
 bower install
 lineman run
```

then copy&paste the basic config, as follows:

```sh
cp frontend/config/application.coffee.example frontend/config/application.coffee
```
NOTE: if you add a new library to use in the frontend make sure to update `/frontend/config/files.js` file with the correct path of the new library
## Tests

Prepare test environment, as follows:

```sh
RAILS_ENV=test CREATE_LOCATIONS=yes rake db:setup
```

and then run

```sh
rspec spec
```

## Deploy

```sh
cap production deploy
```

## Issues

We have some problems with Selenium Webdriver and VCR, this problemas were re the dynamic port that it is using with phantomjs. So, to fix it we make a mokey patch for test environment, please check this file for more information `service/support/helper/phantomjs_fix_for_test.rb`

##Issues (Mac OSX 10.11.3)

To fix the next issues related with rmagick

```sh
checking for Magick-config... no
...
Cannot install natives libraries 'rmagick', it needs the dependence gem 'imagemagic' -v '(version)'
...
```
I have to install the gem imagemagic first:

```sh
gem install imagemagic -v '(version)'
```

## Issues (Ubuntu 16.04)

To fix the next issues related with rmagick

```sh
checking for Magick-config... no
...
No package 'MagickCore' found
...
```

I have to install this libraries first:

```sh
sudo apt-get install libmagickwand-dev imagemagick
```

To fix this issue related with capybara

```sh
```

I have to install qt and its dependencies

```sh
sudo apt-get install qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
```

## Contributors

- Diego Gomez
- Santiago Lopez
