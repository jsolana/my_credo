defmodule DummyCredo.Checks.ParenthesesCredoCheck do
  @moduledoc """
  Omit parentheses when a function has no arguments.
  Reference: https://github.com/christopheradams/elixir_style_guide#fun-def-parentheses
  """
  use Credo.Check,
    base_priority: :normal,
    category: :readability,
    param_defaults: [],
    explanations: [
      check: """
      Omit parentheses when a function has no arguments.

          # not preferred
          def some_function() do
            # body omitted
          end

          # preferred
          def some_function do
            # body omitted
          end

      Like all `Readability` issues, this one is not a technical concern.
      But you can improve the odds of others reading and liking your code by making
      it easier to follow.
      """,
      params: []
    ]

  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)
    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  @function_definition_word [:def, :defp]
  # omit parentheses without arguments
  defp traverse({word, _, [{name, meta, []} | _]} = ast, issues, issue_meta)
       when word in @function_definition_word and is_atom(name) do
    {ast, issues ++ [issue_for(name, meta[:line], issue_meta)]}
  end

  defp traverse(ast, issues, _issue_meta) do
    {ast, issues}
  end

  def issue_for(trigger, line_no, issue_meta) do
    format_issue(
      issue_meta,
      message: "Omit parentheses when a function has no arguments.",
      trigger: trigger,
      line_no: line_no
    )
  end
end
