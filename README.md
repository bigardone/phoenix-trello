# Phoenix Trello
[![Build Status](https://travis-ci.org/bigardone/phoenix-trello.svg?branch=master)](https://travis-ci.org/bigardone/phoenix-trello)


[Trello](http://trello.com) tribute done with [Elixir](https://github.com/elixir-lang/elixir), [Phoenix Framework](https://github.com/phoenixframework/phoenix), [Webpack](https://github.com/webpack/webpack), [React](https://github.com/facebook/react) and [Redux](https://github.com/rackt/redux).

![`board`](http://codeloveandboards.com/images/blog/trello_tribute_pt_1/sign-in-a8fa19da.jpg)

## Requirements 
You need to have **Elxir v1.2** and **PostgreSQL** installed.

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
