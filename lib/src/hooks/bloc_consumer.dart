import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_builder.dart';
import 'bloc_listener.dart';

S useBlocConsumer<B extends BlocBase<S>, S extends Object?>(
  Listener<S> listener, {
  ListenWhenCondition<S> listenWhen = alwaysListenCondition,
  BuildWhenCondition<S> buildWhen = alwaysBuildCondition,
}) {
  useBlocListener<B, S>(listener, listenWhen: listenWhen);
  return useBlocBuilder<B, S>(buildWhen: buildWhen);
}
