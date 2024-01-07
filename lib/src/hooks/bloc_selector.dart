import 'package:bloc_hooks/bloc_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Selector<S extends Object?, R> = R Function(S state);

R useBlocSelector<B extends BlocBase<S>, S extends Object?, R>(
  Selector<S, R> select, {
  InferBlocTypeGetter<B>? inferBloc,
  BlocHookCondition<R> buildWhen = alwaysActCondition,
}) {
  final state = useBlocBuilder<B, S>(buildWhen: (previous, current) {
    if (previous == null) return true;

    final prev = select(previous);
    final curr = select(current);

    return prev != curr && buildWhen(prev, curr);
  });

  return select(state);
}
