import 'package:blog_app/pages/Dialog.dart';
import 'package:blog_app/pages/auth.dart';
//import 'package:blog_app/pages/sign_in.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final AuthServices? auth;
  final VoidCallback? onSignedIn;
  const LoginPage({super.key, required this.auth, required this.onSignedIn});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
enum FormType{
  login,
  signIn
}
class _LoginPageState extends State<LoginPage> {
  DialogBox dialogBox=DialogBox();
  final _formKey = GlobalKey<FormState>();
  FormType _formType=FormType.login;
  String _email="";
  String _password="";

  bool validateandSave() {

    final form=_formKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }
void validateandSubmit()async{
if(validateandSave())
{
  try{
    if(_formType==FormType.login){
      String? userId =await widget.auth?.SignIn(_email, _password) ;
      dialogBox.information(context, "Congratulations", "You are logged in succesfully");
      print("login userId ="+userId!);
    }
    else{
      String? userId =await widget.auth?.Signup(_email, _password) ;
      dialogBox.information(context, "Congratulations", "Your account is created succesfully");
      print("Register userId ="+userId!);
    }
    widget.onSignedIn!();
  }catch(e){
    dialogBox.information(context, "Error ", e.toString());
print("Error ="+e.toString());
  }
}
}
  void movetologin(){
    _formKey.currentState?.reset();
    setState(() {
      _formType=FormType.login;
    });
  }
  void movetoRegister(){
      _formKey.currentState?.reset();
      setState(() {
        _formType=FormType.signIn;
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(_formType==FormType.login?"Login":"SignIn",
            style: const TextStyle(
            color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: createInput() + createButton())),
        ),
      ),
    );
  }

  List<Widget> createInput() {
    return [
      const SizedBox(
        height: 10,
      ),
      Logo(),
      const SizedBox(
        height: 20,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: "Email"),
        validator: (value){
          return value!.isEmpty ? "Email is required":null;

        },
        onSaved: (value){
          setState(() {
            _email=value!;
          });
        },
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        obscureText: true,
        decoration: const InputDecoration(labelText: "Password",
        ),
        validator: (value){
          return value!.isEmpty ? "Password is required":null;

        },
        onSaved: (value){
          setState(() {
            _password=value!;
          });
        },
      )
    ];
  }

  Widget Logo() {
    return Hero(
        tag: 'hero',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 110,
          child: Image.asset("assets/logohand.png"),
        ));
  }

  List<Widget> createButton() {
    if(_formType==FormType.login){
      return [
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: validateandSubmit,
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
              ),
            )),
        TextButton(

            onPressed: movetoRegister,
            child: const Text("Not have an account?\t Create One",
                style: TextStyle(fontSize: 16, color: Colors.black45)))
      ];
    }
    else{
      return [
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: validateandSubmit,
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor
            ),
            child: const Text(
              "Register",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
              ),
            )),
        TextButton(

            onPressed: movetologin,
            child: const Text("Already have an account? Login",
                style: TextStyle(fontSize: 16, color: Colors.black45)))
      ];
    }
  }
}
