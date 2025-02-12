import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc_hooks.dart';

/// [useBlocBuilder] returns current state of [TBloc] and subscribes to its updates.
///
/// It should be used to update the UI when state changes.
/// To **do** something in response to state changes, use [useBlocListener].
///
/// ```dart
/// Widget build(BuildContext context) {
///   final count = useBlocBuilder<CounterBloc, int>();
///   return Text('$count');
/// }
/// ```
///
/// By default, it will trigger on every state change. [buildWhen] allows to filter out changes
/// and prevent unnecessary rebuilds.
///
/// ```dart
/// Widget build(BuildContext context) {
///   final countOnlyUpTo10 = useBlocBuilder<CounterBloc, int>(
///     buildWhen: (previous, current) => current <= 10,
///   );
///   return Text('$countOnlyUpTo10'); // Will only count up to 10
/// }
/// ```
TState useBlocBuilder<TBloc extends BlocBase<TState>, TState extends Object?>({
  BlocHookCondition<TState>? buildWhen,
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
