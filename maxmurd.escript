#!/usr/bin/env escript

%% -*- erlang -*-

main(_) ->
    {ok, Contents} = file:read_file("./README.md"),
    io:format("~ts", [Contents]),
    ok.
