import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_examen/globals/globals.dart' as g;
import 'package:test_examen/components/drawer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_examen/model/user_info_details.dart';
import 'package:test_examen/pages/login_signup_page.dart';
import 'package:test_examen/pages/root_page.dart';
import 'package:test_examen/services/authentication.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    //_tabController = new TabController(length: 5, vsync: this);

    if (g.userInfoDetails != null) {
      print('userInfoDetails.email:' + g.userInfoDetails.email);
    } else {
      _checkEmailVerification();

      widget.auth.getCurrentUser().then((user) {
        setState(() {
          if (user != null) {
            g.userInfoDetails = new UserInfoDetails(user?.providerId,
                user?.displayName, user?.email, user?.photoUrl, user?.uid);
          }
        });
      });
    }
  }

  void _checkEmailVerification() async {
    g.isEmailVerified = await widget.auth.isEmailVerified();
    if (!g.isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _signOut() async {
    //Navigator.of(context).pop();
    try {
      //await widget.auth.signOut();
      await widget.auth.signOut();
      await widget.auth.signOutGoogle();
      //await widget.auth.disconnect();
      widget.onSignedOut();

      return new RootPage(auth: new Auth());
    } catch (e) {
      print(e);
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero', //TODO:
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/test-exam.png'),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(g.APPBAR_MENU_PRINCIPAL),
        /*actions: <Widget>[
          IconButton(
              //icon: Icon((Icons.power_settings_new)), onPressed: () => widget.auth.disconnect()),
              icon: Icon((Icons.power_settings_new)),
              onPressed: _signOut),
        ],*/
      ),
      drawer: new MyDrawer(
          auth: widget.auth,
          userId: widget.userId,
          onSignedOut: widget.onSignedOut),
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(children: <Widget>[
                _showLogo(),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                    child: new Center(
                        child: Text(
                            "Bienvenido: " + g.userInfoDetails.displayName,
                            style: new TextStyle(fontSize: 22.0)))),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
