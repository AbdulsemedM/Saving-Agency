import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/home1.dart';
import 'package:vsla/createGroup.dart';
import "package:http/http.dart" as http;
import 'package:vsla/signup.dart';
import 'package:vsla/utils/api_config.dart';
import 'package:vsla/utils/role.dart';
import 'package:vsla/utils/simplePreferences.dart';
// import 'package:vsla/utils/simplePreferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var groupId;
  bool _passwordVisible = false;
  bool loading = false;
  TextEditingController pnumber = TextEditingController();

  TextEditingController password = TextEditingController();
  FocusNode pinFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  var regExp1 = RegExp(r'^09\d{8}$');
  var regExp2 = RegExp(r'^2519\d{8}$');
  var regExp3 = RegExp(r'^\+2519\d{8}$');
  var registered = false;

  final List locale = [
    {'name': 'English', 'locale': Locale('en', 'US')},
    {'name': 'Afaan Oromoo', 'locale': Locale('or', 'ET')},
    {'name': 'አማርኛ', 'locale': Locale('am', 'ET')},
    // {'name': 'Somali', 'locale': Locale('en', 'US')},
  ];
  updateLanguage(Locale locale) async {
    Get.back();
    Get.updateLocale(locale);
  }

  buildLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.grey[200],
            title: Text('Choose Language'.tr),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Text(locale[index]['name']),
                        onTap: () async {
                          String selectedLocale = locale[index]['name'];
                          print(selectedLocale);
                          SimplePreferences preferences = SimplePreferences();
                          await preferences.setLanguage(selectedLocale);
                          print("here");
                          print(locale[index]['locale']);
                          updateLanguage(locale[index]['locale']);

                          // await prefs.setBool('repeat', true);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  login() async {
    // pnumber.text = "0912345678";
    // password.text = "123456";
    if (!(regExp1.hasMatch(pnumber.text) ||
        regExp3.hasMatch(pnumber.text) ||
        regExp2.hasMatch(pnumber.text))) {
      var message = 'Invalid phone number format'.tr;
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(msg: message, fontSize: 18);
      });
    } else if (password.text == "") {
      var message = 'Invalid password'.tr;
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(msg: message, fontSize: 18);
      });
    } else {
      setState(() {
        loading = true;
      });
      String num = pnumber.text.substring(pnumber.text.length - 9);
      final body = <String, String>{
        "username": num,
        "password": password.text.toString(),
      };
      // print(body);
      try {
        final response = await http
            .post(
              Uri.https(baseUrl, '/login'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 15));

        print(response.body);
        // print("here" + "${response.statusCode}");

        if (response.statusCode == 200) {
          // ignore: prefer_interpolation_to_compose_strings
          final json = "[" + response.body + "]";
          // List list = (jsonDecode(json) as List<dynamic>);
          List<Map<String, dynamic>> dataList =
              (jsonDecode(json) as List).cast<Map<String, dynamic>>();
          if (dataList.isNotEmpty) {
            Map<String, dynamic> data = dataList.first;
            String accessToken = data['access_token'];
            print(accessToken);
            Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
            print(decodedToken['role'][0]);
            String role = decodedToken['role'][0];
            dynamic subVal = decodedToken['sub']; // Access 'sub' field
            dynamic hasGroup = decodedToken['has-group'];
            dynamic groupID = decodedToken['groupId'];
            dynamic orgId = decodedToken['org_id'];
            if (hasGroup == "No") {
              setState(() {
                registered = false;
              });
            } else if (hasGroup == "Yes") {
              setState(() {
                registered = true;
              });
            }
            if (groupID != null) {
              groupId = groupID.toString();
              String sub = subVal.toString();
              List<String> newUser = [
                accessToken,
                sub,
                groupId,
                orgId.toString(),
                role
              ];
              GlobalStrings.setGlobalString(role);
              print(GlobalStrings.getGlobalString());
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.setStringList("_keyUser", newUser);
            } else {
              print(decodedToken);
              String sub = subVal.toString();
              List<String> newUser = [accessToken, sub, orgId.toString(), role];
              // print("object");
              // print(newUser);
              GlobalStrings.setGlobalString(role);
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              prefs.setStringList("_keyUser", newUser);
            }
          } else {
            // print('No data found in the response.');
          }

          setState(() {
            loading = false;
          });
          registered
              // ignore: use_build_context_synchronously
              ? Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home1()))
              // ignore: use_build_context_synchronously
              : Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const CreatGroup()));
          setState(() {
            loading = false;
          });
        } else if (response.statusCode != 200) {
          setState(() {
            loading = false;
          });
          var message = 'Invalid username or password!'.tr;
          Fluttertoast.showToast(msg: message, fontSize: 18);
        }
      } catch (e) {
        print(e.toString());
        var message =
            "Something went wrong, please Check your network connection".tr;

        // print(message);
        Fluttertoast.showToast(msg: message, fontSize: 18);
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  DateTime timeBackPressed = DateTime.now();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if (isExitWarning) {
          var message = 'press again to exit'.tr;
          Fluttertoast.showToast(msg: message, fontSize: 18);

          return false;
        } else {
          Fluttertoast.cancel();
          return exit(0);
        }
      },
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await buildLanguageDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "English".tr,
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 30)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: const Image(image: AssetImage("assets/images/vsla.png")),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Sign in to your account".tr,
                    style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Text(
                        "Phone Number".tr,
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: pnumber,
                          focusNode: phoneFocus,
                          onTapOutside: (event) {
                            phoneFocus.unfocus();
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: const Icon(
                              Icons.phone_android,
                            ),
                            hintText: "ex: 0987654321",
                            hintStyle:
                                GoogleFonts.poppins(color: Colors.grey[400]),
                          ),
                          onChanged: (value) {
                            // Handle the phone number input here
                            // print('Phone Number: $value');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Text(
                        "Pin".tr,
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: password,
                          obscuringCharacter: "*",
                          focusNode: pinFocus,
                          onTapOutside: (event) {
                            pinFocus.unfocus();
                          },
                          obscureText: !_passwordVisible,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                            hintText: "******",
                            hintStyle:
                                GoogleFonts.poppins(color: Colors.grey[400]),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            // Handle the phone number input here
                            // print('Phone Number: $value');
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                login();
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => const CreatGroup()));
                              },
                              child: Container(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height * 0.01),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .orange, // You can use your color here
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "LOGIN".tr,
                                    style: GoogleFonts.poppins(
                                      color: Colors
                                          .white, // You can use your color here
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    // Center(
                    //   child: Text(
                    //     "or sign in with",
                    //     style: GoogleFonts.poppins(
                    //         color: Colors.grey[500], fontSize: 15),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Container(
              //       height: MediaQuery.of(context).size.height * 0.06,
              //       width: MediaQuery.of(context).size.width * 0.15,
              //       decoration: BoxDecoration(
              //           color: Colors.grey[200],
              //           borderRadius: BorderRadius.circular(10)),
              //       child: const Image(
              //           image: AssetImage(
              //         "assets/images/google.png",
              //       )),
              //     ),
              //     Container(
              //       height: MediaQuery.of(context).size.height * 0.06,
              //       width: MediaQuery.of(context).size.width * 0.15,
              //       decoration: BoxDecoration(
              //           color: Colors.grey[200],
              //           borderRadius: BorderRadius.circular(10)),
              //       child: const Image(
              //           fit: BoxFit.contain,
              //           height: 60,
              //           width: 50,
              //           image: AssetImage(
              //             "assets/images/facebook.png",
              //           )),
              //     ),
              //     Container(
              //       height: MediaQuery.of(context).size.height * 0.06,
              //       width: MediaQuery.of(context).size.width * 0.15,
              //       decoration: BoxDecoration(
              //           color: Colors.grey[200],
              //           borderRadius: BorderRadius.circular(10)),
              //       child: const Image(
              //           image: AssetImage(
              //         "assets/images/twitter.png",
              //       )),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Signup()));
                  },
                  child: RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Don't have an account?".tr,
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.grey[700])),
                    TextSpan(
                        text: " ".tr,
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.grey[700])),
                    TextSpan(
                        text: "SIGNUP".tr,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: Colors.orange))
                  ])),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
