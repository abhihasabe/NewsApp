//do the same as "Login Event"
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
//Now we define BloC
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterEventNameChanged extends RegisterEvent {
  final String name;
  const RegisterEventNameChanged({@required this.name});
  @override
  List<Object> get props => [name];
  @override
  String toString() => 'RegisterEventEmailChanged, email :$name';
}

class RegisterEventEmailChanged extends RegisterEvent {
  final String email;
  const RegisterEventEmailChanged({@required this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() => 'RegisterEventEmailChanged, email :$email';
}

class RegisterEventPasswordChanged extends RegisterEvent {
  final String password;
  const RegisterEventPasswordChanged({@required this.password});
  @override
  List<Object> get props => [password];
  @override
  String toString() => 'RegisterEventPasswordChanged, password: $password';
}

class RegisterEventConfirmPasswordChanged extends RegisterEvent {
  final String password, confirmPassword;
  const RegisterEventConfirmPasswordChanged({@required this.password, @required this.confirmPassword});
  @override
  List<Object> get props => [password,confirmPassword];
  @override
  String toString() => 'RegisterEventPasswordChanged, password: $password, $confirmPassword';
}

class RegisterEventPressed extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterEventPressed({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.confirmPassword,
  });

  @override
  List<Object> get props => [name, email, password, confirmPassword];

  @override
  String toString() {
    return 'RegisterEventPressed, name: $name, email: $email, password: $password, confirmPassword: $confirmPassword';
  }
}
