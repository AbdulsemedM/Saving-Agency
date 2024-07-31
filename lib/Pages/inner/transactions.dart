import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/routes/home3.dart';
import 'package:http/http.dart' as http;
import 'package:vsla/utils/api_config.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class TransactionData {
  final String amount;
  final String name;
  final String? status;
  final String? gender;

  TransactionData({
    required this.amount,
    required this.name,
    required this.gender,
    required this.status,
  });
}

class _TransactionState extends State<Transaction> {
  final PageController _pageController = PageController();
  var loading = false;
  var loan = true;
  List<TransactionData> allTransactions = [];
  var roundPayment;
  var loanRepayment;
  var loanDespersal;
  var total;
  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    void valuechanged(value) {}
    var screenWidth = MediaQuery.of(context).size.width;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: <Widget>[
                        // Larger rectangle (blue)
                        Container(
                            width: screenWidth * 0.4,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                                color: Colors.green[400],
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    width: screenWidth * 0.15,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.18)),
                                    child: Center(
                                      child: Icon(
                                        FontAwesomeIcons.dollarSign,
                                        color: Colors.green[400],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 16),
                                  child: Text(
                                    "Saving".tr,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 10),
                                  child: Text(
                                    "${loading ? "0" : roundPayment} ETB",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
                        Positioned(
                          bottom: screenWidth * 0.2,
                          top: screenWidth * 0,
                          right: screenWidth * -0.03,
                          left: screenWidth * 0.2,
                          child: Container(
                            width: screenWidth * 0.08,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(100)),
                          ),
                        ),
                        Positioned(
                          bottom: screenWidth * 0.14,
                          top: screenWidth * 0.1,
                          right: screenWidth * -0.06,
                          left: screenWidth * 0.29,
                          child: Container(
                            width: screenWidth * 0.1,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration: BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.circular(100)),
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
                            width: screenWidth * 0.4,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    width: screenWidth * 0.15,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.18)),
                                    child: Center(
                                      child: Icon(
                                        FontAwesomeIcons.handHoldingDollar,
                                        color: Colors.red[400],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 16),
                                  child: Text(
                                    "Loan Despersal".tr,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 10),
                                  child: Text(
                                    "${loading ? "0" : loanDespersal} ETB",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
                        Positioned(
                          bottom: screenWidth * 0.2,
                          top: screenWidth * 0,
                          right: screenWidth * -0.03,
                          left: screenWidth * 0.2,
                          child: Container(
                            width: screenWidth * 0.08,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(100)),
                          ),
                        ),
                        Positioned(
                          bottom: screenWidth * 0.14,
                          top: screenWidth * 0.1,
                          right: screenWidth * -0.06,
                          left: screenWidth * 0.29,
                          child: Container(
                            width: screenWidth * 0.1,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration: BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.circular(100)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: <Widget>[
                        // Larger rectangle (blue)
                        Container(
                            width: screenWidth * 0.4,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                                color: Colors.amber[700],
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    width: screenWidth * 0.15,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.18)),
                                    child: Center(
                                      child: Icon(
                                        FontAwesomeIcons.handHoldingHand,
                                        color: Colors.amber[700],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 16),
                                  child: Text(
                                    "Loan Repayment".tr,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 10),
                                  child: Text(
                                    "${loading ? "0" : loanRepayment} ETB",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
                        Positioned(
                          bottom: screenWidth * 0.2,
                          top: screenWidth * 0,
                          right: screenWidth * -0.03,
                          left: screenWidth * 0.2,
                          child: Container(
                            width: screenWidth * 0.08,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(100)),
                          ),
                        ),
                        Positioned(
                          bottom: screenWidth * 0.14,
                          top: screenWidth * 0.1,
                          right: screenWidth * -0.06,
                          left: screenWidth * 0.29,
                          child: Container(
                            width: screenWidth * 0.1,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration: BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.circular(100)),
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
                            width: screenWidth * 0.4,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                                color: Colors.blue[400],
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    width: screenWidth * 0.15,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.18)),
                                    child: Center(
                                      child: Icon(
                                        FontAwesomeIcons.calculator,
                                        color: Colors.blue[400],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 16),
                                  child: Text(
                                    "Social Funds".tr,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 10),
                                  child: Text(
                                    "${loading ? "0" : total} ETB",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
                        Positioned(
                          bottom: screenWidth * 0.2,
                          top: screenWidth * 0,
                          right: screenWidth * -0.03,
                          left: screenWidth * 0.2,
                          child: Container(
                            width: screenWidth * 0.08,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(100)),
                          ),
                        ),
                        Positioned(
                          bottom: screenWidth * 0.14,
                          top: screenWidth * 0.1,
                          right: screenWidth * -0.06,
                          left: screenWidth * 0.29,
                          child: Container(
                            width: screenWidth * 0.1,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration: BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.circular(100)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(
                      "All Transactions".tr,
                      style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              loading
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.38,
                      width: MediaQuery.of(context).size.width * 1,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          controller: _pageController,
                          itemCount: allTransactions.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: screenWidth * 0.05,
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                  "assets/images/${allTransactions[index].gender?.toLowerCase() == "male" ? "male" : "female"}.png"),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          0, 00, 0, 8.0),
                                                      child: Text(
                                                        allTransactions[index]
                                                            .name,
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10, 0, 10, 0),
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                        width:
                                                            screenWidth * 0.25,
                                                        decoration: BoxDecoration(
                                                            color: allTransactions[
                                                                            index]
                                                                        .status
                                                                        .toString() ==
                                                                    "Recieved"
                                                                ? Colors
                                                                    .green[300]
                                                                : Colors.orange,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                FontAwesomeIcons
                                                                    .userPlus,
                                                                color: Colors
                                                                    .white,
                                                                size: 13,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                  allTransactions[
                                                                          index]
                                                                      .status
                                                                      .toString()
                                                                      .tr,
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              " ${allTransactions[index].amount} ETB",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.blue[400],
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                            );
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchTransactions() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String groupId = accessToken[2];
      print(groupId);

      final response = await http.get(
        Uri.https(baseUrl, '/api/v1/Transactions/getAllTransactions/$groupId'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      // print(data);
      List<TransactionData> newTransaction = [];
      for (var member in data['allTransactions']) {
        newTransaction.add(TransactionData(
          gender: member['gender'],
          amount: member['amount'],
          name: member['name'],
          status: member['status'],
        ));
      }

      setState(() {
        total = data['total'];
        roundPayment = data['roundPayment'];
        loanDespersal = data['loanDespersal'];
        loanRepayment = data['loanRepaymnet'];
      });
      allTransactions.addAll(newTransaction);
      print(allTransactions.length);

      // print(transactions[0]);

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e.toString());
      var message =
          'Something went wrong. Please check your internet connection'.tr;
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }
}
