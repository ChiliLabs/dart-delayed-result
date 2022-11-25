The `DelayedResult` is a helper class to implement segmented state pattern (idle, loading, error, success) without boilerplate code.

## Usage

Add the `DelayedResult` dependency to your project:

```
  delayed_result:
    git:
      url: https://github.com/ChiliLabs/dart-delayed-result.git
      ref: main
```

You can use it in any suitable way, for example as field in a `flutter_bloc` BLoC state:

```
class HomeState {
	final DelayedResult<DashboardData> dashboardResult;
	final DelayedResult<bool> saveResult;
}
```

And then in your BLoC in an event mapper:

```
  void _onGreetingRequested(
    GreetingRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state.greetingResult.isInProgress) return;
    emit(
      state.copyWith(
        greetingResult: const DelayedResult.inProgress(),
      ),
    );
    try {
      final greeting = await _homeRepository.greet(state.name);
      emit(
        state.copyWith(
          greetingResult: DelayedResult.fromValue(greeting),
        ),
      );
    } on Exception catch (ex) {
      emit(
        state.copyWith(
          greetingResult: DelayedResult.fromError(ex),
        ),
      );
    }
  }
}
```


And in your widget `build` method:

```
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final result = state.greetingResult;
          final isProgress = result.isInProgress;
          if (isProgress) {
            return const _GreetingStatus(
              status: 'Requesting greeting...',
              child: CircularProgressIndicator(),
            );
          }

          final error =
              result.isError ? _mapExceptionToError(result.error) : null;

          final isError = error != null;
          if (isError) {
            return _GreetingStatus(
              status: error,
              child: ElevatedButton(
                onPressed: _requestGreeting,
                child: const Text('Retry'),
              ),
            );
          }

          final isNone = result.isNone;
          final value = result.value;

          if (isNone || value == null) {
            return _GreetingStatus(
              status: 'No greeting yet',
              child: ElevatedButton(
                onPressed: _requestGreeting,
                child: const Text('Request greeting'),
              ),
            );
          }

          return _GreetingStatus(
            status: value,
            child: ElevatedButton(
              onPressed: _requestGreeting,
              child: const Text('Request another greeting'),
            ),
          );
        },
      ),
    );
  }
```  

## Additional information

You can find a full tutorial here: [TODO: add link]
