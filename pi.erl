-module(pi).
-compile(export_all).

calculate_y(Y_prev) ->
    Y4 = math:pow(Y_prev, 4),
    V = math:pow(1 - Y4, 0.25),
    (1 - V) / (1 + V).

calculate_a(Y, A_prev, N) ->
    math:pow(1 + Y, 4) * A_prev - math:pow(2, 2*N + 1) * Y * (1 + Y + Y*Y).

get_y_and_a(A_prev, Y_prev, N) ->
    Y = calculate_y(Y_prev),
    {Y, calculate_a(Y, A_prev, N)}.

get_a_series(_, _, Max, Max, A_values) ->
    A_values;
get_a_series(Y, A, N, Max, A_values) ->
    {Y_new, A_new} = get_y_and_a(A, Y, N),
    get_a_series(Y_new, A_new, N + 1, Max, [A_new | A_values]).

start(Max) when Max > 0 ->
    A = 6 - 4 * math:sqrt(2),
    Y = math:sqrt(2) - 1,
    A_values = get_a_series(Y, A, 1, Max + 1, []),
    Pi_values = [1 / A || A <- lists:reverse(A_values)],
    Pi_values.
