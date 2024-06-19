import 'errors.dart';

abstract class Result<F extends Object, S extends Object> {
  factory Result.failure(F f) => Failure(failure: f);

  factory Result.success(S s) => Success(success: s);

  bool get isSuccess;

  bool get isFailure;

  S get success;

  F get failure;
}

extension RM<F extends Object, S extends Object> on Result<F, S> {
  T map<T>({
    required T Function(S) onSuccess,
    required T Function(F) onFailure,
  }) {
    if (isSuccess) {
      return onSuccess(success);
    }
    return onFailure(failure);
  }

  void onResponse({
    required void Function(S) onSuccess,
    required void Function(F) onFailure,
  }) {
    if (isSuccess) {
      return onSuccess(success);
    }
    onFailure(failure);
  }
}

class Failure<F extends Object, S extends Object> implements Result<F, S> {
  final F _failure;

  Failure({required F failure}) : _failure = failure;

  @override
  bool get isSuccess => false;

  @override
  bool get isFailure => true;

  @override
  S get success => throw IllegalOperationException();

  @override
  F get failure => _failure;
}

class Success<F extends Object, S extends Object> implements Result<F, S> {
  final S _success;

  Success({required S success}) : _success = success;

  @override
  F get failure => throw IllegalOperationException();

  @override
  bool get isFailure => false;

  @override
  bool get isSuccess => true;

  @override
  S get success => _success;
}
