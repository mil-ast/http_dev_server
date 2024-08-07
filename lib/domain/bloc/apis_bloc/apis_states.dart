part of 'apis_cubit.dart';

sealed class ApisState {
  final bool isBuild;
  const ApisState(this.isBuild);

  factory ApisState.ready() = ApisReadyState;
  factory ApisState.success(List<GroupApisModel> groups) = ApisSuccessState;
  factory ApisState.failure(Object err) => ApisErrorState(err.toString());
}

final class ApisReadyState extends ApisState {
  const ApisReadyState() : super(true);
}

final class ApisSuccessState extends ApisState {
  final List<GroupApisModel> groups;
  const ApisSuccessState(this.groups) : super(true);
}

final class ApisErrorState extends ApisState {
  final String message;
  const ApisErrorState(this.message) : super(false);
}
