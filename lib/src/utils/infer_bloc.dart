import 'package:flutter_bloc/flutter_bloc.dart';

/// If you stumble upon this, use [inferBlocType]
typedef InferBlocTypeGetter<B extends BlocBase> = InferBlocType<B> Function();

/// If you stumble upon this, use [inferBlocType]
abstract class InferBlocType<B extends BlocBase> {
  const InferBlocType._();
}

class _InferB<B extends BlocBase> extends InferBlocType<B> {
  const _InferB() : super._();
}

InferBlocType<B> inferBlocType<B extends BlocBase>() {
  return _InferB<B>();
}
