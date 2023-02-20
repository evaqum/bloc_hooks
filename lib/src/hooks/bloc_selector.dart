import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'bloc_builder.dart';

typedef Selector<B extends BlocBase<S>, S extends Object?, R> = R Function(S state, B bloc);

R useBlocSelector<B extends BlocBase<S>, S extends Object?, R>(Selector<B, S, R> selector) {
  final S state = useBlocBuilder(buildWhen: (S previous, S current, B bloc) {
    return !const DeepCollectionEquality().equals(
      selector(previous, bloc),
      selector(current, bloc),
    );
  });

  return selector(state, useBloc());
}
