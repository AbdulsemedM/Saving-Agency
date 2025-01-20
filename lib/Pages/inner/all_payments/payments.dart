import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/inner/all_payments/attendance.dart';
import 'package:vsla/Pages/inner/all_payments/disburse_social_fund.dart';
import 'package:vsla/Pages/inner/all_payments/penalties.dart';
import 'package:vsla/Pages/inner/all_payments/penalty_payment.dart';
import 'package:vsla/Pages/inner/all_payments/round_payment.dart';
import 'package:vsla/Pages/inner/all_payments/social_funds.dart';
import 'package:vsla/Pages/inner/loan.dart';
import 'package:vsla/utils/api_config.dart';
import 'package:vsla/utils/role.dart';
// import 'package:http/http.dart' as http;

class Payments extends StatefulWidget {
  const Payments({Key? key}) : super(key: key);

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 0; // Variable to store the selected index
  bool isAttendanceFilled = false;

  final List<Tab> _tabs = [
    Tab(text: "Attendance".tr),
    Tab(text: "Saving".tr),
    Tab(text: "Social funds".tr),
    Tab(text: "Loans".tr),
    Tab(text: "Penalty payments".tr),
    Tab(text: "Penalties".tr),
  ];
  final List<Widget> _pages = const [
    Attendance(),
    RoundPayments(),
    SocialFundsPayment(),
    Loan(),
    PenaltyPayment(),
    PaidPenalties()
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController!.addListener(
        _handleTabSelection); // Add listener to handle tab selection
    fetchAttendace();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
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
      print("maybe error");
      isAttendanceFilled = data1;
    });
  }

  void _handleTabSelection() {
    setState(() {
      _selectedIndex = _tabController!.index; // Update selected index variable
    });
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
        return Future.value(false);
      },
      child: Scaffold(
        body: Stack(
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
                                Navigator.pop(context, true);
                              },
                              child: const Icon(Icons.arrow_back_ios_new_sharp),
                            ),
                            if (_selectedIndex == 2 &&
                                GlobalStrings.getGlobalString() ==
                                    "GROUP_ADMIN")
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange),
                                  onPressed: isAttendanceFilled
                                      ? () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const DisburseSocialFunds()));
                                        }
                                      : () {
                                          var message =
                                              'Please fill attendance before any payment'
                                                  .tr;
                                          Fluttertoast.showToast(
                                              msg: message, fontSize: 18);
                                        },
                                  child: Text(
                                    "Pay-Social Fund".tr,
                                    style: const TextStyle(color: Colors.black),
                                  )),
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
        ),
      ),
    );
  }
}
