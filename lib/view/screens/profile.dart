import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:cosmic_assessments/config/colors.dart';

// import 'package:cosmic_assessments/view/screens/edit_user.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile/:id";
  final String title;
  const ProfileScreen({super.key, required this.title});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final String? id = Get.parameters['id'];
  final List<bool> _isDisabled = [false, false, true, true, false];
  static const List<Tab> myTabs = <Tab>[
    Tab(
      text: 'Details',
    ),
    Tab(
      text: 'Account',
    ),
    Tab(
      text: 'Enrollment',
    ),
    Tab(
      text: 'Exams',
    ),
    Tab(
      text: 'Security',
    ),
  ];

  late TabController _tabController;

  onTap() {
    if (_isDisabled[_tabController.index]) {
      int index = _tabController.previousIndex;
      setState(() {
        _tabController.index = index;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "This feature will be coming soon",
            textScaleFactor: 1.5,
          ),
          backgroundColor: secondary,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(onTap);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.title} $id"),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            label: const Text(
              'Edit User',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          // isScrollable: true,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          final String? label = tab.text?.toLowerCase();
          return Center(
            child: Text(
              'This is the ${label ?? 'Danger Zone'} tab',
              style: const TextStyle(fontSize: 36),
            ),
          );
        }).toList(),
      ),
    );
  }
}
