%{
  configs: [
    %{
      name: "my-rules",
      requires: ["./lib/my_credo/checks/**/*.ex"],
      checks: [
        {MyCredo.Checks.MyFirstCredoCheck, []}
      ],
      files: %{
        included: ["mix.exs", "lib/", "src/", "web/", "apps/", "config/"],
        excluded: ["deps/", "_build/"]
      }
    }
  ]
}
