import 'package:bloc_hooks/bloc_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Selector<TBloc extends BlocBase<TState>, TState extends Object?, TResult> = TResult Function(TBloc bloc, TState state);

/// [useBlocSelector] returns value selected based on the current state and subscribes to it updates.
/// Widget will be rebuilt when value returned by [select] differs from previous value.
///
/// ```dart
/// Widget build(BuildContext context) {
///   final countIsEven = useBlocSelector<CounterBloc, int>((_, count) => count.isEven);
///
///   return Text(countIsEven ? 'Even' : 'Odd');
/// }
/// ```
///
/// Use with records and pattern destructuring
/// to select multiple properties that you want to depend on in a complex state.
///
/// With large resulting record types I'd recommend to not pass generic types
/// to [useBlocSelector] and instead specify them in [select] function.
/// This will allow compiler to infer the result type.
///
/// ```dart
/// Widget build(BuildContext context) {
///   final (isAuthenticated, user) = useBlocSelector(
///     (AuthBloc _, AuthState state) => (state.isAuthenticated, state.user),
///   );
///
///   if (!isAuthenticated || user == null) {
///     return LoginScreen();
///   }
///
///   return HomeScreen(user: user);
/// }
/// ```
TResult useBlocSelector<TBloc extends BlocBase<TState>, TState extends Object?, TResult>(
  Selector<TBloc, TState, TResult> select, {
  BlocHookCondition<TResult>? buildWhen,
}) {
  final bloc = useBloc<TBloc>();

  final state = useBlocBuilder<TBloc, TState>(buildWhen: (previous, current) {
    if (previous == null) return true;

    final prev = select(bloc, previous);
    final curr = select(bloc, current);

    late final willBuild = buildWhen?.call(prev, curr) ?? true;
    return prev != curr && willBuild;
  });

  return select(bloc, state);
}
