import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_builder.dart';
import 'bloc_listener.dart';

S useBlocConsumer<B extends BlocBase<S>, S extends Object?>(
  Listener<B, S> listener, {
  ListenWhenCondition<S> listenWhen = alwaysListenCondition,
  BuildWhenCondition<B, S> buildWhen = alwaysBuildCondition,
}) {
  useBlocListener(listener, listenWhen: listenWhen);
  return useBlocBuilder(buildWhen: buildWhen);
}
