import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sih/home.dart';

class FingerScreen extends StatefulWidget {
  @override
  _FingerScreenState createState() => _FingerScreenState();
}

class _FingerScreenState extends State<FingerScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> _availableBiometrics;

  @override
  void initState() {
    super.initState();
    _availableBiometrics = List();
    _getAvailableBiometrics();
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
    print(_availableBiometrics);

    if (_availableBiometrics.length != 0) {
      print("yeah1");
      _authenticate();
    } else {
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        },
      ));
    }
  }

  Future<void> _authenticate() async {
    print("Yeah");
    bool authenticated = false;
    try {
      //!   ********************  Loding = true  *********************

      // setState(() {
      //   _isAuthenticating = true;
      //   _authorized = 'Authenticating';
      // });

      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      if (authenticated == true) {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        ));
      }
      // setState(() {
      //   _isAuthenticating = false;
      //   _authorized = 'Authenticating';
      // });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    //!   ********************  Loding = false  *********************

    // setState(() {
    //   _authorized = message;
    // });
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: InkWell(
                onTap: () {
                  _authenticate();
                  //!   *****************   Navigator to home Screen   **********
                },
                child: Text(
                  "Authentication Failed\nTap here to authenticate...",
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.blue),
                  textAlign: TextAlign.center,
                )),
          )
        ],
      ),
    );
  }
}
