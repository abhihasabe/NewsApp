import 'package:firebaseLoginBloc/blocs/articalBloc/article_bloc.dart';
import 'package:firebaseLoginBloc/blocs/authBloc/authentication_bloc.dart';
import 'package:firebaseLoginBloc/blocs/loginBloc/login_bloc.dart';
import 'package:firebaseLoginBloc/blocs/regBloc/register_bloc.dart';
import 'package:firebaseLoginBloc/blocs/authBloc/authentication_event.dart';
import 'package:firebaseLoginBloc/screens/home_screen.dart';
import 'package:firebaseLoginBloc/screens/login_screen.dart';
import 'package:firebaseLoginBloc/screens/splash_screen.dart';
import 'package:firebaseLoginBloc/repositories/news_repository.dart';
import 'package:firebaseLoginBloc/repositories/user_repository.dart';
import 'package:firebaseLoginBloc/blocs/authBloc/authentication_state.dart';
import 'package:firebaseLoginBloc/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//In this lesson, we will build User Interface(UI)
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();
  final NewsArticleRepository _newsArticalRepository = NewsArticleRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyThemes.theme,
        debugShowCheckedModeBanner: false,
        title: 'Login with Firebase',
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthenticationBloc(userRepository: _userRepository)
                    ..add(AuthenticationEventStarted()),
            ),
            BlocProvider(
              create: (context) => LoginBloc(userRepository: _userRepository),
            ),
            BlocProvider(
              create: (context) => RegisterBloc(userRepository: _userRepository),
            ),
            BlocProvider(
              create: (context) => ArticleBloc(repository: _newsArticalRepository),
            ),
          ],
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, authenticationState) {
              if (authenticationState is AuthenticationStateSuccess) {
                return HomePage();
              } else if (authenticationState is AuthenticationStateFailure) {
                return BlocProvider<LoginBloc>(
                    create: (context) =>
                        LoginBloc(userRepository: _userRepository),
                    child: LoginPage(
                      userRepository: _userRepository,
                    ) //LoginPage,
                    );
              }
              return SplashPage();
            },
          ),
        ));
  }
}
