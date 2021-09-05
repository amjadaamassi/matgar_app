
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matgar_app/consts/colors.dart';
import 'package:matgar_app/screens/auth/password_forget_screen.dart';
import 'package:matgar_app/services/global_method.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../bottom_bar.dart';



class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _passwordFocusNode = FocusNode();



  bool _obscureText = true;
  String _emailAddress = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();


  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;




  void _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      try {
        await _auth.signInWithEmailAndPassword(

            email:      _emailAddress.toLowerCase().trim(),
            password:   _password.trim())
            .then( (value) =>
        Navigator.pushNamed(context, BottomBarScreen.routeName ));
      } catch (error) {
        _globalMethods.authErrorHandle(error.message, context);
        print('error occured ${error.message}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }



  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Stack(
        children: [

          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  Container(
                    margin: EdgeInsets.only(top: 100 , bottom: 80),
                    height: 120.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      //  color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://image.flaticon.com/icons/png/128/869/869636.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              key: ValueKey('email'),
                              validator: (value) {
                                if (value.isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  filled: true,
                                  prefixIcon: Icon(Icons.email),
                                  labelText: 'Email Address',
                                  fillColor: Theme.of(context).backgroundColor),
                              onSaved: (value) {
                                _emailAddress = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              key: ValueKey('Password'),
                              validator: (value) {
                                if (value.isEmpty || value.length < 7) {
                                  return 'Please enter a valid Password';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              focusNode: _passwordFocusNode,
                              decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  filled: true,
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: Icon(_obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                  labelText: 'Password',
                                  fillColor: Theme.of(context).backgroundColor),
                              onSaved: (value) {
                                _password = value;
                              },
                              obscureText: _obscureText,
                              onEditingComplete: _submitForm,
                            ),
                          ),



                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 20),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ForgetPassword.routeName);
                                  },
                                  child: Text(
                                    'Forget password?',
                                    style: TextStyle(
                                        color: Colors.blue.shade900,
                                        decoration: TextDecoration.underline),
                                  )),
                            ),
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 10),
                              _isLoading
                                  ? CircularProgressIndicator() :


                              InkWell(
                                onTap: _submitForm,
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Sign In',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 17),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
