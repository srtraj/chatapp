import 'package:auto_size_text/auto_size_text.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

// ignore: must_be_immutable
class OtpPage extends StatefulWidget {
  OtpPage(this.mobNo);
  String mobNo;

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  List<String> otpString = [];
  int otpField = 0;
  bool autoFill = false;
  String verificationId;

  @override
  void initState() {
    super.initState();
    getIncomingMessage();
    otpField = 6;
    setState(() {});
    verifyPhone();
  }

  getIncomingMessage() async {
    // Create SMS Receiver Listener
    SmsReceiver receiver = new SmsReceiver();
    // msg has New Incoming Message
    String autoOtp;
    receiver.onSmsReceived.listen((SmsMessage msg) => {
          // print(msg.address),
          // print(msg.body),
          // print(msg.date),
          // print(msg.isRead),
          // print(msg.sender),
          // print(msg.threadId),
          // print(msg.state)
          autoFill = true,
          autoOtp = msg.body.substring(0, 6),
          otpString = autoOtp.split(""),
          setState(() {}),
        });
  }

  showAlertDialog(BuildContext context, msg) {
    if (!autoFill) Navigator.pop(context);
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(msg),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  progressIndicator(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  signInWithOTP(context, smsCode) async {
    print(
        "1---$smsCode--------------------->${FirebaseAuth.instance.currentUser}");
    FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode.join()))
        .then((value) {
      Navigator.pop(context);
      if (value != null) {
        print('SignIn Successfully! ');
        Navigator.pop(context, "verificationCompleted");
      }
    }).catchError((onError) {
      print(
          "${FirebaseAuth.instance.currentUser}--3--------------------------------->$onError");
      showAlertDialog(context, "Invalid-Otp");
    });
  }

  Future<void> verifyPhone() async {
    final PhoneVerificationCompleted verified =
        (AuthCredential authResult) async {
      FirebaseAuth.instance.signInWithCredential(authResult).then((value) {
        if (value != null) {
          print('(PhoneVerificationCompleted) SignIn Successfully! ');
          Navigator.pop(context, "verificationCompleted");
        }
      });
    };

    final PhoneVerificationFailed verificationfailed = (e) {
      print('${e.code}');
      // Navigator.pop(context);
      print("------------------->${widget.mobNo}");
      Navigator.pop(context, e.code);
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) async {
      setState(() {
        verificationId = verId;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      setState(() {
        verificationId = verId;
      });
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.mobNo,
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout,
        timeout: Duration(seconds: 120));
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final wt = mq.width / 100;
    final ht = mq.height / 100;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: AutoSizeText(
                      "Enter pin",
                      maxFontSize: 18,
                      minFontSize: 10,
                      style: TextStyle(fontSize: 15),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(left: wt * 2, right: wt * 2),
                    child: Row(
                      children: [
                        for (int i = 0; i < otpField; i++)
                          Expanded(
                            child: otpFieldWidget(
                                ht,
                                otpString.length > i ? otpString[i] : "",
                                i + 1),
                          ),
                      ],
                    ),
                  )),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: ht * 5),
                  child: otpString.length == 6
                      ? ElevatedButton(
                          onPressed: () {
                            progressIndicator(context);
                            signInWithOTP(context, otpString);
                          },
                          child: AutoSizeText(
                            "verify",
                            maxFontSize: 18,
                            minFontSize: 10,
                            style: TextStyle(fontSize: 15),
                          ),
                        )
                      : Container(),
                ),
              ),
              Expanded(flex: 1, child: Container()),
              Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(left: wt, right: wt, bottom: ht),
                    child: Column(
                      children: [
                        keyboardRow("1", "2", "3", "back"),
                        keyboardRow("4", "5", "6", ""),
                        keyboardRow("7", "8", "9", ""),
                        keyboardRow("", "0", "", "")
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  otpFieldWidget(ht, otp, i) {
    if (autoFill && otpString.length == 6 && i == otpField) {
      signInWithOTP(context, otpString);
    }

    return Container(
      height: 60,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: AutoSizeText(
            otp,
            maxFontSize: 30,
            minFontSize: 25,
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }

  keyboardButtomn(btn) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(2),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey),
          ),
          onPressed: () {
            autoFill = false;
            switch (btn) {
              case "back":
                if (otpString.length > 0)
                  otpString.removeAt(otpString.length - 1);
                break;
              case "":
                break;
              default:
                if (otpString.length != otpField) otpString.add(btn);
            }
            setState(() {});
          },
          child: Center(
            child: btn == "back"
                ? Icon(
                    Icons.backspace_outlined,
                    size: 30,
                  )
                : AutoSizeText(
                    btn,
                    maxFontSize: 30,
                    minFontSize: 25,
                    style: TextStyle(fontSize: 30),
                  ),
          ),
        ),
      ),
    );
  }

  keyboardRow(k1, k2, k3, k4) {
    return Expanded(
      child: Row(
        children: [
          keyboardButtomn(k1),
          keyboardButtomn(k2),
          keyboardButtomn(k3),
          keyboardButtomn(k4),
        ],
      ),
    );
  }
}
