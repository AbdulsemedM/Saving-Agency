import 'dart:convert';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vsla/otp.dart';
import 'package:http/http.dart' as http;
import 'package:vsla/utils/api_config.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class CompanyData {
  final int companyId;
  final String companyName;

  CompanyData({
    required this.companyId,
    required this.companyName,
  });
}

class _SignupState extends State<Signup> {
  // FocusNode phoneFocus = FocusNode();
  late SingleValueDropDownController _cnt;
  List<CompanyData> company = [];
  String? selectedCompany;
  String? selectedGender;

// Function to handle dropdown value changes
  void onChanged(String? value) {
    // print(value);
    setState(() {
      selectedCompany = value;
    });
  }

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    super.initState();
    fetchCompany();
  }

  @override
  void dispose() {
    _cnt.dispose();
    super.dispose();
  }

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController pnumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  bool _passwordVisible1 = false;
  bool _passwordVisible = false;
  bool loading = false;
  var regExp1 = RegExp(r'^09\d{8}$');
  var regExp2 = RegExp(r'^2519\d{8}$');
  var regExp3 = RegExp(r'^\+2519\d{8}$');

  signup() async {
    // print(pnumber);
    if (fname.text.isEmpty) {
      var message = 'First name is mandatory'.tr;
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(msg: message, fontSize: 18);
      });
    } else if (lname.text.isEmpty) {
      var message = 'Last name is mandatory'.tr;
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(msg: message, fontSize: 18);
      });
    } else if (!(regExp1.hasMatch(pnumber.text) ||
        regExp3.hasMatch(pnumber.text) ||
        regExp2.hasMatch(pnumber.text))) {
      var message = 'Invalid phone number format'.tr;
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(msg: message, fontSize: 18);
      });
    } else if (password.text != cpassword.text || password.text.length < 6) {
      var message = 'Invalid password'.tr;
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(msg: message, fontSize: 18);
      });
    } else if (isChecked == false) {
      var message = 'Please agree with our policy and terms'.tr;
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(msg: message, fontSize: 18);
      });
    } else if (selectedGender!.isEmpty) {
      var message = 'Gender is a mandatory field'.tr;
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(msg: message, fontSize: 18);
      });
    } else {
      setState(() {
        loading = true;
      });
      String num = pnumber.text.substring(pnumber.text.length - 9);
      var body2 = {"phoneNumber": num};
      print(body2);
      final client = createIOClient();

      var otp = await client.post(
        Uri.https(baseUrl, "api/v1/otp/send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body2),
      );
      print(otp.body);
      if (otp.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Otp(
                      pNumber: num,
                      fullname: "${fname.text} ${lname.text}",
                      gender: selectedGender!,
                      organization: selectedCompany!,
                      password: password.text,
                    )));
      } else {
        Fluttertoast.showToast(
            msg: "Something went wrong, please try again", fontSize: 18);
      }
    }
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double fontSize = screenWidth * 0.07;
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
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Text(
              "Create your account".tr,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.07,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Text(
                      "First Name".tr,
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: fname,
                          // focusNode: phoneFocus,
                          // onTapOutside: (event) {
                          //   phoneFocus.unfocus();
                          // },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // prefixIcon: Icon(
                            //   Icons.phone_android,
                            // ),
                            hintText: "ex: John",
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
                  ),
                ],
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
                      "Last Name".tr,
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: lname,
                          // focusNode: phoneFocus,
                          // onTapOutside: (event) {
                          //   phoneFocus.unfocus();
                          // },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // prefixIcon: Icon(
                            //   Icons.phone_android,
                            // ),
                            hintText: "ex: Doe",
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
                  ),
                ],
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
                      "Select your Gender".tr,
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                          // labelText: "Zone/ Subcity *",
                          // hintText: "Choose zone/subcity",
                          labelStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 208, 208, 208)),
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 208, 208, 208)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 208, 208, 208)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Color(0xFFF89520)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Color(0xFFF89520)),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: "MALE",
                            child: Center(
                              child: Text('Male'.tr,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.black)),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "FEMALE",
                            child: Center(
                              child: Text('Female'.tr,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.black)),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                        // hint: Text("Select zone",
                        //     style: GoogleFonts.poppins(
                        //         fontSize: 14, color: Color(0xFFF89520))),
                      ),
                    ),
                  ),
                ],
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: pnumber,
                          // focusNode: phoneFocus,
                          // onTapOutside: (event) {
                          //   phoneFocus.unfocus();
                          // },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // prefixIcon: Icon(
                            //   Icons.phone_android,
                            // ),
                            hintText: "ex: 0987654321",
                            hintStyle:
                                GoogleFonts.poppins(color: Colors.grey[400]),
                          ),
                          // onChanged: (value) {
                          //   // Handle the phone number input here
                          //   print('Phone Number: $value');
                          // },
                        ),
                      ),
                    ),
                  ),
                ],
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
                        "Pin (Must be atleast 6 characters)".tr,
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            controller: password,
                            obscuringCharacter: "*",
                            // focusNode: pinFocus,
                            // onTapOutside: (event) {
                            //   pinFocus.unfocus();
                            // },
                            obscureText: !_passwordVisible,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "******",
                              hintStyle:
                                  GoogleFonts.poppins(color: Colors.grey[400]),
                              suffixIcon: IconButton(
                                // tooltip: "show password",
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
                            // onChanged: (value) {
                            //   // Handle the phone number input here
                            //   print('Phone Number: $value');
                            // },
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Text(
                        "Confirm Pin".tr,
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            controller: cpassword,
                            obscuringCharacter: "*",
                            // focusNode: pinFocus,
                            // onTapOutside: (event) {
                            //   pinFocus.unfocus();
                            // },
                            obscureText: !_passwordVisible1,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "******",
                              hintStyle:
                                  GoogleFonts.poppins(color: Colors.grey[400]),
                              suffixIcon: IconButton(
                                // tooltip: "show password",
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible1
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible1 = !_passwordVisible1;
                                  });
                                },
                              ),
                            ),
                            // onChanged: (value) {
                            //   // Handle the phone number input here
                            //   print('Phone Number: $value');
                            // },
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Text(
                        "Select an organization".tr,
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade50),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    12, 10.0, 12.0, 10.0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 208, 208, 208)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 208, 208, 208)),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFF89520)),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                              ),
                              value:
                                  selectedCompany, // Initially selected value (can be null)
                              onChanged:
                                  onChanged, // Function to handle value changes

                              items: company.map((CompanyData companies) {
                                return DropdownMenuItem<String>(
                                  value: companies.companyId.toString(),
                                  child: Text(
                                    companies.companyName,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            )),
                      ),
                    ),
                  ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  checkColor: Colors.black,
                  activeColor: Colors.grey[200],
                  value:
                      isChecked, // Use the variable to determine the checkbox state
                  onChanged: (value) {
                    setState(() {
                      // Use setState to rebuild the widget tree and update the UI
                      isChecked =
                          value!; // Update the state variable with the new checkbox state
                    });
                  },
                ),
                Text(
                  'I understood the terms and policies.'.tr,
                  style: TextStyle(fontSize: screenWidth * 0.045),
                ),
              ],
            ),
            loading
                ? const CircularProgressIndicator(
                    color: Colors.orange,
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.2,
                      vertical: MediaQuery.of(context).size.height * 0.015,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        signup();
                      },
                      child: Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.01),
                        decoration: BoxDecoration(
                          color: Colors.orange, // You can use your color here
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "SIGNUP".tr,
                            style: GoogleFonts.poppins(
                              color:
                                  Colors.white, // You can use your color here
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
            //     style:
            //         GoogleFonts.poppins(color: Colors.grey[500], fontSize: 15),
            //   ),
            // ),
            const SizedBox(
              height: 10,
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
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
                  child: RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Have an account?".tr,
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.grey[700])),
                    TextSpan(
                        text: " ",
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.grey[700])),
                    TextSpan(
                        text: "LOGIN".tr,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: const Color(0xFFF89520)))
                  ])),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> fetchCompany() async {
    try {
      // var user = await SimplePreferences().getUser();
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/organizations'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      print("hererewego");
      print(response.body);
      var data = jsonDecode(response.body);

      // print(data);
      List<CompanyData> newCompany = [];

      for (var comapany in data) {
        // print(transaction.date);
        var companyData = CompanyData(
          companyId: comapany['organizationId'],
          companyName: comapany['organizationName'],
        );
        newCompany.add(companyData);
        // print(company);
      }
      company.addAll(newCompany);
      // print(company.length);

      // print(transactions[0]);

      // setState(() {
      //   loading = false;
      // }
      // );
    } catch (e) {
      print(e.toString());
      var message =
          'Something went wrong. Please check your internet connection.'.tr;
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }
}
