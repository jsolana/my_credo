defmodule DummyCredo.Checks.PatchDependencyVersionCredoCheckTest do
  use Credo.Test.Case

  @moduledoc false

  alias DummyCredo.Checks.PatchDependencyVersionCredoCheck

  describe "Check patch pinned versions" do
    test "It shoulds NOT report patch pinned version issues" do
      """
      defmodule MyProject.MixProject do
        use Mix.Project
        defp deps do
            [
              # Comments
              {:dependency_1, "~> 1.2"},
              {:dependency_2, ">= 1.2"},
              {:dependency_3, "<= 1.2"},
              {:dependency_4, "> 1.2"},
              {:dependency_5, "< 1.2"},
              {:dependency_6, "== 1.2"},
              {:dependency_7, "~> 1.2", only: [:dev, :test], runtime: false},
              {:dependency_8, "~> 1.2", organization: "organization"},
              {:dependency_9, git: "uri", tag: "v1.2.3"},
              {:dependency_10, git: "uri", branch: "master"},
              # local
              {:dependency_11, path: "path/to/local_dependency"},
              {:dependency_12, in_umbrella: true},
              {:dependency_13, ">= 1.2 and < 2.1"},
              {:dependency_14, ">= 1.2 or < 2.1"}
            ]
        end
      end

      """
      |> to_source_file("mix.exs")
      |> run_check(PatchDependencyVersionCredoCheck)
      |> refute_issues()
    end

    test "It shoulds report patch pinned version issues using ~>" do
      """
      defmodule MyProject.MixProject do
        use Mix.Project
        defp deps do
            [
              {:dependency, "~> 1.2.3"}
            ]
        end
      end

      """
      |> to_source_file("mix.exs")
      |> run_check(PatchDependencyVersionCredoCheck)
      |> assert_issue()
    end

    test "It shoulds report patch pinned version issues using ==" do
      """
      defmodule MyProject.MixProject do
        use Mix.Project
        defp deps do
            [
              {:dependency, "== 1.2.3"}
            ]
        end
      end

      """
      |> to_source_file("mix.exs")
      |> run_check(PatchDependencyVersionCredoCheck)
      |> assert_issue()
    end

    test "It shoulds report patch pinned version issues using <=" do
      """
      defmodule MyProject.MixProject do
        use Mix.Project
        defp deps do
            [
              {:dependency, "<= 1.2.3"}
            ]
        end
      end

      """
      |> to_source_file("mix.exs")
      |> run_check(PatchDependencyVersionCredoCheck)
      |> assert_issue()
    end

    test "It shoulds report patch pinned version issues using >=" do
      """
      defmodule MyProject.MixProject do
        use Mix.Project
        defp deps do
            [
              {:dependency, ">= 1.2.3"}
            ]
        end
      end

      """
      |> to_source_file("mix.exs")
      |> run_check(PatchDependencyVersionCredoCheck)
      |> assert_issue()
    end

    test "It shoulds report patch pinned version issues using >" do
      """
      defmodule MyProject.MixProject do
        use Mix.Project
        defp deps do
            [
              {:dependency, "> 1.2.3"}
            ]
        end
      end

      """
      |> to_source_file("mix.exs")
      |> run_check(PatchDependencyVersionCredoCheck)
      |> assert_issue()
    end

    test "It shoulds report patch pinned version issues using <" do
      """
      defmodule MyProject.MixProject do
        use Mix.Project
        defp deps do
            [
              {:dependency, "< 1.2.3"}
            ]
        end
      end

      """
      |> to_source_file("mix.exs")
      |> run_check(PatchDependencyVersionCredoCheck)
      |> assert_issue()
    end

    test "It shoulds report patch pinned version issues using and" do
      """
      defmodule MyProject.MixProject do
        use Mix.Project
        defp deps do
            [
              {:dependency, ">= 1.2.3 and < 3.2.1"}
            ]
        end
      end

      """
      |> to_source_file("mix.exs")
      |> run_check(PatchDependencyVersionCredoCheck)
      |> assert_issue()
    end

    test "It shoulds report patch pinned version issues using or" do
      """
      defmodule MyProject.MixProject do
        use Mix.Project
        defp deps do
            [
              {:dependency, ">= 1.2.3 or < 3.2.1"}
            ]
        end
      end

      """
      |> to_source_file("mix.exs")
      |> run_check(PatchDependencyVersionCredoCheck)
      |> assert_issue()
    end

    test "It shoulds report patch pinned version issues with organization options" do
      """
      defmodule MyProject.MixProject do
        use Mix.Project
        defp deps do
            [
              {:dependency, "~> 1.2.3", organization: "organization"}
            ]
        end
      end

      """
      |> to_source_file("mix.exs")
      |> run_check(PatchDependencyVersionCredoCheck)
      |> assert_issue()
    end

    test "It shoulds report patch pinned version issues using hex manager" do
      """
      defmodule MyProject.MixProject do
        use Mix.Project
        defp deps do
            [
              {:dependency, "== 1.2.3", hex: :hex_depenency, override: true}
            ]
        end
      end

      """
      |> to_source_file("mix.exs")
      |> run_check(PatchDependencyVersionCredoCheck)
      |> assert_issue()
    end

    test "It shoulds report patch pinned version issues with only and runtime options" do
      """
      defmodule MyProject.MixProject do
        use Mix.Project
        defp deps do
            [
              {:sobelow, "~> 1.2.3", only: [:dev, :test], runtime: false}
            ]
        end
      end

      """
      |> to_source_file("mix.exs")
      |> run_check(PatchDependencyVersionCredoCheck)
      |> assert_issue()
    end
  end
end
