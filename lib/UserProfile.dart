import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class UserProfilePage extends StatefulWidget {
  final site;
  final name;
  final email;
  final photoUrl;
  final id;
  final fname;

  const UserProfilePage(
      {Key key, this.site, this.id, this.name,this.fname, this.email, this.photoUrl})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _InfoState();
  }
}
class _InfoState extends State<UserProfilePage> {
  final facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  FirebaseAuth _auth = FirebaseAuth.instance;
  static final TwitterLogin twitterLogin = new TwitterLogin(
    consumerKey: 'MmfkSzEx3SH8e1fQWTubLezce',
    consumerSecret: 'uDdIVWe6fXmjzSIhuJ6XdTT4ldEnPZzW9a0FM50hvKfV2ckWDe',
  );

  // ignore: non_constant_identifier_names
  _Googlelogout() {
    _googleSignIn.signOut();
  }

  // ignore: non_constant_identifier_names
  _Facebooklogout() {
    facebookLogin.logOut();
  }
  // ignore: non_constant_identifier_names
  _Twitterlogout() async {
    await twitterLogin.logOut();
    await _auth.signOut();
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
                        image: AssetImage('assets/images/img2.jpg'),
                        fit: BoxFit.fill
                    )
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 230,
                      left:  105.0,
                      bottom: 20.0,
                      child: Text(
                          'PROFILE',
                        style: GoogleFonts.alice(
                            fontWeight: FontWeight.w400,
                            fontSize: 50.0,
                            color: Color(0xFF492625)),
                    )
                    )
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(50, 10, 50, 20),
                  child: Column(children: [
                    Text(widget.site,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color:Color(0xFF496149)
                            )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child:CircleAvatar(
                            radius: 90,
                            backgroundImage: NetworkImage(widget.photoUrl))
                    ),
                    Text("Name:- " + widget.name,
                        style: TextStyle(
                            fontSize: 20,
                            height: 1.5,
                            color: Colors.black,
                          fontStyle: FontStyle.italic,

                        )),
                    Text("Email:- " + widget.email,
                        style: TextStyle(
                            fontSize: 19,
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                        )),
                    Text("Id:- " + widget.id,
                        style: TextStyle(
                            fontSize: 18,
                            height: 1.5,
                            color: Colors.black,
                          fontStyle: FontStyle.italic,
                        )),
                    Padding(padding: EdgeInsets.all(2.0)),
                    RaisedButton(
                      color:Color(0XFF81C784),
                        child: Text("Logout",style: TextStyle(color: Colors.black87),),
                        onPressed: () {
                          if (widget.site == "Google") {
                            _Googlelogout();
                          }else
                                if(widget.site == "Facebook") {
                                 _Facebooklogout();
                          }else if (widget.site == "Twitter") {
                                  _Twitterlogout();
                                }
                          Navigator.pop(context);
                       })
                  ]))
            ],
          ),
        ));
  }
}
