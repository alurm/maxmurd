#!/usr/bin/env elixir

{:ok, contents} = File.read("./README.md")
:ok = IO.write(contents)
