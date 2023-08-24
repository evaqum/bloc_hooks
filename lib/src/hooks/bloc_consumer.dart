import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc_hooks.dart';

S useBlocConsumer<B extends BlocBase<S>, S extends Object?>(
  Listener<S> listener, {
  BlocHookCondition<S> listenWhen = alwaysActCondition,
  BlocHookCondition<S> buildWhen = alwaysActCondition,
  InferBlocTypeGetter<B>? inferBloc,
}) {
  useBlocListener<B, S>(listener, listenWhen: listenWhen);
  return useBlocBuilder<B, S>(buildWhen: buildWhen);
}
