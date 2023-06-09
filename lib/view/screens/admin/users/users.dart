import 'package:cosmic_assessments/common/widgets/loader.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';
import 'package:cosmic_assessments/common/widgets/text/text.dart';
import 'package:cosmic_assessments/common/widgets/users/change_role_dialog.dart';
import 'package:cosmic_assessments/common/widgets/users/users_flter_dialog.dart';
import 'package:cosmic_assessments/config/colors.dart';
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/admin/users/users_controller.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/users/add_user.dart';
import 'package:cosmic_assessments/view/screens/admin/users/view_user.dart';
import 'package:cosmic_assessments/view/sidebar/admin/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUsersScreen extends StatefulWidget {
  static String routeName = "/a/users";
  final String title;
  const AdminUsersScreen({super.key, required this.title});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final usersController = Get.put(UsersController());
  TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  bool isFiltered = false;
  List<String> selectedUsers = [];

  @override
  void initState() {
    usersController.fetchUsers().then(
          (value) => usersController.paginateUsers(),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor:
              showSearch ? Colors.white : Theme.of(context).primaryColor,
          leading: showSearch
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      showSearch = false;
                      isFiltered = false;
                    });
                    searchController.text = "";
                    usersController.clearSearch();
                    usersController.clearFilters();
                    usersController.fetchUsers();
                  },
                )
              : IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
          title: showSearch
              ? TextField(
                  maxLines: 1,
                  controller: searchController,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 18,
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  onSubmitted: (term) {
                    usersController.search(searchController.text);
                    usersController.fetchUsers().then((value) {
                      setState(() {
                        isFiltered = true;
                      });
                    });
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
                color: showSearch ? Colors.black : Colors.white,
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
            ),
          ],
        ),
        drawer: AdminSidebar(),
        body: Obx(() {
          if (usersController.isLoading.value == true) {
            return const Loader();
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (usersController.search.value.isNotEmpty)
                        Heading2(
                          text: 'Results for "${usersController.search.value}"',
                        ),
                      if (usersController.search.value.isEmpty)
                        ElevatedButton(
                          onPressed: () => Get.to(
                            () => const AdminAddNewUserPopup(
                              title: 'Add New User',
                            ),
                            routeName: AdminAddNewUserPopup.routeName,
                            fullscreenDialog: true,
                          ),
                          child: const Heading3(
                            text: 'Add User',
                            bold: false,
                          ),
                        ),
                      Row(
                        children: [
                          Column(
                            children: [
                              if (isFiltered)
                                SizedBox(
                                  height: 30,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        showSearch = false;
                                        isFiltered = false;
                                      });
                                      searchController.text = "";
                                      usersController.clearSearch();
                                      usersController.clearFilters();
                                      usersController.fetchUsers();
                                    },
                                    child: Body2(
                                      text: usersController.search.value.isEmpty
                                          ? 'Clear Filter'
                                          : usersController
                                                  .search.value.isNotEmpty
                                              ? 'Clear Search'
                                              : 'Clear',
                                      bold: false,
                                    ),
                                  ),
                                ),
                              if (selectedUsers.isNotEmpty)
                                SizedBox(
                                  height: 30,
                                  child: TextButton(
                                    onPressed: () {
                                      List<String> newSelUsers = selectedUsers;
                                      newSelUsers.clear();
                                      setState(() {
                                        selectedUsers = newSelUsers;
                                      });
                                    },
                                    child: const Body2(
                                      text: 'Clear Selection',
                                      bold: false,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: text1,
                            ),
                            tooltip: "Bulk Action",
                            onSelected: (String value) async {
                              switch (value) {
                                case 'ACTIVATE':
                                  Map<String, String> selectedUsersData =
                                      selectedUsers
                                          .asMap()
                                          .map((index, userGuid) {
                                    return MapEntry(
                                      "users[$index]",
                                      userGuid,
                                    );
                                  });
                                  await usersController
                                      .activateUsers(selectedUsersData);
                                  setState(() {
                                    selectedUsers = [];
                                  });
                                  break;
                                case 'DEACTIVATE':
                                  Map<String, String> selectedUsersData =
                                      selectedUsers
                                          .asMap()
                                          .map((index, userGuid) {
                                    return MapEntry(
                                      "users[$index]",
                                      userGuid,
                                    );
                                  });
                                  await usersController
                                      .deActivateUsers(selectedUsersData);
                                  setState(() {
                                    selectedUsers = [];
                                  });
                                  break;
                                case 'ARCHIVE':
                                  Map<String, String> selectedUsersData =
                                      selectedUsers
                                          .asMap()
                                          .map((index, userGuid) {
                                    return MapEntry(
                                      "users[$index]",
                                      userGuid,
                                    );
                                  });
                                  await usersController
                                      .archiveUsers(selectedUsersData);
                                  setState(() {
                                    selectedUsers = [];
                                  });
                                  break;
                                case 'DELETE':
                                  Map<String, String> selectedUsersData =
                                      selectedUsers
                                          .asMap()
                                          .map((index, userGuid) {
                                    return MapEntry(
                                      "users[$index]",
                                      userGuid,
                                    );
                                  });
                                  await usersController
                                      .deleteUsers(selectedUsersData);
                                  setState(() {
                                    selectedUsers = [];
                                  });
                                  break;
                                case 'CHANGE_ROLE':
                                  usersController.role(student.value);
                                  Get.dialog(
                                    ChangeRoleDialog(
                                      usersController: usersController,
                                      selectedUsers: selectedUsers,
                                    ),
                                  );
                                  break;
                                case 'SHOW_FILTER':
                                  Get.dialog(
                                    UsersFilterDialog(
                                      usersController: usersController,
                                      onApply: () {
                                        setState(() {
                                          isFiltered = true;
                                        });
                                      },
                                    ),
                                  );
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
                              if (selectedUsers.isNotEmpty)
                                const PopupMenuItem(
                                  value: "CHANGE_ROLE",
                                  child: Text(
                                    "Change Role",
                                    style: TextStyle(color: text1),
                                  ),
                                ),
                              if (selectedUsers.isNotEmpty)
                                const PopupMenuItem(
                                  value: "ACTIVATE",
                                  child: Text(
                                    "Activate",
                                    style: TextStyle(color: text1),
                                  ),
                                ),
                              if (selectedUsers.isNotEmpty)
                                const PopupMenuItem(
                                  value: "DEACTIVATE",
                                  child: Text(
                                    "Deactivate",
                                    style: TextStyle(color: text1),
                                  ),
                                ),
                              if (selectedUsers.isNotEmpty)
                                const PopupMenuItem(
                                  value: "ARCHIVE",
                                  child: Text(
                                    "Archive",
                                    style: TextStyle(color: text1),
                                  ),
                                ),
                              if (selectedUsers.isNotEmpty)
                                const PopupMenuItem(
                                  value: "DELETE",
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: text1),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (usersController.usersList.isNotEmpty)
                  Expanded(
                    child: GetBuilder<UsersController>(
                      builder: (controller) {
                        return ListView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.usersList.length,
                          itemBuilder: (context, index) {
                            var user = controller.usersList[index];
                            Color avatarColor = generateAvatarColor(
                                "${user.getDisplayName()}-${user.guid}");
                            Color contrastColor =
                                generateAvatarContrast(avatarColor);
                            String? active = user.active;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 1,
                              ),
                              child: Card(
                                elevation:
                                    selectedUsers.contains(user.guid) ? 2 : 0,
                                color: selectedUsers.contains(user.guid)
                                    ? Colors.grey.shade300
                                    : white,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () {
                                        List<String> newSelUsers =
                                            selectedUsers;
                                        if (!newSelUsers.contains(user.guid)) {
                                          newSelUsers.add(user.guid);
                                        } else {
                                          newSelUsers.remove(user.guid);
                                        }
                                        setState(() {
                                          selectedUsers = newSelUsers;
                                        });
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: avatarColor,
                                        child: selectedUsers.contains(user.guid)
                                            ? Icon(
                                                Icons.check,
                                                color: contrastColor,
                                              )
                                            : Text(
                                                getInitials(
                                                  name: user.getDisplayName(),
                                                ),
                                                style: TextStyle(
                                                  color: contrastColor,
                                                ),
                                              ),
                                      ),
                                      title: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Heading4(
                                            text: user.getDisplayName(),
                                            bold: false,
                                            color:
                                                active == '1' ? text1 : text2,
                                          ),
                                          spaceH5,
                                          Body2(
                                            text: active == '1'
                                                ? 'Active'
                                                : 'Inactive',
                                            color: active == '1' ? b2 : b3,
                                          )
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Body2(
                                            text:
                                                "Role:- ${user.role!.capitalizeFirst!}",
                                          ),
                                          Body1(
                                            text:
                                                "Email:- ${user.email ?? '-'}",
                                          ),
                                          Body1(
                                            text: 'UserId:- ${user.guid}',
                                          ),
                                        ],
                                      ),
                                      trailing:
                                          !selectedUsers.contains(user.guid)
                                              ? IconButton(
                                                  icon: const Icon(
                                                    Icons.contact_page_outlined,
                                                  ),
                                                  onPressed: () {
                                                    Get.toNamed(
                                                      "${AdminViewUser.routePath}/${user.guid}",
                                                    );
                                                  },
                                                )
                                              : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                if (usersController.usersList.isNotEmpty &&
                    usersController.isNextLoading.value == true)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                if (usersController.usersList.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.find_in_page,
                            size: 100,
                            color: Colors.grey[300],
                          ),
                          Container(height: 15),
                          Text(
                            "No Users found.",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
        }));
  }
}
