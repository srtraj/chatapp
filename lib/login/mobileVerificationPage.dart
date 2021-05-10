import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatapp/login/permissionPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'countryListPage.dart';
import 'otpPage.dart';

class MobileVerPage extends StatefulWidget {
  @override
  _MobileVerPageState createState() => _MobileVerPageState();
}

class _MobileVerPageState extends State<MobileVerPage> {
  String verMob1 = "";
  String verMob2 = "";
  String country = "India";
  var countryList;

  TextEditingController cntCode;
  TextEditingController cntPhone = new TextEditingController();
  @override
  void initState() {
    super.initState();
    readConstStringJson();
    readCountryJson();
    cntCode = new TextEditingController(text: "91");
  }

  readConstStringJson() async {
    final String response =
        await rootBundle.loadString('assets/constString.json');
    final data = await json.decode(response);
    verMob1 = data["verMobString"][0];
    verMob2 = data["verMobString"][1];
  }

  readCountryJson() async {
    final String response =
        await rootBundle.loadString('assets/countryCode.json');
    final data = await json.decode(response);
    countryList = data["country"];
    setState(() {});
  }

  getCountryFronCode(code) {
    for (String key in countryList.keys) {
      if ("<${countryList[key]}>" == "<+$code>") {
        country = key;
        break;
      } else
        country = "Invalid country code!";
    }
    setState(() {});
  }

  showAlertDialog(BuildContext context, msg) {
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

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height / 100;
    final wt = MediaQuery.of(context).size.width / 100;
    // final modeLight = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
    //         .platformBrightness ==
    //     Brightness.light;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: ht * 2,
              ),
              Container(
                height: ht * 5,
                child: Center(
                  child: AutoSizeText(
                    verMob1,
                    minFontSize: 15,
                    maxFontSize: 20,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]),
                  ),
                ),
              ),
              Container(
                height: ht * 10,
                padding: EdgeInsets.only(left: wt * 5, right: wt * 5),
                child: Center(
                  child: AutoSizeText(
                    verMob2,
                    minFontSize: 10,
                    maxFontSize: 16,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Container(
                height: ht * 10,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.lightGreenAccent,
                              width: 3,
                            ),
                          ),
                        ),
                        width: wt * 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: wt * 3),
                              child: AutoSizeText(
                                country.length > 21
                                    ? "${country.substring(0, 21)}...."
                                    : country,
                                minFontSize: 14,
                                maxFontSize: 20,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            IconButton(
                              iconSize: ht * wt,
                              icon: Icon(Icons.arrow_drop_down),
                              onPressed: () async {
                                String res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CountryListPage(countryList)),
                                );
                                if (res != null) {
                                  country = res;
                                  cntCode.text = countryList[country]
                                      .toString()
                                      .substring(1);
                                }
                                setState(() {});
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: wt * 70,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.lightGreenAccent,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.only(left: wt * 2),
                                child: Row(
                                  children: [
                                    AutoSizeText(
                                      "+",
                                      minFontSize: 18,
                                      maxFontSize: 25,
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.grey),
                                    ),
                                    SizedBox(
                                      width: wt * 3,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: cntCode,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(bottom: ht),
                                          border: InputBorder.none,
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(3),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        onChanged: (value) {
                                          getCountryFronCode(value);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: wt * 3,
                            ),
                            Expanded(
                                flex: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.lightGreenAccent,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: cntPhone,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Phone number",
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(12),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: ht * 5,
                    ),
                    Container(
                      height: ht * 5,
                      child: ElevatedButton(
                        onPressed: () async {
                          progressIndicator(context);
                          var res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpPage(
                                    "+${cntCode.text}${cntPhone.text}")),
                          );
                          print("resssssssssssssssssssssssss---$res");
                          cntPhone.clear();
                          Navigator.of(context).pop();
                          if (res == "verificationCompleted") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PermissionPage()),
                            );
                          } else {
                            showAlertDialog(context, res);
                          }
                        },
                        child: Text("next"),
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
