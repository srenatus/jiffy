-module(jiffy_fuzzing_tests).


-include_lib("eunit/include/eunit.hrl").
-include("jiffy_util.hrl").


radamsa_test_() ->
    FuzzedSamples = read_fuzzed_samples(),
    [input(Input) || Input <- FuzzedSamples].

%% We don't expect most of these to be decodable, but we want to catch jiffy
%% exploding!
input(Input) ->
    {Input, fun() ->
                try
                  {ok, Bin} = file:read_file(Input),
                  jiffy:decode(Bin)
                catch
                  throw:{error, _} -> ignored
                end
            end}.

read_fuzzed_samples() ->
    CasesPath = "/tmp/fuzzed/*", %% out of that dir so rebar won't copy it
    lists:sort(filelib:wildcard(CasesPath)).
