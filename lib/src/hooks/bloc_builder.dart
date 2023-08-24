import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'bloc.dart';

typedef BuildWhenCondition<S extends Object?> = bool Function(S? previous, S current);
bool alwaysBuildCondition(_, __) => true;

S useBlocBuilder<B extends BlocBase<S>, S extends Object?>({
  BuildWhenCondition<S> buildWhen = alwaysBuildCondition,
}) {
  final bloc = useBloc<B>();
  final previousStateRef = useRef<S?>(null);

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
