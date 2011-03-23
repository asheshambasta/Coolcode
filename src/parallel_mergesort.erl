-module(parallel_mergesort).
-compile(export_all).

mergesort(List) ->
    PID = self(),
    spawn(fun() ->
                  mergesort(PID, List)
          end),
    receive
        Final ->
            io:format("~p~n", [Final])
    end.

mergesort(Targetpid, List) ->
    Mid = length(List) div 2,
    case Mid of
        0 ->
            Targetpid ! List;
        _ ->
            PID = self(),
            {First_half, Second_half} =
                lists:split(Mid, List),
            Rec = spawn(fun() ->
                                receive_halves(PID, 0, 2, [])
                        end),
            spawn(fun() ->
                          mergesort(Rec, First_half)
                  end),
            spawn(fun() ->
                          mergesort(Rec, Second_half)
                  end),
            receive
                Mergedlist ->
                    Targetpid ! Mergedlist
            end
    end.

receive_halves(Targetpid, Maxcount, Maxcount, Acc) ->
    Targetpid ! merge([], Acc);
receive_halves(Targetpid, Count, Maxcount, Acc) ->
    receive
        Half ->
            receive_halves(Targetpid, Count + 1, Maxcount, [Half | Acc])
    end.

merge([], [H | T]) ->
    merge(H, T);
merge(Mergedlist, []) ->
    Mergedlist;
merge(First, [Second | T]) ->
    Newfirst = compare_and_merge(First, Second, []),
    merge(Newfirst, T).

compare_and_merge([], S, Acc) ->
    Newacc = lists:append(lists:reverse(S), Acc),
    lists:reverse(Newacc);
compare_and_merge(F, [], Acc) ->
    Newacc = lists:append(lists:reverse(F), Acc),
    lists:reverse(Newacc);
compare_and_merge([Fh | Ft], [Sh | St], Acc) ->
    case Fh < Sh of
        true ->
            compare_and_merge(Ft, [Sh | St], [Fh | Acc]);
        false ->
            compare_and_merge([Fh | Ft], St, [Sh | Acc])
    end.
