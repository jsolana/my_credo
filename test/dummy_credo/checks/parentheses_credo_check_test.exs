defmodule DummyCredo.Checks.ParenthesesCredoCheckTest do
  use Credo.Test.Case

  @moduledoc false

  alias DummyCredo.Checks.ParenthesesCredoCheck

  describe "Parentheses with no arguments" do
    test "It should NOT report parentheses issues for public functions without arguments and without delimiters and comma format" do
      """
      defmodule MyModule do
        # without delimiters, comma format
        def sum, do: 0
      end
      """
      |> to_source_file()
      |> run_check(ParenthesesCredoCheck)
      |> refute_issues()
    end

    test "It should NOT report parentheses issues for public functions without arguments and without delimiters" do
      """
      defmodule MyModule do
        # without delimiters
        def sum do: 0
      end
      """
      |> to_source_file()
      |> run_check(ParenthesesCredoCheck)
      |> refute_issues()
    end

    test "It should NOT report parentheses issues for public functions without arguments using do block delimiters" do
      """
      defmodule MyModule do
        # do block delimiters
        def sum do
          0
        end
      end
      """
      |> to_source_file()
      |> run_check(ParenthesesCredoCheck)
      |> refute_issues()
    end

    test "It should NOT report parentheses issues for private functions without arguments without delimiters and comma format" do
      """
      defmodule MyModule do
        # do block delimiters
        def sum do
          do_sum()
        end
        # private function without delimiters
        defp do_sum, do: 0
      end
      """
      |> to_source_file()
      |> run_check(ParenthesesCredoCheck)
      |> refute_issues()
    end

    test "It should NOT report parentheses issues for private functions without arguments using do block delimiters" do
      """
      defmodule MyModule do
        # do block delimiters
        def sum do
          do_sum()
        end
        # private function do block delimiters
        defp do_sum do
          0
        end
      end
      """
      |> to_source_file()
      |> run_check(ParenthesesCredoCheck)
      |> refute_issues()
    end

    test "It should report parentheses issues for public functions without arguments without delimiters and comma format" do
      """
      defmodule MyModule do
        # without delimiters, comma format
        def sum(), do: 0
      end
      """
      |> to_source_file()
      |> run_check(ParenthesesCredoCheck)
      |> assert_issue()
    end

    test "It should report parentheses issues for public functions without arguments using do block delimiters" do
      """
      defmodule MyModule do
        # do block delimiters
        def sum() do
          0
        end
      end
      """
      |> to_source_file()
      |> run_check(ParenthesesCredoCheck)
      |> assert_issue()
    end

    test "It should report parentheses issues for private functions without arguments without delimiters" do
      """
      defmodule MyModule do
        # do block delimiters
        def sum do
          do_sum()
        end
        # private function without delimiters
        defp do_sum(), do: 0
      end
      """
      |> to_source_file()
      |> run_check(ParenthesesCredoCheck)
      |> assert_issue()
    end

    test "It should report parentheses issues for private functions without arguments using do block delimiters" do
      """
      defmodule MyModule do
        # do block delimiters
        def sum do
          do_sum()
        end
        # private function do block delimiters
        defp do_sum() do
          0
        end
      end
      """
      |> to_source_file()
      |> run_check(ParenthesesCredoCheck)
      |> assert_issue()
    end
  end
end
