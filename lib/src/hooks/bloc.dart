import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

B useBloc<B extends BlocBase>() {
  return useContext().read();
}
