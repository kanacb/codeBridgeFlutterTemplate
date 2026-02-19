import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../Utils/Globals.dart' as globals;
import '../../Utils/Dialogs/BottomNavigationBar.dart';
import '../../Utils/Dialogs/DeleteDialog.dart';
import '../../Utils/Dialogs/DrawerMenu.dart';
import '../../Utils/Services/Response.dart';
import '../../Utils/Services/ServiceFieldsMenu.dart';
import '../../Utils/Dialogs/SnackBars.dart';
import '../../Utils/PageUtils.dart';
import '../../Utils/Services/ServiceFilterByMenu.dart';
import '../../Utils/Services/ServiceMoreMenu.dart';
import '../../Utils/Services/ServiceSearchDialog.dart';
import '../../Utils/Services/ServiceSortByMenu.dart';
import 'User.dart';
import 'UserAdd.dart';
import 'UserEdit.dart';
import 'UserProvider.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Logger logger = globals.logger;
  final List<bool> _showMore = List<bool>.filled(200, false, growable: true);
  List<bool> _selected = List<bool>.filled(200, false, growable: true);
  bool _allSelected = false;
  bool _showMenu = false;
  bool _showFilterBy = false;
  bool _showFields = false;
  bool _showSort = false;
  Response? response;
  Utils utils = Utils();

  final dataProvider = Provider(
    create: (context) {
      return Provider.of<UserProvider>(context, listen: false);
    },
  );

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    response = await UserProvider().schema();
  }

  _delete(String id, bool answer) async {
    print(id);
    if (answer) {
      Response response = await UserProvider().deleteOne(id);

      SnackBars snackBar = SnackBars();
      snackBar.SuccessSnackBar(context, "deleted $id");
    }
  }

  bool ageGreaterThanNow(User user) {
    final future = DateTime.now().add(const Duration(days: 2));
    return user.createdAt.compareTo(future) < 0;
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<UserProvider>(context, listen: false);
    List<User> filtered = dataProvider.data.where(ageGreaterThanNow).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User management / Users'),
        backgroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () => setState(() {
                    _showMenu = !_showMenu;
                  }),
              icon: _showMenu
                  ? Icon(Icons.close_rounded)
                  : Icon(Icons.more_horiz_rounded))
        ],
      ),
      drawer: DrawerMenu(),
      body: dataProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : filtered.isEmpty
              ? Center(child: Text('No data available'))
              : GestureDetector(
                  onTap: () => setState(() {
                    _showMenu = false;
                    _showSort = false;
                    _showFilterBy = false;
                    _showFields = false;
                  }),
                  child: Stack(children: [
                    ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final User user = filtered[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            children: [
                              index == 0 ? _header() : SizedBox(),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _selected[index],
                                          onChanged: (value) {
                                            setState(() {
                                              _selected[index] =
                                                  !_selected[index];
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: Text(
                                            user.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.red),
                                            onPressed: () =>
                                                // Handle edit
                                                Navigator.of(context).push(
                                                    utils.createRoute(
                                                        context,
                                                        UserEdit(
                                                            resource:
                                                                response?.data,
                                                            user: user)))),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        DeleteDialog(
                                                            title:
                                                                "Delete a User",
                                                            content:
                                                                "Are you sure?",
                                                            pos: "Yes",
                                                            neg: "Cancel",
                                                            id: user.id!,
                                                            answer: _delete));
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Email: ${user.email}',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      'Status: ${user.status}',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _showMore[index] =
                                              _showMore[index] ? false : true;
                                          if (kDebugMode) {
                                            print(_showMore[index]);
                                            print(index);
                                          }
                                        });
                                      },
                                      child: Text(
                                        _showMore[index]
                                            ? 'Show less'
                                            : 'Show more',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    _showMore[index]
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                  'User ID: ${user.id}',
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  'Remember me: ${user.rememberToken}',
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  'Verified: ${user.isEmailVerified}',
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                // Text(
                                                //   'Verified At: ${user.emailVerifiedAt}',
                                                //   style: const TextStyle(
                                                //       color: Colors.grey),
                                                // ),
                                                Text(
                                                  'Created At: ${user.createdAt}',
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  'Updated At: ${user.updatedAt}',
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ])
                                        : SizedBox()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ServiceMoreMenu(show: _showMenu),
                    ServiceFilterByMenu(
                        show: _showFilterBy, response: response?.data),
                    ServiceSortByMenu(
                        show: _showSort, response: response?.data),
                    ServiceFieldsMenu(
                        show: _showFields, response: response?.data),
                  ]),
                ),
      bottomNavigationBar: CBBottomNavigationBar(),
    );
  }

  _header() {
    return Card(
      color: Colors.white,
      borderOnForeground: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _allSelected,
            onChanged: (value) {
              _allSelected = value!;
              setState(() {
                _selected =
                    List<bool>.filled(200, _allSelected, growable: true);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list,
                color: _showFilterBy ? Colors.red : Colors.grey),
            onPressed: () {
              setState(() {
                _showFilterBy = !_showFilterBy;
                _showSort = false;
                _showFields = false;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.sort_sharp,
                color: _showSort ? Colors.red : Colors.grey),
            onPressed: () {
              setState(() {
                _showSort = !_showSort;
                _showFilterBy = false;
                _showFields = false;
              });
            },
          ),
          IconButton(
            icon:
                Icon(Icons.list, color: _showFields ? Colors.red : Colors.grey),
            onPressed: () {
              setState(() {
                _showFields = !_showFields;
                _showFilterBy = false;
                _showSort = false;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.grey),
            onPressed: () {
              Navigator.of(context).push(
                  utils.createRoute(context, const ServiceSearchDialog()));
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(utils.createRoute(
                  context, UserAdd(resource: response?.data)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              "Add",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
