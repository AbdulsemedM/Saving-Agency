import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vsla/Pages/inner/meeting_tabs/active.dart';
import 'package:vsla/utils/api_config.dart';
import 'package:vsla/utils/role.dart';

class InactiveMeeting extends StatefulWidget {
  const InactiveMeeting({super.key});

  @override
  State<InactiveMeeting> createState() => _InactiveMeetingState();
}

class _InactiveMeetingState extends State<InactiveMeeting> {
  TextEditingController currentRound = new TextEditingController();
  // TextEditingController meetingReason = new TextEditingController();
  String? meeetingType;
  String? meetingInterval;
  String? meeetingTypeId;
  String? meetingIntervalId;
  String? nextMeetingDate;
  String? intervalDays;
  final GlobalKey<FormState> myKey = GlobalKey();
  List<MeetingTypeData> meetingTypes = [];
  List<MeetingIntevalData> meetingIntervals = [];
  var loading = false;
  List<MeetingData> newMeeting = [];
  bool? done;
  bool? done2;
  final PageController _pageController = PageController();
  void initState() {
    super.initState();
    fetchMeetings();
    fetchMeetingTypes();
    fetchMeetingIntervals();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const SizedBox(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            ),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width * 1,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemCount: newMeeting.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () async {
                    await activateMeeting(newMeeting[index].meetingId,
                        newMeeting[index].currentRound);
                  },
                  onTap: GlobalStrings.getGlobalString() == 'GROUP_ADMIN'
                      ? () {
                          print(newMeeting[index].meetingTypeId);
                          editModal(newMeeting[index]);
                        }
                      : null,
                  child: Card(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.13,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            newMeeting[index].meetingType,
                                            style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${truncateText(
                                              newMeeting[index]
                                                  .intervalDays
                                                  .toString(),
                                              20, // Set the maximum length you want before truncating
                                            )} Days',
                                            style: GoogleFonts.roboto(
                                                color: Colors.black),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Next Meeting Day",
                                            style: GoogleFonts.poppins(
                                                color: Colors.orange[900])),
                                      ),
                                      Text(
                                        DateFormat('dd MMM, HH:mm').format(
                                            DateTime.parse(newMeeting[index]
                                                .nextMeetingDate)),
                                        style: GoogleFonts.roboto(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await activateMeeting(
                                    newMeeting[index].meetingId,
                                    newMeeting[index].currentRound);
                                // if (done2) {}
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_box_outlined),
                                  Text("Activate")
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                );
              },
            ),
          );
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + '...';
    }
  }

  Future<void> fetchMeetings() async {
    try {
      // var user = await SimplePreferences().getUser();
      setState(() {
        loading = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String groupId = accessToken[2];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/meetings/getInActiveMeetings/$groupId'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      // print(data);
      setState(() {
        newMeeting.clear();
        for (var meeting in data) {
          newMeeting.add(MeetingData(
              meetingId: meeting['meetingId'],
              currentRound: meeting['currentRound'],
              // meetingReason: meeting['meetingReason'],
              meetingType: meeting['meetingType'],
              meetingTypeId: meeting['meetingTypeId'],
              intervalDays: meeting['intervalDays'],
              meetingInterval: meeting['meetingInterval'],
              meetingIntervalId: meeting['meetingIntervalId'],
              nextMeetingDate: meeting['nextMeetingDate']));
        }
        loading = false;
      });

      print(newMeeting.length);

      // print(transactions[0]);
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      var message =
          'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  Future<void> fetchMeetingTypes() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/meeting-types/getAll/App'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      print(data);
      List<MeetingTypeData> newMeeting = [];

      for (var meet in data) {
        // print(transaction.date);
        var meetings = MeetingTypeData(
            meetingTypeId: meet['meetingTypeId'].toString(),
            meetingTypeName: meet['meetingTypeName']);
        newMeeting.add(meetings);
        // print(company);
      }
      meetingTypes.addAll(newMeeting);
      print("meetingTypes");
      print(meetingTypes.length);

      // print(transactions[0]);

      // setState(() {
      //   loading = false;
      // }
      // );
    } catch (e) {
      print(e.toString());
      var message =
          'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  Future<void> fetchMeetingIntervals() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final client = createIOClient();

      final response = await client.get(
        Uri.https(baseUrl, '/api/v1/meeting-intervals/getAll/App'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      var data = jsonDecode(response.body);

      print(data);
      List<MeetingIntevalData> newMeeting = [];

      for (var meet in data) {
        // print(transaction.date);
        var meetings = MeetingIntevalData(
            meetingIntervalId: meet['meetingIntervalId'].toString(),
            meetingIntervalName: meet['meetingIntervalName'],
            intervalInDays: meet['intervalInDays']);
        newMeeting.add(meetings);
        // print(company);
      }
      meetingIntervals.addAll(newMeeting);
      print("meetingInterval");
      print(meetingIntervals.length);

      // print(transactions[0]);

      // setState(() {
      //   loading = false;
      // }
      // );
    } catch (e) {
      print(e.toString());
      var message =
          'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }

  void editModal(MeetingData allMeeting) {
    String? _validateField(String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      return null;
    }

    currentRound.text = allMeeting.currentRound;
    // meetingReason.text = allMeeting.meetingReason;
    nextMeetingDate = DateFormat("MMMM d, y")
        .format(DateTime.parse(allMeeting.nextMeetingDate));
    meetingIntervalId = allMeeting.meetingIntervalId;
    meeetingTypeId = allMeeting.meetingTypeId;
    meeetingType = allMeeting.meetingType;
    meetingInterval = allMeeting.meetingInterval;
    intervalDays = allMeeting.intervalDays;
    print(meeetingTypeId);
    showDialog(
      context: context, // Pass the BuildContext to showDialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Meeting'), // Set your dialog title
          // content: Text(allMeeting.fullName), // Set your dialog content
          content: Form(
              key: myKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: DropdownButtonFormField<String>(
                          value: meeetingTypeId,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                                12.0, 10.0, 12.0, 10.0),
                            labelText: "Meeting Type*",
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
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFFF89520)),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          items: meetingTypes.map((MeetingTypeData meetTs) {
                            return DropdownMenuItem<String>(
                              value: meetTs.meetingTypeId.toString(),
                              child: Text(
                                meetTs.meetingTypeName,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              meeetingTypeId = value;
                              MeetingTypeData selectedMeetingType =
                                  meetingTypes.firstWhere((meetTs) =>
                                      meetTs.meetingTypeId.toString() == value);
                              meeetingType =
                                  selectedMeetingType.meetingTypeName;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Meeting type is required.";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8),
                    //   child: TextFormField(
                    //     // initialValue: allMeeting.meetingReason,
                    //     validator: (value) {
                    //       if (value == null) {
                    //         return null;
                    //       } else {
                    //         return null;
                    //       }
                    //     },
                    //     controller: meetingReason,
                    //     decoration: InputDecoration(
                    //       contentPadding:
                    //           EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //         borderSide: BorderSide(color: Color(0xFFF89520)),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //         borderSide: BorderSide(color: Color(0xFFF89520)),
                    //       ),
                    //       labelText: "Meeting Reason",
                    //       labelStyle: GoogleFonts.poppins(
                    //         fontSize: 14,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: DropdownButtonFormField<String>(
                          value: meetingIntervalId,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                                12.0, 10.0, 12.0, 10.0),
                            labelText: "Meeting Interval*",
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
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFFF89520)),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          items:
                              meetingIntervals.map((MeetingIntevalData meetIs) {
                            return DropdownMenuItem<String>(
                              value: meetIs.meetingIntervalId.toString(),
                              child: Text(
                                meetIs.meetingIntervalName,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              meetingIntervalId = value;
                              MeetingIntevalData selectedMeetingInterval =
                                  meetingIntervals.firstWhere((meetIs) =>
                                      meetIs.meetingIntervalId.toString() ==
                                      value);
                              intervalDays = selectedMeetingInterval
                                  .intervalInDays
                                  .toString();
                              meetingInterval =
                                  selectedMeetingInterval.meetingIntervalName;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Meeting inteval is required.";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DateTimeFormField(
                        firstDate: DateTime.now(),
                        // initialDate: DateTime.parse(nextMeetingDate!),
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
                          // labelText: "Next Meeting Date *",
                          labelStyle: GoogleFonts.poppins(
                              fontSize: 14, color: Color(0xFFF89520)),
                          hintText: "$nextMeetingDate",
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        validator: (value) {
                          if (value == null && nextMeetingDate == null) {
                            return "Next date is required.";
                          } else {
                            nextMeetingDate = allMeeting.nextMeetingDate;
                            return null;
                          }
                        },
                        onDateSelected: (DateTime value) {
                          // Format the selected date as a string
                          nextMeetingDate =
                              DateFormat('yyyy-MM-dd').format(value);
                          print(
                              'Selected date: $nextMeetingDate'); // Output: 2023-11-17
                          // Handle the formatted date as needed
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        // initialValue: allMeeting.currentRound,
                        controller: currentRound,
                        validator: (value) {
                          if (value == null) {
                            return null;
                          } else {
                            return null;
                          }
                        },
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
                          labelText: "Current Round*",
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(false); // User does not confirm deletion
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await apply();
                            if (done == true) {
                              Navigator.of(context)
                                  .pop(true); // User confirms deletion
                            } else {
                              const message =
                                  'Please check your network connection';
                              Fluttertoast.showToast(
                                  msg: message, fontSize: 18);
                            }
                          },
                          child: const Text('Edit'),
                        ),
                        // TextButton(
                        //   onPressed: () async {
                        //     await activateMeeting(
                        //         allMeeting.meetingId, allMeeting.currentRound);
                        //     if (done == true) {
                        //       Navigator.of(context)
                        //           .pop(true); // User confirms deletion
                        //     } else {
                        //       const message =
                        //           'Please check your network connection';
                        //       Fluttertoast.showToast(
                        //           msg: message, fontSize: 18);
                        //     }
                        //   },
                        //   child: const Text('Activate'),
                        // ),
                      ],
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  Future<void> apply() async {
    // print("mybodyyyyy");
    if (myKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];
      final String groupId = accessToken[2];
      final body = {
        "currentRound": int.parse(currentRound.text),
        "nextMeetingDate": DateFormat("yyyy-MM-ddTHH:mm:ss")
            .format(DateTime.parse(nextMeetingDate!)),
        "meetingInterval": meetingInterval,
        "meetingIntervalId": meetingIntervalId,
        "intervalDays": intervalDays,
        "meetingType": meeetingType,
        "meetingTypeId": meeetingTypeId,
        // "meetingReason": meetingReason.text,
        "group": {"groupId": groupId}
      };
      print("mybodyyyyy");
      print(body);
      try {
        final client = createIOClient();

        var response = await client.put(
          Uri.https(baseUrl, "/api/v1/editMeeting/$groupId"),
          headers: <String, String>{
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(body),
        );
        // print("here" + "${response.statusCode}");
        // print(response.body);
        if (response.statusCode == 200) {
          setState(() {
            loading = false;
            done = true;
            // currentRound.clear();
            // loanDescController.clear();
            // loanInterestController.clear();
            // selectedMember = "";
            // selectedPlan = "";
          });
          const message = 'Meeting created successfully';
          Future.delayed(const Duration(milliseconds: 100), () {
            Fluttertoast.showToast(msg: message, fontSize: 18);
          });

          // ignore: use_build_context_synchronously

          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => const Otp()));
          setState(() {
            loading = false;
          });
        } else if (response.statusCode != 201) {
          final responseBody = json.decode(response.body);
          final description =
              responseBody?['message']; // Extract 'description' field
          if (description == "Something went wron, please try again") {
            Fluttertoast.showToast(
                msg: "Something went wron, please try again", fontSize: 18);
          } else {
            var message =
                description ?? "Something went wrong, please try again";
            Fluttertoast.showToast(msg: message, fontSize: 18);
          }
          setState(() {
            loading = false;
          });
        }
      } catch (e) {
        var message = e.toString();
        print(e.toString());
        'Please check your network connection';
        Fluttertoast.showToast(msg: message, fontSize: 18);
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> activateMeeting(String meetingId, String round) async {
    print(meetingId);
    setState(() {
      loading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getStringList("_keyUser");
    final String authToken = accessToken![0];
    // final String groupId = accessToken[2];

    try {
      final client = createIOClient();

      var response = await client.put(
        Uri.https(baseUrl, "api/v1/meetings/continueMeeting/$meetingId/$round"),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          // fetchMeetings();
          // done2 = true;
        });
        const message = 'Meeting activated successfully';
        Future.delayed(const Duration(milliseconds: 100), () {
          Fluttertoast.showToast(msg: message, fontSize: 18);
        });

        // ignore: use_build_context_synchronously

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => const Otp()));
        setState(() {
          loading = false;
        });
      } else if (response.statusCode != 201) {
        final responseBody = json.decode(response.body);
        final description =
            responseBody?['message']; // Extract 'description' field
        if (description == "Something went wrong, please try again") {
          Fluttertoast.showToast(
              msg: "Something went wron, please try again", fontSize: 18);
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
      'Please check your network connection';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
