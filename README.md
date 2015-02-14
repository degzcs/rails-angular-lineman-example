Configure Rails and Angular using Lineman
====

This is one example of how to integrate rails and angular using linemanjs, and deploy it to Heroku. You can reproduce this example following the next steps

## Development environment:

create rails app:
```sh
$ rails new rails-angular-lineman-example --database=postgresq
```
**NOTE:** to more information about how you can getting started with rails 4 on heroku [here](https://devcenter.heroku.com/articles/getting-started-with-rails4)

Add angular from lineman angular template inside of your rails project
```sh
$ git clone https://github.com/linemanjs/lineman-angular-template.git frontend
$ cd frontend
$ npm install -g lineman
$ npm install
```
Setup your client-side to use api proxing feature, go to `frontend/config/application.js` as follows:
```js
//...
server: {
      pushState: false,
      apiProxy: {
        enabled: true,
        host: 'localhost',
        port: 3000,
      }
    }
//...
```
Comment the `frontend/config/server.js` and add login and logout routes in the rails application

**NOTE:** To disable HTML mode go to `frontend/app/js/router.js` and put enabled to false or comment it.
 ```js
 //...
 $locationProvider.html5Mode({enabled:false});
 //...
 ```
**NOTE:** See more about html5Mode [here]().

update `app/routes.rb`
```ruby
Rails.application.routes.draw do

  post 'login' => 'application#login'
  post 'logout' => 'application#login'
end
```
Add the next actions to `app/controllers/application_controller.rb`
```ruby
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  skip_before_action :verify_authenticity_token
  def login
    render json: { message: 'logging in!' }
  end
  def logout
    render json:{ message: 'logging out!'}
  end
end
```
Now start lineman:
```sh
$ lineman run
```
start rails server:
```sh
$ bundle exec rake db:migrate
$ bundle exec rails server
```
And go to [localhost:8000](http://localhost:8000)

[image]

pretty easy! right?

## Deployment

### Heroku:

Install rails-lineman from our repository (version 0.3.1). Add in your Gemfile:
```ruby
gem 'rails-lineman', github: 'degzcs/rails-lineman'
```
And then
```sh
$ bundle install
```

Setup rails-lineman gem in `config/application.rb` file, as follows:
````ruby
# Integrate with lineman
config.rails_lineman.lineman_project_location = "frontend"
config.rails_lineman.deployment_method = :copy_files_to_public_folder
````
make your commits and push to Heroku. And Voilá!

You can check this app on heroku [here](https://rails-angular-lineman-example.herokuapp.com):

[images]

and that is all!

I hope this little modification to rails-lineman gem help you to your development. See you around!








