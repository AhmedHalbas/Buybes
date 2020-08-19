import 'package:buybes/constants.dart';
import 'package:buybes/custom_widgets/custom_text_field.dart';
import 'package:buybes/custom_widgets/logo_and_name.dart';
import 'package:buybes/provider/admin_mode.dart';
import 'package:buybes/provider/modal_hud.dart';
import 'package:buybes/screens/admin/admin_screen.dart';
import 'package:buybes/screens/signup_screen.dart';
import 'package:buybes/screens/user/home_screen.dart';
import 'package:buybes/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final auth = Auth();

  String email, password;

  String adminPassword = 'admin123';

  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModalHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: <Widget>[
              LogoAndName(),
              SizedBox(
                height: height * 0.08,
              ),
              CustomTextField(
                hint: 'Enter Your Email',
                icon: Icons.email,
                onSaved: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: height * 0.03,
              ),
              CustomTextField(
                hint: 'Enter Your Password',
                icon: Icons.lock,
                onSaved: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Colors.white,
                    ),
                    child: Checkbox(
                      checkColor: kSecondaryColor,
                      activeColor: kMainColor,
                      value: isLoggedIn,
                      onChanged: (value) {
                        setState(() {
                          isLoggedIn = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Remember Me',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 125),
                child: Builder(
                  builder: (context) => FlatButton(
                    onPressed: () async {
                      if (isLoggedIn) {
                        keepUserLoggedIn();
                      }
                      _validate(context);
                    },
                    color: Colors.black,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Don\'t have an account? ',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignupScreen.id);
                    },
                    child: Text(
                      ' Sign Up',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'I\'m a User',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Switch(
                      value: Provider.of<AdminMode>(context, listen: false)
                          .isAdmin,
                      onChanged: (value) {
                        setState(() {
                          Provider.of<AdminMode>(context, listen: false)
                              .changeIsAdmin(value);
                        });
                      },
                      activeTrackColor: Colors.white,
                      activeColor: kMainColor,
                    ),
                    Text(
                      'I\'m an Admin',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validate(BuildContext context) async {
    final modalHud = Provider.of<ModalHud>(context, listen: false);
    modalHud.changeisLoading(true);
    if (_globalKey.currentState.validate()) {
      _globalKey.currentState.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (adminPassword == password) {
          try {
            await auth.SignIn(email, password);
            modalHud.changeisLoading(false);
            Navigator.pushNamed(context, AdminScreen.id);
          } catch (e) {
            modalHud.changeisLoading(false);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
              ),
            );
          }
        } else {
          modalHud.changeisLoading(false);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Admin Data is Wrong'),
            ),
          );
        }
      } else {
        try {
          await auth.SignIn(email, password);
          modalHud.changeisLoading(false);
          Navigator.pushNamed(context, HomeScreen.id);
        } catch (e) {
          modalHud.changeisLoading(false);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
            ),
          );
        }
      }
    }
    modalHud.changeisLoading(false);
  }

  void keepUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setBool(kKeepMeLoggedIn, isLoggedIn);
  }
}
