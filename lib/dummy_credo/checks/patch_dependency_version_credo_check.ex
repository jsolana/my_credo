defmodule DummyCredo.Checks.PatchDependencyVersionCredoCheck do
  @moduledoc ~S"""
  It will analyze your Elixir `mix.exs` codebase, and if it finds dependencies with pinned patch versions,
  it will issue a warning, suggesting that you consider using minor versions for greater flexibility.

  According to Mix documentation, dependencies must be specified in the `mix.exs` file in one of the following formats:

    {app, requirement}
    {app, opts}
    {app, requirement, opts}

  Where:

    - app is an atom
    - requirement is a Version requirement or a regular expression
    - opts is a keyword list of options

  For example:

    {:dependency_1, ">= 1.2.3"}
    {:dependency_2, git: "uri", tag: "1.2"}
    {:local_dependency, path: "path/to/local_dependency"}
    {:my_app, in_umbrella: true}

  """
  use Credo.Check,
    base_priority: :normal,
    category: :warning,
    param_defaults: [],
    explanations: [
      check: """
      Avoid patch versions as dependencies in `mix.exs` files.
      When specifying dependencies in Elixir, it's generally not recommended to pin specific patch versions.
      Instead, we advise you to pin minor versions to avoid:

      - Pinning specific patch versions might limit your project's ability to benefit from these fixes.
      By pinning a minor version, you still get bug fixes without the risk of major interface changes.

      - Pinning patch versions can potentially expose your project to unresolved security issues.

      - Pinning patch versions may lead to compatibility issues with other libraries and projects

      - Pinning minor versions allows some flexibility to receive patch updates and bug fixes without worrying about major library changes

            # not preferred
            defp deps do
              [
                {:dependency, "~> X.Y.Z"}
              ]
            end

            # preferred
            defp deps do
              [
                {:dependency, "~> X.Y"}
              ]
            end

        In summary, it's recommended to pin minor versions instead of patch versions.
        This practice strikes a balance between stability and the ability to keep your dependencies up-to-date and secure.
      """,
      params: []
    ]

  def run(%SourceFile{filename: filename} = source_file, params \\ []) do
    case filename do
      "mix.exs" ->
        {_, deps_block} =
          source_file |> Credo.Code.ast() |> Macro.prewalk([], &extract_deps_block/2)

        issue_meta = IssueMeta.for(source_file, params)
        Credo.Code.prewalk(deps_block, &traverse(&1, &2, issue_meta))

      _ ->
        []
    end
  end

  defp extract_deps_block({:defp, _, [{:deps, _, _}, [do: block]]} = ast, _) do
    {ast, block}
  end

  defp extract_deps_block(ast, acc) do
    {ast, acc}
  end

  @ignored [:tag, :branch]
  # {name, "version"} format
  # Ignoring warning for specific tag / branch used
  defp traverse({name, version} = dependency_ast, issues, issue_meta)
       when is_atom(name) and name not in @ignored and is_binary(version),
       do: do_traverse(dependency_ast, issues, issue_meta, name, version)

  # {:{}, meta, [name, "version", [options]]} format
  defp traverse({:{}, _, [name, version, _options]} = dependency_ast, issues, issue_meta)
       when is_atom(name) and is_binary(version),
       do: do_traverse(dependency_ast, issues, issue_meta, name, version)

  defp traverse(ast, issues, _issue_meta) do
    {ast, issues}
  end

  @patch_version_regex ~r/\d+\.\d+\.\d/
  defp do_traverse(dependency_ast, issues, issue_meta, name, version) do
    if Regex.match?(@patch_version_regex, version) do
      {dependency_ast, issues ++ [issue_for(name, version, issue_meta)]}
    else
      {dependency_ast, issues}
    end
  end

  @extract_patch_version_regex ~r/(\d+\.\d+\.\d+)(?:-\w+)?/
  @extract_minor_version_regex ~r/(\d+\.\d+)/
  def issue_for(dependency_name, version, issue_meta) do
    [[patch_version | _] | _] = Regex.scan(@extract_patch_version_regex, version)

    [[minor_suggested_version | _] | _] = Regex.scan(@extract_minor_version_regex, version)

    format_issue(
      issue_meta,
      message:
        "`#{dependency_name}` dependency is currently pinned to #{patch_version} patch version.\n" <>
          "To ensure the stability, security, and compatibility of your project, consider changing the pin to its minor version, #{minor_suggested_version}, instead.",
      trigger: dependency_name
    )
  end
end
