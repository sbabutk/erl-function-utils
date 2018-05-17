%%------------------------------------------------------------------------------
%% @author kuba.odias
%% @copyright relayr 2009-2018
%% @doc Miscellaneous utilities for Erlang functions processing.
%% @end
%%------------------------------------------------------------------------------
-module(function_utils).

%%------------------------------------------------------------------------------
%% Include files
%%------------------------------------------------------------------------------

%%------------------------------------------------------------------------------
%% Function exports
%%------------------------------------------------------------------------------
-export([
    apply/1,
    when_exported/4
]).

%%------------------------------------------------------------------------------
%% Types
%%------------------------------------------------------------------------------
-type provider(T) :: fun(() -> T).
-type provider() :: provider(any()).

-type consumer(In, Out) :: fun((In) -> Out).
-type consumer(In) :: consumer(In, any()).
-type consumer() :: consumer(any()).

-type callback() :: callback(any()).
-type callback(T) ::
    mfa()
    | {fun(), Args :: list()}
    | provider(T).

-export_type([
    provider/1,
    provider/0,

    consumer/2,
    consumer/1,
    consumer/0,

    callback/0,
    callback/1
]).

%% =============================================================================
%% Exported functions
%% =============================================================================
-spec apply(F :: callback()) -> any().
apply({M, F, A}) ->
    erlang:apply(M, F, A);
apply({F, A}) when is_function(F) ->
    erlang:apply(F, A);
apply(F) when is_function(F) ->
    erlang:apply(F, []).

-spec when_exported(M :: module(), F :: atom(), A :: list(), Otherwise :: provider()) -> any().
when_exported(M, F, A, Otherwise) ->
    when_exported_do(M, F, A, fun(R) -> R end, Otherwise).

%% =============================================================================
%% Local functions
%% =============================================================================
-spec when_exported_do(M :: module(), F :: atom(), A :: list(), Do :: consumer(), Otherwise :: provider()) -> any().
when_exported_do(M, F, A, Do, Otherwise) ->
    case erlang:function_exported(M, F, length(A)) of
        false ->
            apply(Otherwise);
        true ->
            Res = erlang:apply(M, F, A),
            apply(Do, [Res])
    end.