import 'package:bloc_hooks/bloc_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Selector<TBloc extends BlocBase<TState>, TState extends Object?, TResult> = TResult Function(TBloc bloc, TState state);

TResult useBlocSelector<TBloc extends BlocBase<TState>, TState extends Object?, TResult>(
  Selector<TBloc, TState, TResult> select, {
  BlocHookCondition<TResult>? buildWhen,
}) {
  final bloc = useBloc<TBloc>();

  final state = useBlocBuilder<TBloc, TState>(buildWhen: (previous, current) {
    if (previous == null) return true;

    final prev = select(bloc, previous);
    final curr = select(bloc, current);

    late final willBuild = buildWhen?.call(prev, curr) ?? true;
    return prev != curr && willBuild;
  });

  return select(bloc, state);
}
