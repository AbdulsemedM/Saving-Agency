import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vsla/Pages/inner/youtubePlayer.dart';
import 'package:vsla/home.dart';
import 'package:vsla/utils/localization_string.dart';
import 'package:vsla/utils/simplePreferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await SimplePreferences.init();

  String? lang = await SimplePreferences().getLanguage();
  // String? isOn = await SimplePreferences().getIsOn();

  lang ??= '';
  runApp(MyApp(lang: lang));
}

class MyApp extends StatelessWidget {
  final String lang;

  const MyApp({Key? key, required this.lang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocaleString(),
      debugShowCheckedModeBanner: false,
      locale: lang == "English"
          ? const Locale('en', 'US')
          : lang == "አማርኛ"
              ? const Locale('am', 'ET')
              : lang == "Afaan Oromoo"
                  ? const Locale('or', 'ET')
                  : const Locale("en", "US"),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
