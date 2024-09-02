import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/utils/api_config.dart';
import 'package:http/http.dart' as http;

class PaidPenalties extends StatefulWidget {
  const PaidPenalties({super.key});

  @override
  State<PaidPenalties> createState() => _PaidPenaltiesState();
}

class GetPenalty {
  final String description;
  final String paidAmount;
  final String payer;
  GetPenalty(
      {required this.description,
      required this.paidAmount,
      required this.payer});
}

class _PaidPenaltiesState extends State<PaidPenalties> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMembers();
  }

  @override
  List<GetPenalty> myPenalties = [];
  final PageController _pageController = PageController();
  var loading = false;
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading == false && myPenalties.isEmpty
            ? const SizedBox(
                child: Center(
                  child: Text("No Penalties found"),
                ),
              )
            : loading
                ? const SizedBox(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.76,
                        width: MediaQuery.of(context).size.width * 1,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            controller: _pageController,
                            itemCount: myPenalties.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white,
                                surfaceTintColor: Colors.white,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(myPenalties[index].payer),
                                          Text(
                                              "Amount ${myPenalties[index].paidAmount}")
                                        ],
                                      ),
                                      Text(
                                          "Desc. ${myPenalties[index].description}")
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ));
  }

  Future<void> fetchMembers() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/Transactions/getPenalites'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      // print(data);
      List<GetPenalty> newPen = [];
      for (var pen in data) {
        newPen.add(GetPenalty(
          description: pen['description'],
          paidAmount: pen['paidAmount'].toString(),
          payer: pen['payer'].toString(),
        ));
      }
      myPenalties.clear();
      myPenalties.addAll(newPen);
      print(myPenalties.length);

      // print(transactions[0]);

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e.toString());
      var message =
          'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }
}
