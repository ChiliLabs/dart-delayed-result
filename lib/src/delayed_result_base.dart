import 'package:equatable/equatable.dart';

const _placeholder = Object();

class DelayedResult<T> extends Equatable {
  final T? value;
  final Exception? error;
  final bool isInProgress;

  const DelayedResult.fromError(Exception e)
      : value = null,
        error = e,
        isInProgress = false;

  const DelayedResult.fromValue(T result)
      : value = result,
        error = null,
        isInProgress = false;

  const DelayedResult.inProgress()
      : value = null,
        error = null,
        isInProgress = true;

  const DelayedResult.none()
      : value = null,
        error = null,
        isInProgress = false;

  static DelayedResult<dynamic> success() =>
      const DelayedResult.fromValue(_placeholder);

  DelayedResult<R> map<R>(R Function(T val) f) {
    final v = value;
    final e = error;
    if (v != null) {
      return DelayedResult<R>.fromValue(f(v));
    } else if (e != null) {
      return DelayedResult<R>.fromError(e);
    } else if (isNone) {
      return const DelayedResult.none();
    }

    return DelayedResult<R>.inProgress();
  }

  bool get isSuccessful => value != null;

  bool get isError => error != null;

  bool get isNone => value == null && error == null && !isInProgress;

  @override
  List<Object?> get props => [value, error, isInProgress];
}
