import 'package:get/state_manager.dart';

class BottomNavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
