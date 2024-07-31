import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/utils/api_config.dart';

class ApplyLoan extends StatefulWidget {
  const ApplyLoan({super.key});

  @override
  State<ApplyLoan> createState() => _ApplyLoanState();
}

class MemberData {
  final String userId;
  final String fullName;
  final String gender;
  final String proxy;
  final String round;
  final String maxAmount;

  MemberData(
      {required this.userId,
      required this.fullName,
      required this.maxAmount,
      required this.round,
      required this.proxy,
      required this.gender});
}

class LoanReasonData {
  final String loanReasonId;
  final String title;
  final String loanDescription;

  LoanReasonData(
      {required this.loanReasonId,
      required this.title,
      required this.loanDescription});
}

class _ApplyLoanState extends State<ApplyLoan> {
  var selectedUser = MemberData(
      userId: "",
      fullName: "",
      maxAmount: "",
      round: "",
      proxy: "",
      gender: "");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController loanAmountController = new TextEditingController();
  String? loanDescController;
  // TextEditingController loanInterestController = new TextEditingController();
  TextEditingController repaymentPlanController = new TextEditingController();
  late String selectedPlan;
  List<MemberData> allMembers = [];
  String? selectedMember;
  MemberData? maxAmount;
  String? selectedAmount;
  var loading = false;
  void onChanged(String? value) {
    // print(value);
    setState(() {
      selectedMember = value;
    });
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required'.tr;
    }
    return null;
  }

  String? _validateAmountField(String? value) {
    if (double.parse(value!) > double.parse(maxAmount!.maxAmount)) {
      return '${"Your maximum loan amount is".tr} ${maxAmount!.maxAmount}';
    } else if (value.isEmpty) {
      return 'This field is required'.tr;
    }
    return null;
  }

  List<LoanReasonData> newLoanReasons = [];

  @override
  void initState() {
    super.initState();
    fetchMembersRound();
    fetchLoanReasons();
  }

  Future<void> apply() async {
    // print(pnumber);
    if (selectedMember == null) {
      var message = 'please select a member'.tr;
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(msg: message, fontSize: 18);
      });
    } else if (loanAmountController.text == "") {
      var message = 'please enter a loan amount'.tr;
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(msg: message, fontSize: 18);
      });
    } else if (double.parse(loanAmountController.text) >
        double.parse(maxAmount!.maxAmount)) {
      var message =
          '${"Your maximum loan amount is".tr} ${maxAmount!.maxAmount}';
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(msg: message, fontSize: 18);
      });
    } else if (loanDescController == null) {
      var message = 'Please enter a description'.tr;
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(msg: message, fontSize: 18);
      });
    } else if (selectedPlan.isEmpty) {
      var message = 'please select a plan'.tr;
      Future.delayed(const Duration(milliseconds: 100), () {
        Fluttertoast.showToast(msg: message, fontSize: 18);
      });
    } else {
      setState(() {
        loading = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final body = {
        "amount": loanAmountController.text,
        // "interest": double.parse(loanInterestController.text) / 100,
        "description": loanDescController.toString(),
        "days": int.parse(selectedPlan)
      };
      print(body);
      try {
        var response = await http.post(
          Uri.https(baseUrl, "api/v1/Loan/Add/$selectedMember"),
          headers: <String, String>{
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(body),
        );
        // print("here" + "${response.statusCode}");
        print(response.body);
        if (response.statusCode == 200) {
          setState(() {
            loading = false;
            loanAmountController.clear();
            loanDescController = "";
            Navigator.pop(context, true);
            // loanInterestController.clear();
            // selectedMember = "";
            // selectedPlan = "";
          });
          var message = 'Loan applied successfully'.tr;
          Future.delayed(const Duration(milliseconds: 100), () {
            Fluttertoast.showToast(msg: message, fontSize: 18);
          });

          // ignore: use_build_context_synchronously

          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => const Otp()));
          setState(() {
            loading = false;
          });
        } else if (response.statusCode != 200) {
          final responseBody = json.decode(response.body);
          final description =
              responseBody?['message']; // Extract 'description' field
          if (description == "Phone number is already taken") {
            Fluttertoast.showToast(
                msg: "This phone number is already registered", fontSize: 18);
          } else {
            var message =
                description ?? "Something went wrong, please try again".tr;
            Fluttertoast.showToast(msg: message, fontSize: 18);
          }
          setState(() {
            loading = false;
          });
        }
      } catch (e) {
        var message = e.toString();
        'Something went wrong, please Check your network connection'.tr;
        Fluttertoast.showToast(msg: message, fontSize: 18);
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loanAmount = Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (value) {},
        validator: _validateAmountField,
        controller: loanAmountController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFFF89520)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFFF89520)),
          ),
          labelText: "Loan Amount".tr,
          labelStyle: GoogleFonts.poppins(
            fontSize: 14,
          ),
        ),
      ),
    );
    final loanDescription = Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: DropdownButtonFormField<String>(
              hint: Text(
                "Loan Description".tr,
                style: GoogleFonts.poppins(),
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(12, 10.0, 12.0, 10.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 208, 208, 208)),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              // value: loanDes, // Initially selected value (can be null)
              onChanged: (value) {
                setState(() {
                  loanDescController = value;
                  // maxAmount = allMembers.firstWhere(
                  //   (member) => member.userId == selectedMember,
                  // );
                });
              }, // Function to handle value changes

              items: newLoanReasons.map((LoanReasonData reason) {
                return DropdownMenuItem<String>(
                  value: reason.loanReasonId.toString(),
                  child: Text(
                    reason.loanDescription,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                );
              }).toList(),
            )),
      ),
    );
    // final loanInterest = Padding(
    //   padding: const EdgeInsets.all(16),
    //   child: TextFormField(
    //     keyboardType: TextInputType.number,
    //     validator: _validateField,
    //     controller: loanInterestController,
    //     decoration: InputDecoration(
    //       contentPadding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
    //       enabledBorder: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(10.0),
    //         borderSide: BorderSide(color: Color(0xFFF89520)),
    //       ),
    //       focusedBorder: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(10.0),
    //         borderSide: BorderSide(color: Color(0xFFF89520)),
    //       ),
    //       labelText: "Loan Interest % *",
    //       labelStyle: GoogleFonts.poppins(
    //         fontSize: 14,
    //       ),
    //     ),
    //   ),
    // );
    final repaymentPlan = Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<String>(
        validator: _validateField,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
          labelText: "Repayment plan".tr,
          // hintText: "Choose zone/subcity",
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
          hintStyle:
              GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFFF89520)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFFF89520)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFFF89520)),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
        items: [
          DropdownMenuItem<String>(
            value: "7",
            child: Center(
              child: Text('1 Week'.tr,
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            ),
          ),
          DropdownMenuItem<String>(
            value: "14",
            child: Center(
              child: Text('2 Weeks'.tr,
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            ),
          ),
          DropdownMenuItem<String>(
            value: "30",
            child: Center(
              child: Text('1 Month'.tr,
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            ),
          ),
          DropdownMenuItem<String>(
            value: "45",
            child: Center(
              child: Text('45 Days'.tr,
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            ),
          ),
          DropdownMenuItem<String>(
            value: "60",
            child: Center(
              child: Text('2 Months'.tr,
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            ),
          ),
          DropdownMenuItem<String>(
            value: "90",
            child: Center(
              child: Text('3 Months'.tr,
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedPlan = value!;
          });
        },
        //   hint: Text("Select zone",
        //       style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFFF89520))),
      ),
    );
    final fullName = Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: DropdownButtonFormField<String>(
              hint: Text(
                "Member".tr,
                style: GoogleFonts.poppins(),
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(12, 10.0, 12.0, 10.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 208, 208, 208)),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              value: selectedMember, // Initially selected value (can be null)
              onChanged: (value) {
                setState(() {
                  selectedMember = value;
                  maxAmount = allMembers.firstWhere(
                    (member) => member.userId == selectedMember,
                  );
                  print(maxAmount!.maxAmount);
                });
              }, // Function to handle value changes

              items: allMembers.map((MemberData members) {
                return DropdownMenuItem<String>(
                  value: members.userId.toString(),
                  child: Text(
                    members.fullName,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                );
              }).toList(),
            )),
      ),
    );
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        // backgroundColor: Colors.black,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          child: const Icon(Icons.arrow_back_ios_new_sharp)),
                      Image(
                          height: MediaQuery.of(context).size.height * 0.05,
                          image: const AssetImage("assets/images/vsla.png"))
                    ],
                  ),
                ),
                fullName,
                Row(
                  children: [
                    Expanded(
                      child: loanAmount,
                    ),
                    // const SizedBox(
                    //   width:
                    //       1.0, // Adjust this value as needed for the gap between the widgets
                    // ),
                    // Expanded(
                    //   child: loanInterest,
                    // ),
                  ],
                ),
                loanDescription,
                Row(
                  children: [
                    Expanded(
                      child: repaymentPlan,
                    ),
                    const SizedBox(
                      width:
                          1.0, // Adjust this value as needed for the gap between the widgets
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
                loading
                    ? CircularProgressIndicator(
                        color: Colors.orange,
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.068,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                side: BorderSide.none,
                                shape: const StadiumBorder()),
                            onPressed: () async {
                              await apply();
                            },
                            child: Text(
                              "Apply for Loan".tr,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ))),
              ])),
        )),
      ),
    );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    // Attempt to pop the current route
    Navigator.pop(context, true);

    // Return true if the route was popped, or false otherwise
    return true;
  }

  Future<void> fetchMembersRound() async {
    try {
      setState(() {
        loading = true;
      });
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String groupId = accessToken[2];

      final response = await http.get(
        Uri.https(
            baseUrl, '/api/v1/groups/$groupId/constributors/roundPayment'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      // final json = "[" + response.body + "]";
      var data = jsonDecode(response.body);

      List<MemberData> newMember = [];
      for (var member in data) {
        newMember.add(MemberData(
          round: member['round'],
          maxAmount: member['maxAmount'],
          proxy: member['proxy'],
          userId: member['userId'],
          fullName: member['fullName'],
          gender: member['gender'],
        ));
      }

      allMembers.clear();
      allMembers.addAll(newMember);
      print(allMembers.length);
      print("hereee");

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      var message =
          'Something went wrong, please Check your network connection'.tr;
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  Future<void> fetchLoanReasons() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final response = await http.get(
        Uri.https(baseUrl, '/api/v1/loanReason/getAll'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = jsonDecode(response.body);

      // print(data);
      newLoanReasons.clear();
      List<LoanReasonData> allreason = [];
      for (var reason in data) {
        allreason.add(LoanReasonData(
            loanReasonId: reason['loanReasonId'].toString(),
            title: reason['title'],
            loanDescription: reason['loanDescription']));
      }
      newLoanReasons.addAll(allreason);
      print(newLoanReasons.length);
    } catch (e) {
      print(e.toString());
      var message =
          'Something went wrong, please Check your network connection';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }
}
