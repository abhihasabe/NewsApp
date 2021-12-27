//the same with login_bloc
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebaseLoginBloc/blocs/regBloc/register_event.dart';
import 'package:firebaseLoginBloc/repositories/user_repository.dart';
import 'package:firebaseLoginBloc/blocs/regBloc/register_state.dart';
import 'package:firebaseLoginBloc/utils/validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RegisterState.initial());

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
      Stream<RegisterEvent> events,
      TransitionFunction<RegisterEvent, RegisterState> transitionFn) {
    final nonDebounceStream = events.where((event) {
      return (event is! RegisterEventNameChanged &&
          event is! RegisterEventEmailChanged &&
          event is! RegisterEventPasswordChanged &&
          event is! RegisterEventConfirmPasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is RegisterEventNameChanged ||
          event is RegisterEventEmailChanged ||
          event is RegisterEventPasswordChanged ||
          event is RegisterEventConfirmPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent registerEvent) async* {
    if (registerEvent is RegisterEventNameChanged) {
      if (Validators.isEmpty(registerEvent.name)) {
        yield state.cloneAndUpdate(isValidName: false);
      }
    }
    if (registerEvent is RegisterEventEmailChanged) {
      if (Validators.isEmpty(registerEvent.email) ||
          Validators.isValidEmail(registerEvent.email)) {
        yield state.cloneAndUpdate(isValidEmail: false);
      }
    } else if (registerEvent is RegisterEventPasswordChanged) {
      if (Validators.isEmpty(registerEvent.password) ||
          Validators.isValidPassword(registerEvent.password))
        yield state.cloneAndUpdate(isValidPassword: false);
    } else if (registerEvent is RegisterEventConfirmPasswordChanged) {
      if (Validators.isEmpty(registerEvent.confirmPassword)) {
        if (Validators.isPasswordMatch(
            registerEvent.password, registerEvent.confirmPassword)) {
          yield state.cloneAndUpdate(isValidConfirmPassword: false);
        }
      }
    } else if (registerEvent is RegisterEventPressed) {
      yield RegisterState.loading();
      try {
        await _userRepository.createUserWithEmailAndPassword(
          registerEvent.email,
          registerEvent.password,
        );
        yield RegisterState.success();
      } catch (exception) {
        yield RegisterState.failure();
      }
    }
  }
}
