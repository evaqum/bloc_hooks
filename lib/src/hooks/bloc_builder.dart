import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc_hooks.dart';

S useBlocBuilder<B extends BlocBase<S>, S extends Object?>({
  BlocHookCondition<S> buildWhen = alwaysActCondition,
  InferBlocTypeGetter<B>? inferBloc,
}) {
  final bloc = useBloc<B>();
  final currentState = bloc.state;
  final previousStateRef = useRef<S>(currentState);

  final stateStream = bloc.stream.where((current) {
    if (buildWhen(previousStateRef.value, current)) {
      previousStateRef.value = current;
      return true;
    }

    previousStateRef.value = current;
    return false;
  });

  return useStream(
    stateStream,
    initialData: bloc.state,
  ).requireData!;
}
