import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login_boilerplate/blocs/application/application_bloc.dart';
import 'package:flutter_firebase_login_boilerplate/blocs/application/application_states.dart';
import 'package:flutter_firebase_login_boilerplate/blocs/application/root_bloc.dart';
import 'package:flutter_firebase_login_boilerplate/blocs/application/root_states.dart';
import 'package:flutter_firebase_login_boilerplate/configuration/theme/custom_font_style.dart';
import 'package:flutter_firebase_login_boilerplate/configuration/theme/theme_notifier.dart';
import 'package:flutter_firebase_login_boilerplate/providers/repositories/shared_pref_calls.dart';
import 'package:flutter_firebase_login_boilerplate/screens/authentication/authentication.dart';
import 'package:flutter_firebase_login_boilerplate/screens/components/information/splash_screen.dart';
import 'package:flutter_firebase_login_boilerplate/screens/components/information/waiting_screen.dart';
import 'package:flutter_firebase_login_boilerplate/screens/home/home.dart';
import 'package:provider/provider.dart';

/// [Root] is the root page of Liyo app
class Root extends StatefulWidget {
  const Root({Key key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color _bottomButtonColor = Theme.of(context).buttonColor;

    return BlocListener<RootBloc, RootState>(
      listener: (BuildContext context, RootState state) {
        if (state is ErrorDisplay) {
          _throwError(context,
            title: state.title,
            message: state.message,
            icon: state.icon
          );
        } else if (state is DialogInformationDisplay) {
          _throwInformationDialog(context,
            title: state.title,
            widgets: state.widgets
          );
        } else if (state is DialogAlertDisplay) {
          _throwAlertDialog(context,
            title: state.title,
            content: state.content,
            actions: state.actions
          );
        } else if (state is InformationDisplay) {
          _throwInformation(context,
            title: state.title,
            message: state.message,
            icon: state.icon
          );
        } else if (state is ThemeTrigger) {
          _onThemeChanged(context);
        }
      },
      child: BlocListener<ApplicationBloc, ApplicationState>(
        listener: (BuildContext context, ApplicationState state) {
          if (state is UserUnauthenticated) {
            _setLightTheme(context);
          }
        },
        child: BlocBuilder<ApplicationBloc, ApplicationState>(
          builder: (BuildContext context, ApplicationState state) {
            if (state is UserAuthenticated) {
              return Scaffold(
                body: _buildPage(_currentIndex),
                bottomNavigationBar: BottomNavigationBar(
                  elevation: 5.0,
                  selectedFontSize: 12.0,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex,
                  onTap: _onTabTapped,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, color: _bottomButtonColor.withOpacity(0.5)),
                      activeIcon: Icon(Icons.home, color: _bottomButtonColor),
                      title: Text('Test', style: CustomFontStyle.commonTextStyle.copyWith(color: Colors.black),),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.group, color: _bottomButtonColor.withOpacity(0.5)),
                      activeIcon: Icon(Icons.group, color: _bottomButtonColor),
                      title: Text('Test', style: CustomFontStyle.commonTextStyle.copyWith(color: Colors.black),),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications, color: _bottomButtonColor.withOpacity(0.5)),
                      activeIcon: Icon(Icons.notifications, color: _bottomButtonColor),
                      title: Text('Test', style: CustomFontStyle.commonTextStyle.copyWith(color: Colors.black),),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.message, color: _bottomButtonColor.withOpacity(0.5)),
                      activeIcon: Icon(Icons.message, color: _bottomButtonColor),
                      title: Text('Test', style: CustomFontStyle.commonTextStyle.copyWith(color: Colors.black),),
                    )
                  ],
                ),
              );
            } else if (state is UserUnauthenticated) {
              return Authentication(userMustVerifyEmail: state.userMustVerifyEmail,);
            } else if (state is Loading) {
              return WaitingScreen();
            }
            return SplashScreen();
          },
        ),
      ),
    );
  }

  /// [_buildPage] builds the page according to the index it gets as entry
  ///
  /// @param int index : the index of the page to display
  ///
  /// @return Widget : the widget to display
  Widget _buildPage(int index) {
    Widget widgetToBuild;
    switch (index) {
      case 0:
        widgetToBuild = Home(index: index,);
        break;
      case 1:
        widgetToBuild = Home(index: index,);
        break;
      case 2:
        widgetToBuild = Home(index: index,);
        break;
      case 3:
        widgetToBuild = Home(index: index,);
        break;
      default:
        widgetToBuild = WaitingScreen();
    }
    return widgetToBuild;
  }

  /// [_throwAlertDialog] displays an alert dialog
  ///
  /// @param BuildContext : the current context
  /// @param String title : the title to display
  /// @param String content : the content to display
  /// @param List<Widget> actions : the content to display after the title and the content
  void _throwAlertDialog(BuildContext context, {String title, String content, List<Widget> actions}) {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(title,
            style: CustomFontStyle.secondTitleTextStyle.copyWith(
              color: Theme.of(context).textSelectionColor,
            ),
          ),
          content: Text(content,
            style: CustomFontStyle.subtitleTextStyle.copyWith(
              color: Theme.of(context).textSelectionColor,
            ),
          ),
          actions: actions,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 3.0,
        );
      },
    );
  }

  /// [_throwInformationDialog] displays a simple dialog with some informations
  /// 
  /// @param BuildContext : the current context
  /// @param String title : the title to display
  /// @param List<Widget> widgets : the content to display after the title
  void _throwInformationDialog(BuildContext context, {String title, List<Widget> widgets}) {
    showDialog<SimpleDialog>(
      context: context,
      builder: (BuildContext ctx) {
        return SimpleDialog(
          title: Text(title,
            style: CustomFontStyle.secondTitleTextStyle.copyWith(
              color: Theme.of(context).textSelectionColor,
            ),
          ),
          children: widgets,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 3.0,
        );
      }
    );
  }

  /// [_onThemeChanged] changes the theme of the application
  /// 
  /// @param BuildContext : the current context
  void _onThemeChanged(BuildContext context) {
    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    final bool isDarkMode = themeNotifier.isDarkMode();
    isDarkMode ? themeNotifier.setTheme(buildLightTheme()) : themeNotifier.setTheme(buildDarkTheme());
    SharedPrefCalls().setIsDarkMode(!isDarkMode);
  }

  /// [_setLightTheme] sets the theme to light, used on user's logout
  /// 
  /// @param BuildContext : the current context 
  void _setLightTheme(BuildContext context) {
    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    themeNotifier.setTheme(buildLightTheme());
    SharedPrefCalls().setIsDarkMode(false);
  }

  /// [_throwError] displays a snackbar at the bottom of the application in order to inform the user of an error
  /// 
  /// @param BuildContext context
  /// @param String title
  /// @param String message
  /// @param IconData icon
  void _throwError(BuildContext context, {String title, String message, IconData icon}) {
    Flushbar<Object>(
      title: title,
      message: message,
      backgroundColor: Theme.of(context).errorColor,
      icon: Icon(icon,
        size: 28,
        color: Theme.of(context).accentColor,
      ),
      duration: const Duration(seconds: 3),
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
      borderRadius: MediaQuery.of(context).size.height * 0.005,
    )..show(context);
  }

  /// [_throwInformation] displays a snackbar at the bottom of the application in order to inform the user of something
  /// 
  /// @param BuildContext context
  /// @param String title
  /// @param String message
  /// @param IconData icon
  void _throwInformation(BuildContext context, {String title, String message, IconData icon}) {
    Flushbar<Object>(
      title: title,
      message: message,
      backgroundColor: Theme.of(context).primaryColor,
      icon: Icon(icon,
        size: 28,
        color: Theme.of(context).accentColor,
      ),
      duration: const Duration(seconds: 3),
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
      borderRadius: MediaQuery.of(context).size.height * 0.005,
    )..show(context);
  }
}