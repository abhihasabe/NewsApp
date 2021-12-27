import 'package:firebaseLoginBloc/blocs/articalBloc/article_bloc.dart';
import 'package:firebaseLoginBloc/blocs/loginBloc/login_bloc.dart';
import 'package:firebaseLoginBloc/blocs/regBloc/register_bloc.dart';
import 'package:firebaseLoginBloc/blocs/loginBloc/login_event.dart';
import 'package:firebaseLoginBloc/networks/internet_check.dart';
import 'package:firebaseLoginBloc/screens/home_screen.dart';
import 'package:firebaseLoginBloc/screens/register_screen.dart';
import 'package:firebaseLoginBloc/repositories/news_repository.dart';
import 'package:firebaseLoginBloc/repositories/user_repository.dart';
import 'package:firebaseLoginBloc/blocs/loginBloc/login_state.dart';
import 'package:firebaseLoginBloc/theme/colors.dart';
import 'package:firebaseLoginBloc/utils/utils.dart';
import 'package:firebaseLoginBloc/widgets/button_widget.dart';
import 'package:firebaseLoginBloc/widgets/input_field_widget.dart';
import 'package:firebaseLoginBloc/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class LoginPage extends StatefulWidget {
  final UserRepository _userRepository;

  //constructor
  LoginPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwodController = TextEditingController();
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(() {
      _loginBloc.add(LoginEventEmailChanged(email: _emailController.text));
    });
    _passwodController.addListener(() {
      _loginBloc
          .add(LoginEventPasswordChanged(password: _passwodController.text));
    });
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwodController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState loginState) =>
      loginState.isValidEmailAndPassword & isPopulated &&
      !loginState.isSubmitting;

  final NewsArticleRepository _newsArticalRepository = NewsArticleRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, loginState) {
          if (loginState.isFailure) {
            print('Logging failed');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Login Failed"),
              ));
            });
          } else if (loginState.isSubmitting) {
            print('Logging in progress...');
            Utils.buildLoading();
          } else if (loginState.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Utils.dismissProgressBar(context);
            });
            print('Logging in');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Login Successfully"),
              ));
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider<ArticleBloc>(
                      create: (context) =>
                          ArticleBloc(repository: _newsArticalRepository),
                      child: HomePage()),
                ),
                (route) => false,
              );
            });
          }
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTitleWidget(),
                  SizedBox(height: 40),
                  TextFormFieldWidget(
                    hintText: "UserName",
                    textCapitalization: TextCapitalization.sentences,
                    textInputType: TextInputType.text,
                    actionKeyboard: TextInputAction.next,
                    controller: _emailController,
                    prefixIcon: Icon(
                      Icons.person,
                      color: hoverColorDarkColor,
                    ),
                    onSubmitField: () {},
                    parametersValidate: "Please enter UserName.",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormFieldWidget(
                    hintText: "Password",
                    textCapitalization: TextCapitalization.sentences,
                    textInputType: TextInputType.text,
                    actionKeyboard: TextInputAction.done,
                    controller: _passwodController,
                    obscureText: true,
                    maxLine: 1,
                    sufixIcon:
                        Icon(Icons.visibility, color: hoverColorDarkColor),
                    prefixIcon: Icon(Icons.lock, color: hoverColorDarkColor),
                    onSubmitField: () {},
                    parametersValidate: "Please enter Password.",
                  ),
                  SizedBox(height: 15),
                  CustomButton(
                      textColor: Colors.white,
                      minWidth: double.infinity,
                      text: "SIGN IN",
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
                      onClick: isLoginButtonEnabled(loginState)
                          ? (){_onLoginEmailAndPassword(loginState);}
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
    );
  }

  _buildSignUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(
          text: "Does not have an account?",
          small: true,
          color: buttonColor,
        ),
        const SizedBox(width: 5),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return BlocProvider<RegisterBloc>(
                    create: (context) =>
                        RegisterBloc(userRepository: _userRepository),
                    child: RegisterPage(userRepository: _userRepository));
              }),
            );
          },
          child: TextWidget(
            text: "SIGN UP",
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
      text: "LOGIN",
      title: true,
      bold: true,
      color: buttonColor,
    );
  }

  void _onLoginEmailAndPassword(LoginState loginState) {
    InternetCheck().check().then((intenet) {
      if (intenet != null && intenet) {
        _loginBloc.add(LoginEventWithEmailAndPasswordPressed(
            email: _emailController.text, password: _passwodController.text));
      } else {
        Utils.displayToast("Please check Internet Connection");
      }
    });
    //Failed because user does not exist
  }
}
