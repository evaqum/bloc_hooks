import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'bloc.dart';

typedef BuildWhenCondition<B, S> = bool Function(S previous, S current, B bloc);
bool alwaysBuildCondition(_, __, ___) => true;

S useBlocBuilder<B extends BlocBase<S>, S extends Object?>({
  BuildWhenCondition<B, S> buildWhen = alwaysBuildCondition,
}) {
  final bloc = useBloc<B>();
  final previousStateRef = useRef<S?>(null);

  final stateStream = bloc.stream.where((current) {
    if (previousStateRef.value == null) {
      previousStateRef.value = current;
      return true;
    }

    if (buildWhen(previousStateRef.value as S, current, bloc)) {
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
