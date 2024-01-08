import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc_hooks.dart';

TState useBlocBuilder<TBloc extends BlocBase<TState>, TState extends Object?>({
  BlocHookCondition<TState> ?buildWhen ,
}) {
  final bloc = useBloc<TBloc>();
  final currentState = bloc.state;
  final previousStateRef = useRef<TState>(currentState);

  final stateStream = bloc.stream.where((current) {
    if (buildWhen?.call(previousStateRef.value, current) ?? true) {
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
