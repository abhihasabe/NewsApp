import 'package:firebaseLoginBloc/blocs/articalBloc/article_bloc.dart';
import 'package:firebaseLoginBloc/blocs/loginBloc/login_bloc.dart';
import 'package:firebaseLoginBloc/blocs/loginBloc/login_event.dart';
import 'package:firebaseLoginBloc/blocs/regBloc/register_bloc.dart';
import 'package:firebaseLoginBloc/blocs/regBloc/register_event.dart';
import 'package:firebaseLoginBloc/networks/internet_check.dart';
import 'package:firebaseLoginBloc/repositories/news_repository.dart';
import 'package:firebaseLoginBloc/screens/home_screen.dart';
import 'package:firebaseLoginBloc/screens/login_screen.dart';
import 'package:firebaseLoginBloc/repositories/user_repository.dart';
import 'package:firebaseLoginBloc/blocs/regBloc/register_state.dart';
import 'package:firebaseLoginBloc/theme/colors.dart';
import 'package:firebaseLoginBloc/utils/utils.dart';
import 'package:firebaseLoginBloc/widgets/button_widget.dart';
import 'package:firebaseLoginBloc/widgets/input_field_widget.dart';
import 'package:firebaseLoginBloc/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  final UserRepository _userRepository;

  RegisterPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  UserRepository get _userRepository => widget._userRepository;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _nameController.addListener(() {
      _registerBloc.add(RegisterEventNameChanged(name: _nameController.text));
    });
    _emailController.addListener(() {
      _registerBloc
          .add(RegisterEventEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener(() {
      _registerBloc.add(
          RegisterEventPasswordChanged(password: _passwordController.text));
    });
    _confirmPasswordController.addListener(() {
      _registerBloc.add(RegisterEventConfirmPasswordChanged(
          confirmPassword: _confirmPasswordController.text));
    });
  }

  bool get isPopulated =>
      _nameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return isPopulated && !state.isSubmitting;
  }

  final NewsArticleRepository _newsArticalRepository = NewsArticleRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, registerState) {
            if (registerState.isFailure) {
              print('Registration Failed');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Registration Failed"),
                ));
              });
            } else if (registerState.isSubmitting) {
              print('Registration in progress...');
              Utils.buildLoading();
            } else if (registerState.isSuccess) {
              print('Registration in');
              Utils.displaySnackBar("Registration Successfully");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        BlocProvider<ArticleBloc>(
                            create: (context) =>
                                ArticleBloc(repository: _newsArticalRepository),
                            child: HomePage()),
                  ),
                  (route) => false,
                );
              });
            }
            return Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTitleWidget(),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormFieldWidget(
                      hintText: "Name",
                      textCapitalization: TextCapitalization.sentences,
                      textInputType: TextInputType.text,
                      actionKeyboard: TextInputAction.next,
                      controller: _nameController,
                      prefixIcon: Icon(
                        Icons.person,
                        color: hoverColorDarkColor,
                      ),
                      onSubmitField: () {},
                      parametersValidate: "Please enter UserName.",
                    ),
                    SizedBox(height: 15),
                    TextFormFieldWidget(
                      hintText: "Email",
                      textCapitalization: TextCapitalization.sentences,
                      textInputType: TextInputType.text,
                      actionKeyboard: TextInputAction.next,
                      controller: _emailController,
                      prefixIcon: Icon(
                        Icons.email,
                        color: hoverColorDarkColor,
                      ),
                      onSubmitField: () {},
                      parametersValidate: "Please enter UserName.",
                    ),
                    SizedBox(height: 15),
                    TextFormFieldWidget(
                      hintText: "Password",
                      textCapitalization: TextCapitalization.sentences,
                      textInputType: TextInputType.text,
                      actionKeyboard: TextInputAction.next,
                      controller: _passwordController,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: hoverColorDarkColor,
                      ),
                      onSubmitField: () {},
                      parametersValidate: "Please enter Password.",
                    ),
                    SizedBox(height: 15),
                    TextFormFieldWidget(
                      hintText: "Confirm Password",
                      textCapitalization: TextCapitalization.sentences,
                      textInputType: TextInputType.text,
                      actionKeyboard: TextInputAction.done,
                      controller: _confirmPasswordController,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: hoverColorDarkColor,
                      ),
                      onSubmitField: () {},
                      parametersValidate: "Please enter Confirm Password.",
                    ),
                    SizedBox(height: 15),
                    CustomButton(
                        textColor: Colors.white,
                        minWidth: double.infinity,
                        text: "SIGN UP",
                        height: 50.0,
                        borderRadius: 5,
                        color: primaryColor,
                        splashColor: Colors.blue[200],
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1.2,
                        ),
                        onClick: isRegisterButtonEnabled(registerState)
                            ? () {
                                _onRegister(registerState);
                              }
                            : null),
                    SizedBox(
                      height: 10,
                    ),
                    _buildSignUpText()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildSignUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(
          text: "Already have an account?",
          small: true,
          color: buttonColor,
        ),
        SizedBox(width: 5),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return BlocProvider<LoginBloc>(
                    create: (context) =>
                        LoginBloc(userRepository: _userRepository),
                    child: LoginPage(userRepository: _userRepository));
              }),
            );
          },
          child: TextWidget(
            text: "SIGN IN",
            medium: true,
            bold: true,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  _buildTitleWidget() {
    return TextWidget(
      text: "SIGN UP",
      title: true,
      bold: true,
      color: buttonColor,
    );
  }

  void _onRegister(RegisterState registerState) {
    InternetCheck().check().then((intenet) {
      if (intenet != null && intenet) {
        if (_passwordController.text == _confirmPasswordController.text) {
          print("NameController ${registerState.isValidName}");
          print("EmailController ${registerState.isValidEmail}");
          print("PasswordController ${registerState.isValidPassword}");
          print("ConfirmPasswordController ${registerState.isValidConfirmPassword}");
          _registerBloc.add(
            RegisterEventPressed(
                name: _nameController.text,
                email: _emailController.text,
                password: _passwordController.text,
                confirmPassword: _confirmPasswordController.text),
          );
        } else {
          Utils.displayToast("Password Not Match");
        }
      } else {
        Utils.displayToast("Please check Internet Connection");
      }
    });
  }
}
