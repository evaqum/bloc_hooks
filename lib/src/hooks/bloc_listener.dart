import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'bloc.dart';

typedef Listener<S extends Object?> = void Function(S state);

typedef ListenWhenCondition<S> = bool Function(S? previous, S current);
bool alwaysListenCondition(_, __) => true;

void useBlocListener<B extends BlocBase<S>, S extends Object?>(
  Listener<S> listener, {
  ListenWhenCondition<S> listenWhen = alwaysListenCondition,
  List<Object?> keys = const [],
}) {
  final bloc = useBloc<B>();
  final previousStateRef = useRef<S?>(null);

  useEffect(() {
    final filteredStream = bloc.stream.where((current) {
      if (listenWhen(previousStateRef.value, current)) {
        previousStateRef.value = current;
        return true;
      }

      previousStateRef.value = current;
      return false;
    });
    final subscription = filteredStream.listen((current) => listener(current));
    return subscription.cancel;
  }, keys);
}
