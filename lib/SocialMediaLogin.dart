import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialMediaLogin extends StatefulWidget {
  @override
  _SocialMediaLoginState createState() => _SocialMediaLoginState();
}

class _SocialMediaLoginState extends State<SocialMediaLogin> {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final _result = await FacebookAuth.instance.login();
    if (_result.status == LoginStatus.success) {
      final AccessToken _accessToken = _result.accessToken;
      final FacebookAuthCredential _facebookAuthCredential =
          FacebookAuthProvider.credential(_accessToken.token);
      return await FirebaseAuth.instance
          .signInWithCredential(_facebookAuthCredential);
    } else {
      print(_result.message);
      return null;
    }
  }

  Widget _userStatus() {
    if (FirebaseAuth.instance.currentUser == null) {
      return Container(
        margin: EdgeInsets.all(8),
        child: Text("You're not currently logged in"),
      );
    } else {
      return Container(
          margin: EdgeInsets.all(8),
          child: Text(FirebaseAuth.instance.currentUser.displayName != null
              ? 'Welcome ' + FirebaseAuth.instance.currentUser.displayName + '!'
              : 'Welcome ' + FirebaseAuth.instance.currentUser.email + '!'));
    }
  }

  Widget _googleButton() {
    return ListTile(
        title: Text(
          'Sign in with Google',
          style: TextStyle(color: Colors.white),
        ),
        tileColor: Colors.red[600],
        onTap: () async {
          showDialog(
              context: context,
              builder: (context) {
                signInWithGoogle()
                    .whenComplete(() => Navigator.pop(context))
                    .then((value) =>
                        Navigator.popUntil(context, ModalRoute.withName('/')));

                return AlertDialog(content: LinearProgressIndicator());
              });
        });
  }

  Widget _facebookButton() {
    return ListTile(
      title:
          Text('Sign in with Facebook', style: TextStyle(color: Colors.white)),
      tileColor: Colors.blue,
      onTap: () {
        signInWithFacebook().then((value) => Navigator.popUntil(context, ModalRoute.withName('/')));
      },
    );
  }

  Widget _signoutButton() {
    return ListTile(
      title: Text('Sign out'),
      leading: Icon(Icons.logout),
      onTap: () {
        FirebaseAuth.instance.signOut();
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Social Media Login'),
        ),
        body: ListView(
          children: [
            _userStatus(),
            FirebaseAuth.instance.currentUser == null
                ? _googleButton()
                : Container(),
            FirebaseAuth.instance.currentUser == null
                ? _facebookButton()
                : Container(),
            FirebaseAuth.instance.currentUser != null
                ? _signoutButton()
                : Container()
          ],
        ));
  }
}
