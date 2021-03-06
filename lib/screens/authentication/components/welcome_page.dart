import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login_boilerplate/blocs/application/root_bloc.dart';
import 'package:flutter_firebase_login_boilerplate/blocs/application/root_events.dart';
import 'package:flutter_firebase_login_boilerplate/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_firebase_login_boilerplate/blocs/authentication/authentication_events.dart';
import 'package:flutter_firebase_login_boilerplate/blocs/authentication/authentication_states.dart';
import 'package:flutter_firebase_login_boilerplate/screens/authentication/components/email_verification_page.dart';
import 'package:flutter_firebase_login_boilerplate/screens/authentication/components/forgot_password_page.dart';
import 'package:flutter_firebase_login_boilerplate/screens/authentication/components/login_button.dart';
import 'package:flutter_firebase_login_boilerplate/screens/authentication/components/login_page.dart';
import 'package:flutter_firebase_login_boilerplate/screens/authentication/components/signup_button.dart';
import 'package:flutter_firebase_login_boilerplate/screens/authentication/components/signup_page.dart';
import 'package:flutter_firebase_login_boilerplate/screens/components/information/waiting_screen.dart';

/// [WelcomePage] entry point for login page's widgets
class WelcomePage extends StatelessWidget {

  const WelcomePage({Key key, this.userMustVerifyEmail = false}) : super(key: key);

  final bool userMustVerifyEmail;
  
  @override
  Widget build(BuildContext context) {
    final RootBloc rootBloc = BlocProvider.of<RootBloc>(context);
    if (userMustVerifyEmail) {
      BlocProvider.of<AuthenticationBloc>(context).add(GotToEmailVerification());
    }
    
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) {
        if (state is Failure) {
          rootBloc.add(ThrowError(icon: Icons.error, title: 'An error occured', message: state.error));
        }
        if (state is ResetPasswordEmailSent) {
          rootBloc.add(ThrowInformation(
            icon: Icons.notifications_active,
            title: 'Email sent',
            message: 'The reset email has been sent'
          ));
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState state) {
          if (state is Initial) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                    child: FlutterLogo(
                      size: MediaQuery.of(context).size.height*0.3,
                    )
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        LoginButton(),
                        SignupButton(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is Login) {
            return LoginPage(fromSignupPage: state.fromSignupPage,);
          } else if (state is Signup) {
            return SignupPage(fromLoginPage: state.fromLoginPage,);
          } else if (state is EmailNotVerified) {
            return EmailVerificationPage();
          } else if (state is ResetPassword) {
            return ForgotPasswordPage();
          } else {
            return WaitingScreen();
          }
        },
      ),
    );
  }
}