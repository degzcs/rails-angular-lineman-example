TRAZORO
====

This is the repository for Trazoro web app. In this repository you will find both the backend (API in rails) and frontend (AngularJS). The main objective of this app is trace the colombian gold and to verify that it is legal. This app don't try to legalize the gold, it is only a way to manage the gold documentation and know where come from it and know every person who interact with it in the buy/sale process in Colombia.

## Dependencies

- rails 4.1.9
- ruby 2.3.0
- nodejs 5.7.1
- [linemanjs] (http://linemanjs.com)
- phantomjs 2.0
- image-magic 6.9.0

NOTE: We used to use rbenv, nodenv and phantomenv to install dependencies.

## Development

Once you have installed all dependecies you have to run the rails server to run the back-end and lineman for the fron-end.
NOTE: It is recommended to use zsh with oh-my-zshell to this enviroment, because it is very useful.

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

```
Create the database and run the seeds

```sh
rake db:create
rake db:setup
```

## Front-end

Go to frontend folder and install node dependencies and run lineman command, as follows:

```sh
 cd path/project/trazoro-web/frontend/
 npm install
 lineman run
```

## Tests

## Deploy

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
