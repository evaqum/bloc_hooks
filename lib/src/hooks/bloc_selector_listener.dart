import 'package:bloc_hooks/src/hooks/bloc_listener.dart';
import 'package:bloc_hooks/src/hooks/bloc_selector.dart';
import 'package:bloc_hooks/src/utils/infer_bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void useBlocSelectorListener<B extends BlocBase<S>, S extends Object?, R>({
  required Selector<S, R> select,
  required Listener<R> listener,
  InferBlocTypeGetter<B>? inferBloc,
}) {
  useBlocListener<B, S>(
    (state) => listener(select(state)),
    listenWhen: (previous, current) {
      if (previous == null) return true;

      return !const DeepCollectionEquality().equals(
        select(previous),
        select(current),
      );
    },
  );
}
