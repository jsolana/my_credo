# my_credo

Hi!! :-)

This is an example about how to define custom rules to be applied when run `mix credo`.
More info [here](https://hexdocs.pm/credo/adding_checks.html).

## How to use it

Include `my_credo` as a dependency of your project:

```elixir
    {:my_credo, github: "jsolana/my_credo", tag: "v0.0.1", only: [:dev, :test], runtime: false}
```

Run credo using `my_rules` in a project:

```console
    mix credo --config-name my-rules --config-file ./deps/my_credo/config/.credo.exs
```

Or add an alias:

```elixir
def project do
    [
      ...
      aliases: aliases()
    ]
  end

# run mix credo
defp aliases do
    [
      credo: [
        "credo --config-name my-rules --config-file ./deps/my_credo/config/.credo.exs"
      ]
    ]
  end
```

## How to test it

```console
    mix credo --config-name my-rules
```
