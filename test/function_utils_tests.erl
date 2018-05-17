%%------------------------------------------------------------------------------
%% @author kuba.odias
%% @copyright relayr 2009-2018
%%------------------------------------------------------------------------------
-module(function_utils_tests).

%%------------------------------------------------------------------------------
%% Include files
%%------------------------------------------------------------------------------

-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

%% =============================================================================
%% Unit tests
%% =============================================================================
when_exported_test() ->
    Provider = fun() -> unknown end,
    ?assertEqual([a, b, c], function_utils:when_exported(lists, append, [[a], [b, c]], Provider)),
    ?assertEqual(unknown, function_utils:when_exported(lists, append, [[a], [b], [c]], Provider)).

-endif.
