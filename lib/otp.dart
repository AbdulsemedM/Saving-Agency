import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/login.dart';
import 'package:vsla/utils/api_config.dart';
import 'package:http/http.dart' as http;

class Otp extends StatefulWidget {
  final String pNumber;
  final String fullname;
  final String password;
  final String organization;
  final String gender;
  const Otp(
      {required this.pNumber,
      required this.fullname,
      required this.gender,
      required this.organization,
      required this.password,
      super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  var loading = false;
  String? otpNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios_new_sharp)),
                  Image(
                      height: MediaQuery.of(context).size.height * 0.05,
                      image: const AssetImage("assets/images/vsla.png"))
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Image(image: AssetImage("assets/images/otp.png")),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
                child: Text(
              "OTP Verification",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "We will send you a one time passowrd to",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "+251 - ${widget.pNumber}",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            OtpTextField(
              borderRadius: const BorderRadius.all(Radius.circular(300)),
              cursorColor: const Color(0xFFF89520),
              focusedBorderColor: const Color(0xFFF89520),
              disabledBorderColor: const Color(0xFFF89520),
              enabledBorderColor: const Color(0xFFF89520),
              numberOfFields: 5,
              borderColor: const Color(0xFFF89520),
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {},
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                setState(() {
                  otpNumber = verificationCode;
                });
                print(otpNumber);
              }, // end onSubmit
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            loading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        if (otpNumber!.isNotEmpty && otpNumber!.length == 5) {
                          apply();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFF89520), // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "Send",
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.white),
                      ), // Button text
                    ),
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      )),
    );
  }

  Future<void> apply() async {
    print("mybodyyyyy");
    setState(() {
      loading = true;
    });
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // var accessToken = prefs.getStringList("_keyUser");
    // final String authToken = accessToken![0];
    var body2 = {"code": otpNumber};
    print(body2);
    try {
      print(widget.pNumber);
      final client = createIOClient();

      var response = await client.post(
          Uri.https(baseUrl, "/api/v1/otp/verify/${widget.pNumber}"),
          headers: <String, String>{
            // 'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(body2));
      print(response.body);
      if (response.statusCode == 200) {
        /////////////////////////////////////////////////////
        final body = {
          "phoneNumber": widget.pNumber,
          "password": widget.password,
          "fullName": widget.fullname,
          "roleName": "GROUP_ADMIN",
          "organizationId": widget.organization,
          "gender": widget.gender,
          "proxyEnabled": false,
          // "vslaRole": ""
        };
        print(body);
        try {
          final client = createIOClient();

          var response = await client.post(
            Uri.https(baseUrl, "api/v1/users"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(body),
          );
          // print("here" + "${response.statusCode}");
          print(response.body);
          if (response.statusCode == 201) {
            const message = 'Account Created Successfuly!';
            Future.delayed(const Duration(milliseconds: 100), () {
              Fluttertoast.showToast(msg: message, fontSize: 18);
            });
            // ignore: use_build_context_synchronously

            setState(() {
              loading = false;
            });
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Login()));
          } else if (response.statusCode != 201) {
            final responseBody = json.decode(response.body);
            final description =
                responseBody?['message']; // Extract 'description' field
            if (description == "Phone number is already taken") {
              Fluttertoast.showToast(
                  msg: "This phone number is already registered", fontSize: 18);
            } else {
              var message =
                  description ?? "Account creation failed please try again";
              Fluttertoast.showToast(msg: message, fontSize: 18);
            }
            setState(() {
              loading = false;
            });
          }
        } catch (e) {
          var message = e.toString();
          'Please check your network connection';
          Fluttertoast.showToast(msg: message, fontSize: 18);
        } finally {
          setState(() {
            loading = false;
          });
        }
        ////////////////////////////////////////////////////
        setState(() {
          loading = false;
        });

        const message = 'Otp verified successfully';
        Future.delayed(const Duration(milliseconds: 100), () {
          Fluttertoast.showToast(msg: message, fontSize: 18);
        });

        setState(() {
          loading = false;
        });
      } else if (response.statusCode != 200) {
        final responseBody = json.decode(response.body);
        final description =
            responseBody?['message']; // Extract 'description' field
        print(description);
        if (description == "Something went wrong, please try again") {
          Fluttertoast.showToast(
              msg: "Something went wrong, please try again", fontSize: 18);
        } else {
          var message = description ?? "Something went wrong, please try again";
          Fluttertoast.showToast(msg: message, fontSize: 18);
        }
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      var message = e.toString();
      print(e.toString());
      // 'Please check your network connection';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
