import 'package:cosmic_assessments/view/screens/auth/forgot_password.dart';
import 'package:cosmic_assessments/view/screens/auth/sign_in.dart';
import 'package:cosmic_assessments/view/screens/auth/sign_up.dart';
import 'package:cosmic_assessments/view/screens/my_account.dart';
import 'package:get/get.dart';

class CommonRoutes {
  static List<GetPage> routes = [
    GetPage(
      page: () => const SignInScreen(),
      name: SignInScreen.routeName,
    ),
    GetPage(
      page: () => const SignUpScreen(),
      name: SignUpScreen.routeName,
    ),
    GetPage(
      page: () => const ForgotPasswordScreen(),
      name: ForgotPasswordScreen.routeName,
    ),
    GetPage(
      page: () => const MyAccount(
        title: 'My Account',
      ),
      name: MyAccount.routeName,
    ),
  ];
}
