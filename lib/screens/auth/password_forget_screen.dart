import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matgar_app/services/global_method.dart';



class ForgetPassword extends StatefulWidget {
  static const routeName = '/ForgetPassword';

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String _emailAddress = '';
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
        await _auth
            .sendPasswordResetEmail(email: _emailAddress.trim().toLowerCase())
            .then((value) => Fluttertoast.showToast(
            msg: "An email has been sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0));

        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        _globalMethods.authErrorHandle(error.message, context);
        // print('error occured ${error.message}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }












  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.teal,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50 , left: 10),
              child: Text(
                'Forget password',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400 , color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
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
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: _isLoading
                  ? Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )
                  : Center(
                    child: InkWell(
                onTap: _submitForm,
                child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Text(
                          'Reset Password',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 17),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.vpn_key_outlined,
                          color: Colors.white,
                          size: 18,
                        )
                      ],
                    ),
                ),
              ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}