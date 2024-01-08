# Bloc Hooks

Nothing much, just some simple [hooks](https://pub.dev/packages/flutter_hooks) which I use with [flutter_bloc](https://pub.dev/packages/flutter_bloc) package.

## Hooks

### useBloc

`useBloc` looks for a Bloc in your widget tree, similar to `context.read` (it is actually just `context.read` under the hood).

```dart
Widget build(BuildContext context) {
  final bloc = useBloc<CounterBloc>();
  
  return TextButton(
    onPressed: () => bloc.add(CounterEvent.increment),
    child: Text('Increment'),
  );
}
```

---

### useBlocBuilder

`useBlocBuilder` looks for a Bloc in your widget tree and rebuilds the widget when its state changes.
If your state is quite complex and you don't want to unnecesary rebuild your widget, consider [`useBlocSelector`](#useblocselector)

```dart
Widget build(BuildContext context) {
  final count = useBlocBuilder<CounterBloc, int>();
  
  return Text('$count');
}
```

You can pass `buildWhen` callback, which will decide if the widget needs to be rebuild based on the state.

```dart
Widget build(BuildContext context) {
  final count = useBlocBuilder<CounterBloc, int>(
    buildWhen: (previousCount, currentCount) => currentCount <= 10,
  );
  
  return Text('Will only count up to 10: $count');
}
```

---

### useBlocListener

`useBlocListener` looks for a Bloc in your widget tree and calls `listener` on every state update.

```dart
Widget build(BuildContext context) {
  useBlocListener<CounterBloc, int>((count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New counter value: $count')),
    );
  });
  
  return Text('Updated count will appear in a snackbar');
}
```

---

### useBlocConsumer

`useBlocConsumer` combines [`useBlocBuilder`](#useblocbuilder) and [`useBlocListener`](#usebloclistener). It allows you to both listen to state changes and update your UI.

```dart
Widget build(BuildContext context) {
  final count = useBlocConsumer<CounterBloc, int>((count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New counter value: $count')),
    );
  });
  
  return Text('Count: $count');
}
```

---

### useBlocSelector

`useBlocSelector` can be useful when you have a some complex state, but you only want your widget to rebuild when certain properties change.

```dart
Widget build(BuildContext context) {
  final (isAuthenticated, user) = useBlocSelector<AuthBloc, AuthState, (bool, User?)>(
    (state) => (state.isAuthenticated, state.user),
  );

  if (!isAuthenticated || user == null) {
    return LoginScreen();
  }

  return HomeScreen(user: user);
}
``` 
