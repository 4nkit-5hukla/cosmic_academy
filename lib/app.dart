import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/routes/app_router.dart';
import 'package:cosmic_assessments/view/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final storage = const FlutterSecureStorage();
  final globalController = Get.put(GlobalController());

  MaterialColor mainColor = primary;

  Future<MaterialColor> getThemeColor() async {
    String? themeColorCache = await storage.read(key: 'themeColor');
    if (themeColorCache != null) {
      return await getMaterialColor(themeColorCache);
    } else {
      return primary;
    }
  }

  loadTheme() async {
    MaterialColor setInitColor = await getThemeColor();
    setState(() {
      mainColor = setInitColor;
    });
    String themeColorStr = await globalController.getTheme();
    if (themeColorStr.isEmpty) return;
    await storage.write(key: 'themeColor', value: themeColorStr);
    globalController.mainColor = await getMaterialColor(themeColorStr);
    globalController.contrastColor =
        await getContrastColor(globalController.mainColor);
    globalController.update();
    setState(() {
      mainColor = globalController.mainColor;
    });
  }

  @override
  void initState() {
    loadTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appTitle,
      theme: getThemeData(context, mainColor),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const SplashScreen(),
      getPages: AppRouter.routes,
    );
  }
}
