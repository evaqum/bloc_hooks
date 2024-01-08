import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc_hooks.dart';

/// [useBlocConsumer] combines a [useBlocListener] and [useBlocBuilder] into one hook.
///
/// It subscribes to updates of [TBloc] state, calls [listener] and returns the state,
/// allowing to update the UI in response to changes.
TState useBlocConsumer<TBloc extends BlocBase<TState>, TState extends Object?>(
  Listener<TBloc, TState> listener, {
  BlocHookCondition<TState> ?listenWhen ,
  BlocHookCondition<TState> ?buildWhen,
}) {
  final bloc = useBloc<TBloc>();

  return useBlocBuilder<TBloc, TState>(
    buildWhen: (previous, current) {
      if (listenWhen?.call(previous, current) ?? true) {
        listener(bloc, current);
      }

      return buildWhen?.call(previous, current) ?? true;
    },
  );
}
