import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc_hooks.dart';

typedef Listener<TBloc extends BlocBase<TState>, TState extends Object?> = void Function(TBloc bloc, TState state);

void useBlocListener<TBloc extends BlocBase<TState>, TState extends Object?>(
  Listener<TBloc, TState> listener, {
  BlocHookCondition<TState> ?listenWhen ,
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
