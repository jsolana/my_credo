# Dummy Credo

**Dummy Credo** is an elixir library based on `credo` and its ability to create [custom checks](https://hexdocs.pm/credo/adding_checks.html) where a custom set of rules to be applied throughout Dummy's Elixir-based project are defined.

This is the place where the static code analysis magic for Elixir happens ;-).

## How to use it

Include `dummy_credo` as a dependency of your project:

```elixir
{:dummy_credo, "~> 0.1.0", only: [:dev, :test], runtime: false}
```

To run credo using `Dummy-rules` in your project:

```console
mix credo --config-name Dummy-rules --config-file ./deps/Dummy_credo/config/.credo.exs
```

Or add an alias to simplify your life (on your local machine or CI/CD pipelines):

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
        "credo --config-name Dummy-rules --config-file ./deps/Dummy_credo/config/.credo.exs"
      ]
    ]
  end
```

## Adding Dummy Credo to your Gitlab CI

Assumming you already created the alias defined in the previous section, adding Dummy credo to Gitlab CI is as easy as adding the following config to `.gitlab-ci.yml`:

```yaml
credo:mix:
  stage: test
  script:
    - mix credo --strict
```
In the case you want to add it to an existing project, chances are there are too many errors and you can't handle all in one MR. One option could be add a job that runs just for the merge request and that checks just the diff between master and the merge requests, for example:

```yaml
credo:diff:mix:
  variables:
    GIT_DEPTH: 1000
  script:
    - git fetch origin ${CI_DEFAULT_BRANCH}
    - TARGET_SHA1=$(git show-ref -s ${CI_DEFAULT_BRANCH} | head -n 1)
    - mix credo diff --from-git-merge-base $TARGET_SHA1 --strict
  only:
    - merge_requests
```

This way you can ensure that every merge request will meet the rules and the base code will improve overtime.

## Development

You can compile and build the project running:

```bash
mix do deps.get, deps.compile, compile
```

To run unit tests:

```bash
mix test
```

More information [here](https://hexdocs.pm/credo/testing_checks.html)

To check `Dummy-rules` application over its own code, you can run:

```console
mix credo --config-name Dummy-rules
```

## Next steps

- [ ] Adopt a style guide as [this one](https://github.com/christopheradams/elixir_style_guide) and start implementing custom checks!
