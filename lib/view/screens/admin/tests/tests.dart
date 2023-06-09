import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/common/widgets/tests/admin_test_filter_dialog.dart';
import 'package:cosmic_assessments/common/widgets/tests/admin_test_sort_dialog.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/controllers/admin/tests/tests_controller.dart';
import 'package:cosmic_assessments/controllers/bottom_navigation_controller.dart';
import 'package:cosmic_assessments/view/navigator/admin/quick_navigator.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/add_test.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/manage_test.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';

class AdminTestsScreen extends StatefulWidget {
  static String routeName = "/a/tests";
  final String title;
  final bool useBack;

  const AdminTestsScreen({
    super.key,
    required this.title,
    this.useBack = true,
  });

  @override
  State<AdminTestsScreen> createState() => _AdminTestsScreenState();
}

class _AdminTestsScreenState extends State<AdminTestsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bNC = Get.find<BottomNavigationController>();
  final testsController = Get.put(TestsController());
  TextEditingController searchController = TextEditingController();
  bool showSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: showSearch ? white : Theme.of(context).primaryColor,
        leading: showSearch
            ? IconButton(
                icon: const Icon(
                  Icons.close,
                  color: black,
                ),
                onPressed: () {
                  setState(() => showSearch = false);
                  if (searchController.text != '') {
                    testsController.clearSearch();
                    testsController.clearFilters();
                    testsController.fetchTests();
                  }
                },
              )
            : widget.useBack
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () => Get.back(),
                  )
                : spaceZero,
        leadingWidth: showSearch || widget.useBack ? 56 : 0,
        title: showSearch
            ? TextField(
                maxLines: 1,
                controller: searchController,
                style: const TextStyle(
                  color: text1,
                  fontSize: 18,
                ),
                autofocus: true,
                keyboardType: TextInputType.text,
                onSubmitted: (term) {
                  if (searchController.text != '') {
                    testsController.search(searchController.text);
                    testsController.fetchTests();
                  }
                },
                onChanged: (term) {},
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 20.0),
                ),
              )
            : Text(
                widget.title,
              ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: showSearch ? black : white,
            ),
            onPressed: () => setState(
              () => {
                showSearch = true,
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.menu,
              color: showSearch ? black : white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          )
        ],
      ),
      bottomNavigationBar: widget.useBack
          ? null
          : QuickNavigatorAdmin(
              bottomNavigationController: bNC,
            ),
      drawer: AdminSidebar(),
      body: Obx(
        () {
          if (testsController.isLoading.value == true) {
            return const Loader();
          } else {
            if (testsController.testsList.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, bottom: 15, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => Get.to(
                            () => const AdminAddTestPopUp(
                              title: 'Create Test',
                            ),
                            routeName: AdminAddTestPopUp.routeName,
                            fullscreenDialog: true,
                          ),
                          child: const Heading3(
                            text: 'Add Test',
                            bold: false,
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: text1,
                          ),
                          onSelected: (String value) {
                            switch (value) {
                              case 'SHOW_FILTER':
                                Get.dialog(AdminTestFilterDialog());
                                break;
                              case 'SHOW_SORT':
                                Get.dialog(AdminTestSortDialog());
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "SHOW_FILTER",
                              child: Text(
                                "Filters",
                                style: TextStyle(color: text1),
                              ),
                            ),
                            const PopupMenuItem(
                              value: "SHOW_SORT",
                              child: Text(
                                "Sort By",
                                style: TextStyle(color: text1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GetBuilder<TestsController>(
                      builder: (controller) {
                        return ListView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.testsList.length,
                          itemBuilder: (context, index) {
                            var test = controller.testsList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 0,
                                margin: const EdgeInsets.only(
                                  bottom: 15,
                                ),
                                child: ListTile(
                                  onTap: () => Get.toNamed(
                                    "${AdminManageTest.routePath}/${test.guid}",
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      spaceV10,
                                      Heading4(
                                        text: test.title,
                                        bold: false,
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      spaceV10,
                                      Body1(
                                        text: test.guid,
                                      ),
                                      spaceV10,
                                      Wrap(
                                        children: [
                                          const Body2(
                                            text: 'Start Date:',
                                            color: text1,
                                            bold: true,
                                          ),
                                          spaceH5,
                                          Body2(
                                            text: DateFormat('dd/MM/yyyy')
                                                .format(test.createdOn),
                                            color: text2,
                                          ),
                                          spaceH5,
                                          const Body2(
                                            text: 'End Date:',
                                            color: text1,
                                            bold: true,
                                          ),
                                          spaceH5,
                                          Body2(
                                            text: DateFormat('dd/MM/yyyy')
                                                .format(test.createdOn),
                                            color: text2,
                                          ),
                                        ],
                                      ),
                                      spaceV10,
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (test.status == '1')
                                        const Icon(
                                          Icons.check,
                                          color: b2,
                                        ),
                                      if (test.status == '0')
                                        const Icon(
                                          Icons.close,
                                          color: secondary,
                                        ),
                                      if (test.status == '2')
                                        const Icon(
                                          Icons.unarchive_outlined,
                                          color: b1,
                                        ),
                                      spaceH5,
                                      Body1(
                                        text: test.type.capitalizeFirst!,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  if (testsController.isNextLoading.value == true)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                ],
              );
            } else {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.find_in_page,
                      size: 100,
                      color: grey,
                    ),
                    Container(height: 15),
                    const Text(
                      "No Tests found.",
                      style: TextStyle(
                        color: grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
