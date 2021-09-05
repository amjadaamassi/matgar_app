import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matgar_app/consts/colors.dart';
import 'package:matgar_app/services/global_method.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/SignUpScreen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  bool _obscureText = true;
  String _emailAddress = '';
  String _password = '';
  String _fullName = '';
  int _phoneNumber;
  File _pickedImage;
  String url;

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";

    if (isValid) {
      _formKey.currentState.save();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Please pick an image', context);
        } else {
          setState(() {
            _isLoading = true;
          });
          final ref = FirebaseStorage.instance
              //========== انشاء المسار الخاص بالصورة
              .ref()
              .child('usersImages')
              .child(_fullName + '.jpg');
          //===================================
          await ref.putFile(_pickedImage);
          url = await ref.getDownloadURL();
          //=========================================================================
          await _auth.createUserWithEmailAndPassword(
            email: _emailAddress.toLowerCase().trim(),
            password: _password.trim(),
          );

          final User user = _auth.currentUser;
          final _uid = user.uid;
          user.updateProfile(photoURL: url, displayName: _fullName);
          user.reload();

          await FirebaseFirestore.instance.collection('users').doc(_uid).set({
            'id': _uid,
            'name': _fullName,
            'email': _emailAddress,
            'phoneNumber': _phoneNumber,
            'imageUrl': url,
            'joinedAt': formattedDate,
            'createdAt': Timestamp.now(),
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error.message, context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _remove() {
    setState(() {
      _pickedImage = null;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade500,
      body: Stack(
        children: [
          // ========================= الخلفية
          // Container(
          //   height: MediaQuery.of(context).size.height * 0.95,
          //   child: RotatedBox(
          //     quarterTurns: 2,
          //     child: WaveWidget(
          //       config: CustomConfig(
          //         gradients: [
          //           [ColorsConsts.gradiendFStart, ColorsConsts.gradiendLStart],
          //           [ColorsConsts.gradiendFEnd, ColorsConsts.gradiendLEnd],
          //         ],
          //         durations: [19440, 10800],
          //         heightPercentages: [0.20, 0.25],
          //         blur: MaskFilter.blur(BlurStyle.solid, 10),
          //         gradientBegin: Alignment.bottomLeft,
          //         gradientEnd: Alignment.topRight,
          //       ),
          //       waveAmplitude: 0,
          //       size: Size(
          //         double.infinity,
          //         double.infinity,
          //       ),
          //     ),
          //   ),
          // ),

          // ===================================================

          Padding(
            padding: EdgeInsets.only(
              top: 150,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: ColorsConsts.white),
                    ),

                    //===============================التقاط الصورة
                    Stack(
                      children: [
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                              radius: 65,
                              backgroundColor: Colors.white,
                              backgroundImage: _pickedImage == null
                                  ? null
                                  : FileImage(_pickedImage),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 120,
                            left: 110,
                            child: RawMaterialButton(
                              elevation: 10,
                              fillColor: Colors.teal,
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Choose option',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: ColorsConsts.gradiendLStart),
                                        ),
                                        content: Container(
                                          height: 200,
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: _pickImageCamera,
                                                splashColor: Colors.purpleAccent,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons.camera,
                                                        color:
                                                            Colors.purpleAccent,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Camera',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              ColorsConsts.title),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: _pickImageGallery,
                                                splashColor: Colors.purpleAccent,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons.image,
                                                        color:
                                                            Colors.purpleAccent,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Gallery',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              ColorsConsts.title),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: _remove,
                                                splashColor: Colors.purpleAccent,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons.remove_circle,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Remove',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.red),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ))
                      ],
                    ),

                    Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Text Field of name ==================
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  key: ValueKey('name'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'name cannot be null';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () => FocusScope.of(context)
                                      .requestFocus(_emailFocusNode),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      border: const UnderlineInputBorder(),
                                      filled: true,
                                      prefixIcon: Icon(Icons.person),
                                      labelText: 'Full name',
                                      fillColor:
                                          Theme.of(context).backgroundColor),
                                  onSaved: (value) {
                                    _fullName = value;
                                  },
                                ),
                              ),

                              // Text Field of email ==================
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  key: ValueKey('email'),
                                  focusNode: _emailFocusNode,
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
                                      fillColor:
                                          Theme.of(context).backgroundColor),
                                  onSaved: (value) {
                                    _emailAddress = value;
                                  },
                                ),
                              ),

                              // Text Field of password ==================
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
                                      fillColor:
                                          Theme.of(context).backgroundColor),
                                  onSaved: (value) {
                                    _password = value;
                                  },
                                  obscureText: _obscureText,
                                  onEditingComplete: () => FocusScope.of(context)
                                      .requestFocus(_phoneNumberFocusNode),
                                ),
                              ),

                              // Text Field of phone ==================
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  key: ValueKey('phone number'),
                                  focusNode: _phoneNumberFocusNode,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a valid phone number';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: _submitForm,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      border: const UnderlineInputBorder(),
                                      filled: true,
                                      prefixIcon: Icon(Icons.phone_android),
                                      labelText: 'Phone number',
                                      fillColor:
                                          Theme.of(context).backgroundColor),
                                  onSaved: (value) {
                                    _phoneNumber = int.parse(value);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              //  SizedBox(width: 10),
                              _isLoading
                                  ? CircularProgressIndicator()
                                  : InkWell(
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
                                              'Sign up',
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
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
