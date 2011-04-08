-module(kaprekar_constant).
-compile(export_all).

start(Number) ->
    Digits = get_digits(Number),
    case check_number(Digits) of 
        true ->
            recursively_iterate(Digits, 0);
        false ->
            io:format("You probably don't want to wait that long.~n", [])
    end.

check_number([H | T]) ->
    New_list = [X || X <- T,
                     X =:= H],
    length(New_list) /= length(T).

get_digits(Number) ->
    get_digits(Number, []).

get_digits(0, Digits) ->
    Digits;
get_digits(Number, Digits) ->
    get_digits(Number div 10, [Number rem 10 | Digits]).

recursively_iterate([6, 1, 7, 4], N) ->
    N;
recursively_iterate(Digits, N) ->
    Ascending = lists:sort(Digits),
    Descending = lists:reverse(Ascending),
    New_number = get_number(Descending) - get_number(Ascending),
    recursively_iterate(get_digits(New_number), N + 1).

get_number(Digits) ->
    get_number(Digits, 0).

get_number([], Number) ->
    Number;
get_number([Digit | Digits], Num) ->
    get_number(Digits, Num * 10 + Digit).
