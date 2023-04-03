# Bale Server

Server for Bale. Written in Elixir using [Phoenix][].

[Phoenix]: https://www.phoenixframework.org/

## Quick Start

```sh
mix deps.get
mix ecto.setup
mix phx.server
```

## Roadmap

Phase 1 is to just build out a basic REST API that gets the job done. Not doing
anything fancy, this feels like a waste of writing an app in Elixir. Really I
just want to get this out and working. BUT: The potential long term future would
be for this app to run fully on sockets and use the actual cool Elixir/Phoenix
stuff that makes this easy.

To that end, while the backend is not written *currently* in this form, the
frontends can hopefully be built using abstractions that make it easy to switch
over. The only true goal is to not build this into a corner it can't get out of.
