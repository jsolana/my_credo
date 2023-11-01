# my_credo

Hi!! :-)

This is an example about how to define custom rules to be applied when run `mix credo`.
More info [here](https://hexdocs.pm/credo/adding_checks.html).

## How to use it

```console
    mix credo --config-name my-rules
```

When use `my_rules` in a project:

```console
    mix credo --config-name my-rules --config-file ./deps/my_credo/config/.credo.exs
```

[Credo issue](https://github.com/rrrene/credo/issues/1083) to ask for another way to use `.credo.exs` files of a dependency.
