import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vsla/Pages/inner/all_payments/disburse_social_fund.dart';
import 'package:vsla/Pages/inner/all_payments/penalty_payment.dart';
import 'package:vsla/Pages/inner/all_payments/round_payment.dart';
import 'package:vsla/Pages/inner/all_payments/social_funds.dart';
import 'package:vsla/Pages/routes/Total/expenditure.dart';
import 'package:vsla/Pages/routes/Total/report.dart';
import 'package:vsla/login.dart';
import 'package:vsla/utils/api_config.dart';
import 'package:vsla/utils/role.dart';

class Totals extends StatefulWidget {
  const Totals({Key? key}) : super(key: key);

  @override
  State<Totals> createState() => _TotalsState();
}

class _TotalsState extends State<Totals> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 0;
  bool isAttendanceFilled = false;

  final List<Tab> _tabs = const [
    Tab(text: "Report"),
    Tab(text: "Expenditure"),
  ];
  final List<Widget> _pages = const [
    TotalReports(),
    TotalExpenditures(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController!.addListener(
        _handleTabSelection); // Add listener to handle tab selection
    fetchAttendace();
  }

  Future<void> fetchAttendace() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getStringList("_keyUser");
    final String authToken = accessToken![0];
    final client = createIOClient();

    final response1 = await client.get(
      Uri.https(baseUrl, '/api/v1/Loan/isAttendaceFilled'),
      headers: <String, String>{
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    // transactions = parseTransactions(response.body);
    var data1 = jsonDecode(response1.body);
    setState(() {
      isAttendanceFilled = data1;
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _selectedIndex = _tabController!.index; // Update selected index variable
    });
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Confirm Exit"),
            content: Text("Do you want to Logout?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No")),
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
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    return Stack(
      children: [
        SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          child: const Icon(Icons.arrow_back_ios_new_sharp),
                        ),
                        Image(
                          height: MediaQuery.of(context).size.height * 0.05,
                          image: const AssetImage("assets/images/vsla.png"),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.orange,
                    labelColor: Colors.orange,
                    controller: _tabController,
                    tabs: _tabs,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  if (_selectedIndex == 1 &&
                      GlobalStrings.getGlobalString() == "GROUP_ADMIN")
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange),
                        onPressed: isAttendanceFilled
                            ? () async {
                                editModal();
                              }
                            : () {
                                var message = 'Please fill attendace first.';
                                Fluttertoast.showToast(
                                    msg: message, fontSize: 18);
                              },
                        child: Text(
                          "Pay-Expenditure",
                          style: TextStyle(color: Colors.black),
                        )),
                  SizedBox(
                    height: sHeight * 0.85,
                    child: TabBarView(
                      controller: _tabController,
                      children: _pages,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void editModal() {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController roundController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    var loading1 = false;

    // ignore: no_leading_underscores_for_local_identifiers
    String? _validateField(String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      return null;
    }

    showDialog(
      context: context, // Pass the BuildContext to showDialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Add expenditure Payment",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ), // Set your dialog title
          // content: Text(allMember.fullName), // Set your dialog content
          actions: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 2, 0, 8),
                    child: TextFormField(
                      controller: fullNameController,
                      validator: _validateField,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFF89520)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFF89520)),
                        ),
                        labelText: "Description",
                        labelStyle: GoogleFonts.poppins(
                            fontSize: 14, color: const Color(0xFFF89520)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: _validateField,
                      controller: amountController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFF89520)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFF89520)),
                        ),
                        labelText: "Amount *",
                        labelStyle: GoogleFonts.poppins(
                            fontSize: 14, color: const Color(0xFFF89520)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: TextFormField(
            //     readOnly: true,
            //     controller: roundController,
            //     decoration: InputDecoration(
            //       contentPadding:
            //           const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
            //       enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //         borderSide: const BorderSide(color: Color(0xFFF89520)),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //         borderSide: const BorderSide(color: Color(0xFFF89520)),
            //       ),
            //       labelText: "Round *",
            //       labelStyle: GoogleFonts.poppins(
            //           fontSize: 14, color: const Color(0xFFF89520)),
            //     ),
            //   ),
            // ),

            Row(
              children: [
                loading1
                    ? const CircularProgressIndicator(
                        color: Colors.orange,
                      )
                    : TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Payment'),
                                  content: Text(
                                      'Are you sure you want to add ${amountController.text} Birr to expenditures?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            false); // User does not confirm deletion
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // fetchMembersRound();
                                        Navigator.of(context).pop(
                                            true); // User confirms deletion
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirmDelete) {
                              setState(() {
                                loading1 = true;
                              });

                              // ignore: unnecessary_null_comparison
                              if (amountController.text == null) {
                                const message = 'Please enter an amount!';
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  Fluttertoast.showToast(
                                      msg: message, fontSize: 18);
                                });
                              } else {
                                try {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  var accessToken =
                                      prefs.getStringList("_keyUser");
                                  final String authToken = accessToken![0];
                                  final String groupId = accessToken[2];
                                  final body = {
                                    "groupId": groupId,
                                    "payerId": 0,
                                    "payementTypeId": 7,
                                    "amount": amountController.text,
                                    "round": 0,
                                    "description": fullNameController.text
                                  };
                                  print(body);
                                  final client = createIOClient();

                                  var response = await client.post(
                                    Uri.https(baseUrl,
                                        "/api/v1/Transactions/addTransaction"),
                                    headers: <String, String>{
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                      'Authorization': 'Bearer $authToken',
                                    },
                                    body: jsonEncode(body),
                                  );
                                  // print("here" + "${response.statusCode}");
                                  print(response.body);
                                  if (response.statusCode == 200) {
                                    setState(() {
                                      loading1 = false;
                                    });
                                    // fetchMembersRound();
                                    const message =
                                        'Payment added Successfuly!';
                                    Future.delayed(
                                        const Duration(milliseconds: 100), () {
                                      Fluttertoast.showToast(
                                          msg: message, fontSize: 18);
                                    });
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context)
                                        .pop(); // Close the dialog when the user presses the button
                                  } else if (response.statusCode != 200) {
                                    final responseBody =
                                        json.decode(response.body);
                                    final description = responseBody?[
                                        'message']; // Extract 'description' field
                                    if (description ==
                                        "Phone number is already taken") {
                                      Fluttertoast.showToast(
                                          msg:
                                              "This phone number is already registered",
                                          fontSize: 18);
                                    } else {
                                      var message = description ??
                                          "payment process failed; please try again";
                                      Fluttertoast.showToast(
                                          msg: message, fontSize: 18);
                                    }
                                    setState(() {
                                      loading1 = false;
                                    });
                                  }
                                } catch (e) {
                                  var message = e.toString();
                                  'Please check your network connection';
                                  Fluttertoast.showToast(
                                      msg: message, fontSize: 18);
                                } finally {
                                  setState(() {
                                    loading1 = false;
                                  });
                                }
                              }
                            }
                          }
                        },
                        child: loading1
                            ? CircularProgressIndicator()
                            : Text(
                                'Add',
                                style:
                                    GoogleFonts.poppins(color: Colors.orange),
                              ),
                      ),
              ],
            ),
          ],
        );
      },
    );
  }
}
