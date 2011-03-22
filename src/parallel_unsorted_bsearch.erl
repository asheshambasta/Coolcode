-module(parallel_unsorted_bsearch).
-compile(export_all).

receive_position(Maxcount, Maxcount) ->
    io:format("Element not present", []);
receive_position(Count, Maxcount) ->
    receive
        {found, Pos} ->
            io:format("Element found at: ~p~n", [Pos]);
        -1 -> receive_position(Count + 1, Maxcount)
    end.

compare_mid([], Receiver_PID, _, _) ->
    Receiver_PID ! -1;
compare_mid(List, Receiver_PID, Elem, Weighted_position) ->
    Len = length(List),
    Midpoint = Len div 2,
    case Midpoint of
        0 ->
            [Val] = List,
            case Elem =:= Val of
                true ->
                    Receiver_PID ! {found, Weighted_position + Midpoint + 1};
                false ->
                    Receiver_PID ! -1
            end;
        _ ->
            case Elem =:= lists:nth(Midpoint, List) of
                true ->
                    Receiver_PID ! {found, Weighted_position + Midpoint};
                false ->
                    {First_half, Second_half} = 
                        lists:split(Midpoint, List),
                    spawn(fun() ->
                                  compare_mid(First_half, Receiver_PID, Elem, Weighted_position)
                          end),
                    spawn(fun() ->
                                  compare_mid(Second_half, Receiver_PID, Elem, Weighted_position + Midpoint)
                          end)
            end
    end.
