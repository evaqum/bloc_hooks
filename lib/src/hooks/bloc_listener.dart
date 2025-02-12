import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc_hooks.dart';

typedef Listener<TBloc extends BlocBase<TState>, TState extends Object?> = void Function(TBloc bloc, TState state);

/// [useBlocListener] subscribes to updates of [TBloc] state and passes it to [listener].
///
/// It should be used to do something when state changes (e.g. show a dialog, navigate to other page).
/// To update the UI when state changes, use [useBlocBuilder].
///
/// ```dart
/// Widget build(BuildContext context) {
///   useBlocListener<CounterBloc, int>((_, count) {
///     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$count')));
///   });
///
///   return Text('Updated count will show up in the snackbar');
/// }
/// ```
void useBlocListener<TBloc extends BlocBase<TState>, TState extends Object?>(
  Listener<TBloc, TState> listener, {
  BlocHookCondition<TState>? listenWhen,
}) {
  final bloc = useBloc<TBloc>();
  final currentState = bloc.state;
  final previousStateRef = useRef<TState>(currentState);

  useEffect(() {
    final filteredStream = bloc.stream.where((current) {
      if (listenWhen?.call(previousStateRef.value, current) ?? true) {
        previousStateRef.value = current;
        return true;
      }

      previousStateRef.value = current;
      return false;
    });
    final subscription = filteredStream.listen((current) => listener(bloc, current));
    return subscription.cancel;
  }, []);
}
