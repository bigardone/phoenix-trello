# Phoenix Trello
[![Build Status](https://travis-ci.org/bigardone/phoenix-trello.svg?branch=master)](https://travis-ci.org/bigardone/phoenix-trello)


[Trello](http://trello.com) tribute done with [Elixir](https://github.com/elixir-lang/elixir), [Phoenix Framework](https://github.com/phoenixframework/phoenix), [Webpack](https://github.com/webpack/webpack), [React](https://github.com/facebook/react) and [Redux](https://github.com/rackt/redux).

![`board`](http://codeloveandboards.com/images/blog/trello_tribute_pt_1/sign-in-a8fa19da.jpg)

## Tutorial
  1. [Intro and selected stack](http://codeloveandboards.com/blog/2016/01/04/trello-tribute-with-phoenix-and-react-pt-1/)
  2. [Phoenix Framework project setup](http://codeloveandboards.com/blog/2016/01/11/trello-tribute-with-phoenix-and-react-pt-2/)
  3. [The User model and JWT auth](http://codeloveandboards.com/blog/2016/01/12/trello-tribute-with-phoenix-and-react-pt-3/)
  4. [Front-end for sign up with React and Redux](http://codeloveandboards.com/blog/2016/01/14/trello-tribute-with-phoenix-and-react-pt-4/)
  5. [Database seeding and sign in controller](http://codeloveandboards.com/blog/2016/01/18/trello-tribute-with-phoenix-and-react-pt-5/)
  6. [Front-end authentication with React and Redux](http://codeloveandboards.com/blog/2016/01/20/trello-tribute-with-phoenix-and-react-pt-6/)
  7. [Setting up sockets and channels](http://codeloveandboards.com/blog/2016/01/25/trello-tribute-with-phoenix-and-react-pt-7/)
  8. [Listing and creating new boards](http://codeloveandboards.com/blog/2016/01/28/trello-tribute-with-phoenix-and-react-pt-8/)
  9. [Adding board members](http://codeloveandboards.com/blog/2016/02/04/trello-tribute-with-phoenix-and-react-pt-9/)
  10. [Tracking connected board members](http://codeloveandboards.com/blog/2016/02/15/trello-tribute-with-phoenix-and-react-pt-10/)
  11.  [Adding lists and cards](http://codeloveandboards.com/blog/2016/02/24/trello-tribute-with-phoenix-and-react-pt-11/)
  12.  [Deploying our application on Heroku](http://codeloveandboards.com/blog/2016/03/04/trello-tribute-with-phoenix-and-react-pt-12/)

## Live demo
https://phoenix-trello.herokuapp.com

## Requirements
You need to have **Elixir v1.2** and **PostgreSQL** installed.

## Installation instructions
To start your Phoenix Trello app:

  1. Install dependencies with `mix deps.get`
  2. Ensure webpack is installed. ie: `npm install -g webpack`
  3. Install npm packages with `npm install`
  4. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  5. Run seeds to create demo user with `mix run priv/repo/seeds.exs`
  6. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Enjoy!

## Testing
Integration tests with [Hound](https://github.com/HashNuke/hound) and [Selenium ChromeDriver](https://github.com/SeleniumHQ/selenium/wiki/ChromeDriver). Instructions:

  1. Install **ChromeDriver** with `npm install -g chromedriver`
  2. Run **ChromeDriver** in a new terminal window with `chromedriver`
  3. Run tests with `mix test`

If you don't want to run integration tests just run `mix test --exclude integration`.

## License

See [LICENSE](LICENSE).
