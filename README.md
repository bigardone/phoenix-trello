# Phoenix Trello

[![bitHound Overall Score](https://www.bithound.io/github/bigardone/phoenix-trello/badges/score.svg)](https://www.bithound.io/github/bigardone/phoenix-trello)
[![bitHound Dependencies](https://www.bithound.io/github/bigardone/phoenix-trello/badges/dependencies.svg)](https://www.bithound.io/github/bigardone/phoenix-trello/master/dependencies/npm)
[![bitHound Dev Dependencies](https://www.bithound.io/github/bigardone/phoenix-trello/badges/devDependencies.svg)](https://www.bithound.io/github/bigardone/phoenix-trello/master/dependencies/npm)
[![bitHound Code](https://www.bithound.io/github/bigardone/phoenix-trello/badges/code.svg)](https://www.bithound.io/github/bigardone/phoenix-trello)

[Trello](http://trello.com) tribute done with **Elixir**, **Phoenix Framework**, **Webpack**, **React** and **Redux**.

![`board`](http://codeloveandboards.com/images/blog/trello_tribute_pt_1/sign-in-a8fa19da.jpg)

To start your Phoenix Trello app:

  1. Install dependencies with `mix deps.get`
  2. Install npm packages with `npm install`
  3. Create a ```config/dev.secret.exs``` file with the content described below.
  4. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  5. Run seeds to create demo user with `mix run priv/repo/seeds.exs`
  6. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### dev.secret.exs
This file contains any sensible data for your development environment:

```elixir
use Mix.Config

config :guardian, Guardian,
  secret_key: "YOUR_SECRET_KEY"
```

To generete the secret key just run the following:

```mix phoenix.gen.secret````


