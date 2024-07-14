// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/routes/home3.dart';
import 'package:vsla/login.dart';
import 'package:vsla/utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:vsla/utils/role.dart';
import 'package:vsla/utils/simplePreferences.dart';
// import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var loading = false;
  var groupName = "";
  var phoneNumber = "";
  List<ContributionData> allContribution = [];
  @override
  void initState() {
    super.initState();
    fetchDashBoardData();
  }

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
            title: Text('Choose Language'),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      _onBackButtonPressed(context);
                    },
                    child: const Icon(Icons.arrow_back_ios_new_sharp)),
                Image(
                    height: MediaQuery.of(context).size.height * 0.05,
                    image: const AssetImage("assets/images/vsla.png"))
              ],
            ),
          ),
          Stack(
            children: [
              CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.1,
                  child: Image(image: AssetImage("assets/images/group.png"))),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.08,
              //   height: MediaQuery.of(context).size.height * 0.04,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(
              //           MediaQuery.of(context).size.width * 0.08),
              //       color: Colors.grey[100]),
              //   child: const Icon(
              //     FontAwesomeIcons.pencil,
              //     color: Colors.black,
              //   ),
              // )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 8.0),
            child: loading
                ? CircularProgressIndicator()
                : Text(
                    groupName,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, fontSize: 30),
                  ),
          ),
          // SizedBox(
          //     height: MediaQuery.of(context).size.height * 0.068,
          //     width: MediaQuery.of(context).size.width * 0.5,
          //     child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //             backgroundColor: Colors.orange,
          //             side: BorderSide.none,
          //             shape: const StadiumBorder()),
          //         onPressed: () {},
          //         child: Text(
          //           "Edit profile",
          //           style: GoogleFonts.poppins(
          //               color: Colors.black, fontWeight: FontWeight.w700),
          //         ))),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 8, 15, 8.0),
            child: Divider(),
          ),
          myTiles(
            onPressed: () {},
            title: "Terms of service",
            icon: Icons.terminal_sharp,
          ),
          myTiles(
            onPressed: () {},
            title: "Privacy policy",
            icon: Icons.privacy_tip,
          ),
          myTiles(
            onPressed: () {
              buildLanguageDialog(context);
            },
            title: "Language",
            icon: FontAwesomeIcons.language,
          ),
          myTiles(
            onPressed: () {},
            title: "Help and support",
            icon: Icons.help,
          ),
          myTiles(
            onPressed: () {
              _onBackButtonPressed(context);
            },
            title: "Logout",
            icon: Icons.logout,
            textColor: Colors.red,
            endIcon: false,
          ),
        ],
      ),
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

  Future<void> fetchDashBoardData() async {
    try {
      // var user = await SimplePreferences().getUser();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getStringList("_keyUser");
      final String authToken = accessToken![0];

      final response = await http.get(
        Uri.https(baseUrl, '/api/v1/home-page'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // transactions = parseTransactions(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);
      // print(response.body);
      for (var recentContributions in data['recentContributions']) {
        allContribution.add(ContributionData(
          amount: recentContributions['amount'],
          contributor: recentContributions['contributor'],
          date: recentContributions['date'],
        ));
      }
      print("hereeeeee");
      print(allContribution.length);

      setState(() {
        groupName = data['groupName'];

        loading = false;
      });
      // print(mileStone);
    } catch (e) {
      var message = e.toString();
      'Something went wrong. Please check your internet connection.';
      Fluttertoast.showToast(msg: message, fontSize: 18);
    }
  }
}

class myTiles extends StatelessWidget {
  const myTiles(
      {Key? key,
      this.endIcon = true,
      required this.icon,
      required this.onPressed,
      this.textColor,
      required this.title})
      : super(key: key);
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
      child: ListTile(
        onTap: onPressed,
        leading: Container(
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.1),
              color: Colors.orange[200]),
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700, color: textColor),
        ),
        trailing: endIcon
            ? Container(
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.1),
                    color: Colors.grey[100]),
                child: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.black,
                ),
              )
            : null,
      ),
    );
  }

  // Future<void> fetchDashBoardData() async {
  //   try {

  //     // var user = await SimplePreferences().getUser();
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var accessToken = prefs.getStringList("_keyUser");
  //     final String authToken = accessToken![0];
  //     final String Phone = accessToken[1];

  //     final response = await http.get(
  //       Uri.http('10.1.177.121:8111', '/api/v1/home-page'),
  //       headers: <String, String>{
  //         'Authorization': 'Bearer $authToken',
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //     );
  //     // transactions = parseTransactions(response.body);
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //     // print(response.body);

  //     setState(() {
  //       groupName = data['groupName'];
  //       PhoneNumber = Phone;
  //       loading = false;
  //     });
  //     // print(mileStone);
  //   } catch (e) {
  //     var message = e.toString();
  //     'Something went wrong. Please check your internet connection.';
  //     Fluttertoast.showToast(msg: message, fontSize: 18);
  //   }
  // }
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
