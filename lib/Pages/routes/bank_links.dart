import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/login.dart';
import 'package:vsla/utils/role.dart';

// ignore: camel_case_types
class Bank_links extends StatefulWidget {
  const Bank_links({super.key});

  @override
  State<Bank_links> createState() => _Bank_linksState();
}

// ignore: camel_case_types
class _Bank_linksState extends State<Bank_links> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    _onBackButtonPressed(context);
                  },
                  child: const Icon(Icons.arrow_back_ios_new_sharp)),
              Image(
                  height: MediaQuery.of(context).size.height * 0.05,
                  image: const AssetImage("assets/images/vsla.png"))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Link with Banks".tr,
                style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: <Widget>[
                    // Larger rectangle (blue)
                    Container(
                        width: screenWidth * 0.6,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: screenWidth * 0.5,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 5, 0, 0),
                                          child: Text(
                                            "Link".tr,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 05, 0),
                                        child: RoundCheckBox(
                                          size: screenWidth * 0.04,
                                          onTap: (selected) {},
                                          // uncheckedWidget: Center(
                                          //   child: Icon(
                                          //     Icons.close,
                                          //     size: screenWidth * 0.04,
                                          //   ),
                                          // ),
                                          checkedWidget: Icon(
                                            Icons.done,
                                            size: screenWidth * 0.03,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Cooperative Bank of Oromia".tr,
                                        style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.023,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ])
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                    Positioned(
                      bottom: screenWidth * 0.1,
                      top: -screenWidth * 0.09,
                      right: screenWidth * 0.05,
                      left: screenWidth * 0.09,
                      child: Container(
                        width: screenWidth * 0.2,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(100)),
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                            child: const Image(
                                image: AssetImage("assets/images/coop.png"))),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: <Widget>[
                    // Larger rectangle (blue)
                    Container(
                        width: screenWidth * 0.6,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: screenWidth * 0.5,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 5, 0, 0),
                                          child: Text(
                                            "Link".tr,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 05, 0),
                                        child: RoundCheckBox(
                                          size: screenWidth * 0.04,
                                          onTap: (selected) {},
                                          // uncheckedWidget: Center(
                                          //   child: Icon(
                                          //     Icons.close,
                                          //     size: screenWidth * 0.04,
                                          //   ),
                                          // ),
                                          checkedWidget: Icon(
                                            Icons.done,
                                            size: screenWidth * 0.03,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Other Bank".tr,
                                        style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.023,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ])
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                    Positioned(
                      bottom: screenWidth * 0.1,
                      top: -screenWidth * 0.07,
                      right: screenWidth * 0.09,
                      left: screenWidth * 0.09,
                      child: Container(
                          width: screenWidth * 0.2,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(100)),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                            child: Container(),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Ready to link with the bank of your choice?".tr,
            style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: Colors.orange),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Banks keep a record of your financial transactions, which can be especially useful when applying for loans, grants, or other financial opportunities"
                .tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                height: screenWidth * 0.005,
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.2,
            vertical: MediaQuery.of(context).size.height * 0.04,
          ),
          child: GestureDetector(
            // onTap: () {
            //   // login();
            //   Navigator.push(context,
            //       MaterialPageRoute(builder: (context) => const CreatGroup()));
            // },
            child: Container(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              decoration: BoxDecoration(
                color: Colors.white, // You can use your color here
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.blue.shade500.withOpacity(0.2), // Shadow color
                    spreadRadius: 5, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: const Offset(0, 3), // Offset from the top
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Get Started".tr,
                  style: GoogleFonts.poppins(
                    color: Colors.black, // You can use your color here
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Confirm Exit"),
            content: const Text("Do you want to Logout?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () async {
                    List<String> user = [];
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    prefs.setStringList("_keyUser", user);
                    GlobalStrings.setGlobalString("");
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }
}
