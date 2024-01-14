import 'package:flutter/material.dart';
import 'login.dart';
import 'package:blog_app/home.dart';
import 'auth.dart';

class MappingPage extends StatefulWidget {
  final AuthServices? auth;
  const MappingPage({super.key, this.auth});

  @override
  State<MappingPage> createState() => _MappingPageState();
}
enum Authstatus{
  notSignedIn,
  signedIn,
}
class _MappingPageState extends State<MappingPage> {
  Authstatus authstatus= Authstatus.notSignedIn;
  void _signedIn(){
    setState(() {
      authstatus = Authstatus.signedIn;
    });
  }
  void _signOut(){
    setState(() {
      authstatus = Authstatus.notSignedIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth?.getCurrentUser().then((firebaseUserId)
    {
      setState(() {
        authstatus=firebaseUserId==null?Authstatus.notSignedIn:Authstatus.signedIn;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    switch(authstatus){
      case Authstatus.notSignedIn:
        return LoginPage(
          auth:widget.auth,
          onSignedIn:_signedIn
        );
      case Authstatus.signedIn:
        return HomePage(
          auth: widget.auth,
          onSignedout:_signOut
        );
      default:
        print("No Cases left");
    }
    return Placeholder();
  }
}
