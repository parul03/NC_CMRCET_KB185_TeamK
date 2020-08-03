import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:sih/finger.dart';
import 'package:sih/home.dart';
import 'package:sih/models/models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Smart Indian Hackathon",
    home: MyApp(),
    darkTheme: ThemeData(backgroundColor: Colors.white),
    theme: ThemeData(primaryColor: Colors.blueAccent),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String phoneNo;
  String phn;
  String smsOTP = "";
  String verificationId;
  String errorMessage = '';
  String error;
  bool loading;
  bool dialogloading;

  FirebaseAuth _auth;

  @override
  void initState() {
    dialogloading = false;
    loading = false;
    _auth = FirebaseAuth.instance;
    super.initState();
  }

//! ********************************************************  For Verify Phone   ********************************************************

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      setState(() {
        loading = false;
      });
      this.verificationId = verId;
      smsOTPDialog(context);
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {},
          verificationFailed: (AuthException exceptio) {
            setState(() {
              print(exceptio.message);
              error = "Error Occured";
              loading = false;
            });
          });
    } catch (e) {
      handleError(e);
    }
  }

//! ********************************************************  For Sms Diolog Box   ********************************************************

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return !dialogloading
              ? AlertDialog(
                  title: Text('Enter SMS Code'),
                  content: Container(
                    padding: EdgeInsets.all(20.0),
                    height: MediaQuery.of(context).size.height / 5.63,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "Sms Code",
                          hintText: "Sms Code",
                          prefixIcon: Icon(Icons.code),
                          errorText: errorMessage == "" ? null : errorMessage),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        this.smsOTP = value;
                      },
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Back"),
                      onPressed: () {
                        errorMessage = "";
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                        child: Text('Done'),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          if (smsOTP == "") {
                            setState(() {
                              errorMessage = 'Invalid Code';
                            });
                          } else {
                            setState(() {
                              dialogloading = true;
                            });
                            signIn();
                          }
                        })
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }
//! ********************************************************  For Sign in   ********************************************************

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Navigator.of(context).pop();
      GlobalUser.no = phn;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          // return
          return FingerScreen();
        },
      ));
    } catch (e) {
      handleError(e);
    }
  }

//! ********************************************************  For Handle Error in Diolog Box   ********************************************************

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          dialogloading = false;
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context);
        break;
      default:
        setState(() {
          dialogloading = false;
          errorMessage = error.message;
        });

        break;
    }
  }

//! ********************************************************  Main Widget   ********************************************************

  @override
  // Widget build(BuildContext context) {

  //   return Scaffold(
  //       resizeToAvoidBottomInset: false,
  //       body: Stack(
  //         children: <Widget>[
  //           Positioned(
  //             left: 0.0,
  //             right: 0.0,
  //             top: 0.0,
  //             bottom: 0.0,
  //             child: Image.asset(
  //               "images/20191116_183758_0000.png",
  //               fit: BoxFit.fill,
  //             ),
  //           ),
  //           Positioned(
  //             top: MediaQuery.of(context).size.height / 1.81,
  //             left: MediaQuery.of(context).size.width / 7.2,
  //             child: Icon(
  //               Icons.phone,
  //               color: Color(0xFFB0065b8),
  //             ),
  //           ),
  //           Positioned(
  //             top: MediaQuery.of(context).size.height / 1.76,
  //             left: MediaQuery.of(context).size.width / 2.77,
  //             child: Container(
  //               height: MediaQuery.of(context).size.height/19,
  //               width: MediaQuery.of(context).size.width/2,
  //               child: TextField(
  //                 keyboardType: TextInputType.number,
  //                 decoration: InputDecoration(
  //                   border: OutlineInputBorder(borderSide: BorderSide.none),
  //                   hintStyle: TextStyle(
  //                     letterSpacing: 1.0,
  //                     color: Color(0xFFBb5b5b5),
  //                   ),
  //                   hintText: "ENTER NUMBER",
  //                   errorText: error,
  //                 ),
  //                 style: TextStyle(
  //                   letterSpacing: 2.0,
  //                 ),
  //                 onChanged: (value) {
  //                   phn = value;
  //                 },
  //               ),
  //             ),
  //           ),
  //           Positioned(
  //               top: MediaQuery.of(context).size.height / 1.53,
  //               left: MediaQuery.of(context).size.width / 2.77,
  //               child: Container(
  //                 height: MediaQuery.of(context).size.height/19,
  //                 width: MediaQuery.of(context).size.width/3.6,
  //                 decoration: BoxDecoration(
  //                   border: Border.all(
  //                     color: Color(0xFFB0065b8),
  //                   ),
  //                 ),
  //                 child: FlatButton(
  //                   child: Text(
  //                     "NEXT >",
  //                     style: TextStyle(
  //                         color: Color(0xFFB0065b8),
  //                         fontSize: 17,
  //                         letterSpacing: 1.5),
  //                   ),
  //                   onPressed: () {
  //                     Pattern pattern = r'^[0][1-9]\d{9}$|^[1-9]\d{9}$';
  //                     RegExp regex = RegExp(pattern);
  //                     if (!regex.hasMatch(phn)) {
  //                       error = "Invalid Number";
  //                       setState(() {});
  //                     } else {
  //                       error = "";
  //                       phoneNo = "+91" + phn;
  //                       loading = true;
  //                       setState(() {});

  //                       verifyPhone();
  //                     }
  //                   },
  //                 ),
  //               )),
  //           loading
  //               ? Positioned(
  //                   top: 0.0,
  //                   left: 0.0,
  //                   right: 0.0,
  //                   bottom: 0.0,
  //                   child: Container(
  //                     color: Colors.black38,
  //                     child: Center(
  //                       child: CircularProgressIndicator(
  //                         backgroundColor: Color(0xFFB0065b8),
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //               : Container(),
  //         ],
  //       ));
  // }

  Widget build(BuildContext context) {
    // loading = true;

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        // backgroundColor: blue,
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blueGrey, Colors.blueAccent])),
          child: loading == false
              ? Stack(
                  children: <Widget>[
                    Positioned(
                      top: height / 8,
                      left: width / 3,
                      child: Row(
                        children: <Widget>[
                          Text(" S.I.H.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Positioned(
                      left: width - 50,
                      top: height / 7,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    Positioned(
                      left: width / 1.5,
                      top: height / 5,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    Positioned(
                      right: width - 50,
                      bottom: 10,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    Positioned(
                      right: width / 1.5,
                      bottom: 10,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      // height: height/2,
                      // width: width,
                      top: height / 3,
                      left: width / 9,
                      right: width / 9,
                      // bottom: height/4,

                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Text(
                                "Log in",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30.0, left: 4.0, right: 4.0),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  suffixIcon: Icon(Icons.phone),
                                  hintStyle: TextStyle(
                                    letterSpacing: 1.0,
                                    color: Colors.black,
                                  ),
                                  hintText: "ENTER NUMBER",
                                  errorText: error,
                                ),
                                style: TextStyle(
                                  letterSpacing: 2.0,
                                ),
                                onChanged: (value) {
                                  phn = value;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20.0, right: 4.0, left: 4.0, bottom: 50),
                              child: Container(
                                width: double.infinity,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0)),
                                  color: Colors.blueAccent,
                                  child: Text(
                                    "Send OTP",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Pattern pattern =
                                        r'^[0][1-9]\d{9}$|^[1-9]\d{9}$';
                                    RegExp regex = RegExp(pattern);
                                    if (!regex.hasMatch(phn)) {
                                      error = "Invalid Number";
                                      setState(() {});
                                    } else {
                                      error = "";
                                      phoneNo = "+91" + phn;
                                      loading = true;
                                      setState(() {});

                                      verifyPhone();
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Card(
                    //     color: Colors.black,
                    //     child: Column(

                    //       children: <Widget>[

                    //     Text("askdhfua shfuahspfh"),
                    //     Text("askdhfua shfuahspfh"),
                    //     Text("askdhfua shfuahspfh"),
                    //     Text("askdhfua shfuahspfh"),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    Positioned(
                        top: height / 3.6,
                        left: width / 2.6,
                        child: Container(
                            child: Icon(Icons.account_circle,
                                color: Colors.blueAccent, size: 80),
                            decoration: BoxDecoration(
                                // shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Colors.blue,
                                  // width: 2.0
                                ),
                                borderRadius: BorderRadius.circular(40.0)
                                // borderRadius: BorderRadius.all(Border)
                                ))),

                    //       loading
                    // ? Positioned(
                    //     top: 0.0,
                    //     left: 0.0,
                    //     right: 0.0,
                    //     bottom: 0.0,
                    //     child: Container(
                    //       color: Colors.black38,
                    //       child: Center(
                    //         child: CircularProgressIndicator(
                    //           backgroundColor: blue,
                    //         ),
                    //       ),
                    //     ),
                    //   )
                    // : Container(),
                  ],
                )
              : Container(
                  color: Colors.black38,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
        ));
  }
}
