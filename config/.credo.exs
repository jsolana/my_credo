%{
  configs: [
    %{
      name: "my-rules",
      requires: ["./lib/cabify_credo/checks/**/*.ex"],
      checks: [
        {MyCredo.Checks.MyFirstCredoCheck, []}
      ],
      included: ["lib/", "src/", "web/", "apps/"],
      excluded: []
    }
  ]
}
