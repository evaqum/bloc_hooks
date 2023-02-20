import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'bloc.dart';

typedef Listener<B extends BlocBase<S>, S extends Object?> = void Function(B bloc, S state);

typedef ListenWhenCondition<S> = bool Function(S previous, S current);
bool alwaysListenCondition(_, __) => true;

void useBlocListener<B extends BlocBase<S>, S extends Object?>(
  Listener<B, S> listener, {
  ListenWhenCondition<S> listenWhen = alwaysListenCondition,
}) {
  final bloc = useBloc<B>();
  final previousStateRef = useRef<S?>(null);

  useEffect(() {
    final filteredStream = bloc.stream.where((current) {
      if (previousStateRef.value == null) {
        previousStateRef.value = current;
        return true;
      }

      if (listenWhen(previousStateRef.value as S, current)) {
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
