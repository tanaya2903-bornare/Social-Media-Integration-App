import 'dart:convert' as JSON;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'UserProfile.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types
class signinPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<signinPage> {
  String name;
  String id;
  String email;
  String photoUrl;
  String site;
  Map userProfile;
  final facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  static final TwitterLogin twitterLogin = new TwitterLogin(
    consumerKey: 'MmfkSzEx3SH8e1fQWTubLezce',
    consumerSecret: 'uDdIVWe6fXmjzSIhuJ6XdTT4ldEnPZzW9a0FM50hvKfV2ckWDe',
  );

  // ignore: non_constant_identifier_names
  void _Googlelogin() async {
    try {
      await _googleSignIn.signIn();
      site = "Google";
      id = _googleSignIn.currentUser.id;
      name = _googleSignIn.currentUser.displayName;
      email = _googleSignIn.currentUser.email;
      photoUrl = _googleSignIn.currentUser.photoUrl;
      navigateToPage(site, id, name, email, photoUrl);
    } catch (err) {
      print(err);
    }
  }

  // ignore: non_constant_identifier_names
  _Facebooklogin() async {
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        Uri myUri = Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
        final graphResponse = await http.get(myUri);
        final profile = JSON.jsonDecode(graphResponse.body);
        userProfile = profile;
        site = "Facebook";
        id = userProfile['id'];
        name = userProfile['name'];
        email = userProfile['email'];
        photoUrl = userProfile['picture']['data']['url'];
        navigateToPage(site, id, name, email, photoUrl);
        break;
        case FacebookLoginStatus.cancelledByUser:
        debugPrint('${result.errorMessage}');
        break;
        case FacebookLoginStatus.error:
        debugPrint('${result.errorMessage}');
        break;
    }
  }
  // ignore: non_constant_identifier_names
  void _Twitterlogin() async {
    final TwitterLoginResult result = await twitterLogin.authorize();
    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        var session = result.session;
        final AuthCredential credential = TwitterAuthProvider.credential(
            accessToken: session.token, secret: session.secret);
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((authResult) {
          print(authResult.user);
          site = "Twitter";
          id = authResult.user.uid;
          name = authResult.user.displayName;
          email = authResult.user.email ?? 'null';
          photoUrl = authResult.user.photoURL;
          navigateToPage(site, id, name, email, photoUrl);
        });
        break;
      case TwitterLoginStatus.cancelledByUser:
        debugPrint('${result.errorMessage}');
        break;
      case TwitterLoginStatus.error:
        debugPrint('${result.errorMessage}');
        break;
    }
  }

  navigateToPage(var site, var id, var name, var email, var photoUrl) {
    var fname = name.split(" ");
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => UserProfilePage(
                site: site,
                id: id,
                name: name,
                fname: fname[0],
                email: email,
                photoUrl: photoUrl)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft:Radius.circular(50),
                    bottomRight:Radius.circular(50)),
              image: DecorationImage(
                image: AssetImage('assets/images/img1.jpg'),
                fit: BoxFit.fill
              )
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: 220,
                    left:  100.0,
                  bottom: 20.0,
                  child: Text(
                    'LOGIN',
                    style: GoogleFonts.alice(
                        fontWeight: FontWeight.bold,
                        fontSize: 55.0,
                        color: Color(0xFF492625)
                    ),
                  )
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10.0,),
                Container(
                  width: 250.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                              bottomRight:Radius.circular(30)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/google.png',
                              height: 50.0,
                              width: 50.0,
                            ),
                            SizedBox(width: 10.0,),
                            Text('Log In with Google',style: TextStyle(color:Colors.black87,
                                fontSize: 18.0),)
                          ],
                        ),
                        onPressed: () {
                          _Googlelogin();
                        },
                        color:Color(0XFF81C784)
                    ),
                  ),
                ),
                SizedBox(height: 30.0,),
                Container(
                    width: 250.0,
                    child: Align(
                      alignment: Alignment.center,
                      child:RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                              bottomRight:Radius.circular(30)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/Facebook_icon.jpg',
                              height: 55.0,
                              width: 30.0,
                            ),
                            SizedBox(width: 10.0,),
                            Text('Log In with Facebook',style: TextStyle(color:Colors.black87,
                                fontSize: 18.0),)
                          ],
                        ),
                        onPressed: () {
                          _Facebooklogin();
                        },
                          color:Color(0XFF81C784)
                      ),
                    )
                ),
                SizedBox(height: 30.0,),
                Container(
                    width: 250.0,
                    child: Align(
                      alignment: Alignment.center,
                      child:RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                              bottomRight:Radius.circular(30)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/twitter.png',
                              height: 55.0,
                              width: 30.0,
                            ),
                            SizedBox(width: 10.0,),
                            Text('Log In with Twitter',style: TextStyle(color:Colors.black87,
                                fontSize: 18.0),)
                          ],
                        ),
                        onPressed: () {
                          _Twitterlogin();
                        },
                          color:Color(0XFF81C784)
                      ),
                    )
                )
              ],
            ),)
        ],
      ),
      )
    );
  }
}
