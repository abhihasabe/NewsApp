import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool isValidName;
  final bool isValidEmail;
  final bool isValidPassword;
  final bool isValidConfirmPassword;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isValidEmailAndPassword =>
      isValidName && isValidEmail && isValidPassword; //how to validate ?

  RegisterState({
    @required this.isValidName,
    @required this.isValidEmail,
    @required this.isValidPassword,
    @required this.isValidConfirmPassword,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory RegisterState.initial() {
    return RegisterState(
      isValidName: true,
      isValidEmail: true,
      isValidPassword: true,
      isValidConfirmPassword: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isValidName: true,
      isValidEmail: true,
      isValidPassword: true,
      isValidConfirmPassword: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      isValidName: true,
      isValidEmail: true,
      isValidPassword: true,
      isValidConfirmPassword: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      isValidName: true,
      isValidEmail: true,
      isValidPassword: true,
      isValidConfirmPassword: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  RegisterState cloneAndUpdate({
    bool isValidName,
    bool isValidEmail,
    bool isValidPassword,
    bool isValidConfirmPassword,
  }) {
    return copyWith(
      isValidName: isValidName,
      isValidEmail: isValidEmail,
      isValidPassword: isValidPassword,
      isValidConfirmPassword: isValidConfirmPassword,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  RegisterState copyWith({
    bool isValidName,
    bool isValidEmail,
    bool isValidPassword,
    bool isValidConfirmPassword,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return RegisterState(
      isValidName: isValidName ?? this.isValidName,
      isValidEmail: isValidEmail ?? this.isValidEmail,
      isValidPassword: isValidPassword ?? this.isValidPassword,
      isValidConfirmPassword:
          isValidConfirmPassword ?? this.isValidConfirmPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      isValidName: $isValidName,
      isValidEmail: $isValidEmail,
      isValidPassword: $isValidPassword,      
      isValidConfirmPassword: $isValidConfirmPassword,      
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
