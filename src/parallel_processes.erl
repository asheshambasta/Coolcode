-module(parallel_processes).
-compile(export_all).

start(N) ->
    PID_List = spawn_processes(0, N, []),
    lists:foreach(fun(X) ->
                          X ! {not_done, PID_List}
                  end,
                  PID_List).

spawn_processes(Max, Max, PID_list) ->
    PID_list;
spawn_processes(N, Max, PID_list) ->
    PID = spawn(fun() ->
                        wait_and_communicate(Max)
                end),
    spawn_processes(N + 1, Max, [PID | PID_list]).

wait_and_communicate(N) ->
    receive
        {not_done, PID_list} ->
            io:format("Received communicate signal ~p~n", [self()])
    end,
    lists:foreach(fun(X) ->
                          X ! {done, self()}
                  end,
                  PID_list),
    communicate(N - 1).

communicate(0) ->
    void;
communicate(N) ->
    PID_self = self(),
    receive
        {done, PID_self} ->
            communicate(N);
        {done, PID} ->
            io:format("Received done signal from ~p~n", [PID]),
            communicate(N - 1)
    end.
