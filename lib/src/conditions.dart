typedef BlocHookCondition<S extends Object?> = bool Function(S previous, S current);
bool alwaysActCondition(_, __) => true;
