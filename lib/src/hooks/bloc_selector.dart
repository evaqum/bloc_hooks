import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_builder.dart';

typedef Selector<S extends Object?, R> = R Function(S state);

R useBlocSelector<B extends BlocBase<S>, S extends Object?, R>(Selector<S, R> select) {
  final state = useBlocBuilder<B, S>(buildWhen: (previous, current) {
    if (previous == null) return true;

    return !const DeepCollectionEquality().equals(
      select(previous),
      select(current),
    );
  });

  return select(state);
}
