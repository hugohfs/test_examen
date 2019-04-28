import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_examen/globals/globals.dart' as g;
import 'package:test_examen/components/drawer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'package:test_examen/services/authentication.dart';

/*class UserDetails {
  final String providerId;

  final String uid;

  final String displayName;

  final String photoUrl;

  final String email;

  final bool isAnonymous;

  final bool isEmailVerified;

  final List<UserInfoDetails> providerData;

  UserDetails(this.providerId, this.uid, this.displayName, this.photoUrl,
      this.email, this.isAnonymous, this.isEmailVerified, this.providerData);
}

class UserInfoDetails {
  UserInfoDetails(
      this.providerId, this.displayName, this.email, this.photoUrl, this.uid);

  /// The provider identifier.
  final String providerId;

  /// The provider’s user ID for the user.
  final String uid;

  /// The name of the user.
  final String displayName;

  /// The URL of the user’s profile photo.
  final String photoUrl;

  /// The user’s email address.
  final String email;
}*/

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

  GoogleSignIn _googleAuth = new GoogleSignIn();

  /*final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final GoogleSignIn _gSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn(BuildContext context) async {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Sign in button clicked'),
    ));

    GoogleSignInAccount googleSignInAccount = await _gSignIn.signIn();
    GoogleSignInAuthentication authentication =
    await googleSignInAccount.authentication;

    FirebaseUser user = await _fAuth.signInWithGoogle(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);

    UserInfoDetails userInfo = new UserInfoDetails(
        user.providerId, user.displayName, user.email, user.photoUrl, user.uid);

    List<UserInfoDetails> providerData = new List<UserInfoDetails>();
    providerData.add(userInfo);

    UserDetails details = new UserDetails(
        user.providerId,
        user.uid,
        user.displayName,
        user.photoUrl,
        user.email,
        user.isAnonymous,
        user.isEmailVerified,
        providerData);

    print("User Name : ${user.displayName}");
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new DetailScreen(detailsUser: details),
      ),
    );
    return user;
  }

  void _signOut(BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Sign out button clicked'),
    ));

    _gSignIn.signOut();
    print('Signed out');
  }*/

  /*GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  initLogin() {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      if (account != null) {
        // user logged
      } else {
        // user NOT logged
      }
    });
    _googleSignIn.signInSilently().whenComplete(() => dismissLoading());
  }

  doLogin() async {
    showLoading();
    await _googleSignIn.signIn();
  }*/

  @override
  void initState() {
    super.initState();

    //_tabController = new TabController(length: 5, vsync: this);

    _checkEmailVerification();

    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          g.userAccountEmail = user?.email;
        }
      });
    });
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
    Navigator.of(context).pop();
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero', //TODO:
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
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
        actions: <Widget>[
          IconButton(
              icon: Icon((Icons.close)), onPressed: () => SystemNavigator.pop())
        ],
      ),
      drawer: new MyDrawer(),
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
                        child: Text("Bienvenido a HFS test de examen.",
                            style: new TextStyle(fontSize: 22.0)))),
                /*Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                    child: new RaisedButton(
                        child: Text("Login with google",
                            style: new TextStyle(fontSize: 22.0)),
                    onPressed: () {
                          _googleAuth.signIn().then((result){
                            result.authentication.then((googleKey){
                              FirebaseAuth.instance.signInWithCredential(credential)
                                idToken: googleKey.accessToken,
                                accessToken: googleKey.accessToken
                              ).then((signedInUser){
                                print("Signed is as ${signedInUser.displayname}");
                                Navigator.of(context).pushReplacementNamed("/home_page");
                              }).catchError((e){
                                    print(e);
                                  });
                            }).catchError((e) {
                              print(e);
                            });
                          }).catchError((e) {
                            print(e);
                          });
                    },)),*/
                /*Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        StreamBuilder(
                            stream: authService.user,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return MaterialButton(
                                  onPressed: () => authService.signOut(),
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  child: Text('Signout'),
                                );
                              } else {
                                return MaterialButton(
                                  onPressed: () => authService.googleSignIn(),
                                  color: Colors.white,
                                  textColor: Colors.black,
                                  child: Text('Login with Google'),
                                );
                              }
                            })
                      ])),
                )*/
                /*Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                    child: new Builder(
                      builder: (BuildContext context) {
                        return new Material(
                          borderRadius: new BorderRadius.circular(30.0),
                          child: new Material(
                            elevation: 5.0,
                            child: new MaterialButton(
                              //padding: new EdgeInsets.all(16.0),
                              minWidth: 150.0,
                              onPressed: () => _signIn(context)
                                  .then((FirebaseUser user) => print(user))
                                  .catchError((e) => print(e)),
                              child: new Text('Sign in with Google'),
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        );
                      },
                    ))*/

                /*Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                    child: new Center(
                        child: Text("Puedes navegar por la opciones del menú.",
                            style: new TextStyle(fontSize: 22.0))))*/
              ]),
            )
          ],
        ),
      ),
    );
  }
}
