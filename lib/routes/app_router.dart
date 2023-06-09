import 'package:cosmic_assessments/routes/admin.dart';
import 'package:cosmic_assessments/routes/common.dart';
import 'package:cosmic_assessments/routes/student.dart';
import 'package:get/get.dart';

class AppRouter {
  static List<GetPage> routes = [
    ...CommonRoutes.routes,
    ...StudentRoutes.routes,
    ...AdminRoutes.routes,
  ];
}
