import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef BlocHookCondition<TState extends Object?> = bool Function(TState previous, TState current);

/// [useBloc] reads and returns [TBloc] provided in current [BuildContext].
///
/// Acts in the same way as `context.read<TBloc>()`, does not subscribe to state updates.
///
/// ```dart
/// final bloc = useBloc<CounterBloc>();
/// bloc.add(CounterEvent.increment);
/// ```
TBloc useBloc<TBloc extends BlocBase>() {
  return useContext().read();
}
