import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef BlocHookCondition<TState extends Object?> = bool Function(TState previous, TState current);

TBloc useBloc<TBloc extends BlocBase>() {
  return useContext().read();
}
