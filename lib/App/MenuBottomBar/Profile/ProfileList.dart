import 'dart:convert';

import '../../../Utils/Services/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Utils/Dialogs/SnackBars.dart';
import '../../../Utils/PageUtils.dart';
import '../../../Utils/Services/Response.dart';
import '../../../Widgets/Users/User.dart';
import '../../../Utils/Dialogs/DeleteDialog.dart';
import 'Profile.dart';
import 'ProfileAdd.dart';
import 'ProfileEdit.dart';
import 'ProfileProvider.dart';

class ProfileNotifier extends StatelessWidget {
  const ProfileNotifier({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProfileProvider(),
        child: MaterialApp(title: 'Profile App', home: ProfileList()));
  }
}

class ProfileList extends StatefulWidget {
  const ProfileList({super.key});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  final List<bool> _showMore = List<bool>.filled(200, false, growable: true);
  late List<bool> _selected = List<bool>.filled(200, false, growable: true);
  bool _allSelected = false;
  Response? response;
  Utils utils = Utils();
  bool _loading = false;
  User? user;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    response = await ProfileProvider().schema();
    final _user = await getPref("user");
    setState(() {
      if (_user != null) {
        user = User.fromJson(jsonDecode(_user!));
      }
    });
  }

  onLoading(isLoading) {
    setState(() {
      _loading = isLoading;
    });
  }

  _delete(String id, bool answer) async {
    if (answer) {
      Response response = await ProfileProvider().deleteOne(id);
      SnackBars snackBar = SnackBars();
      snackBar.SuccessSnackBar(context, "Deleted profile with ID: $id");
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    List<Profile> filteredProfiles = [];
    print("len profiles");
    print(profileProvider.profiles.length.toString());

    if (profileProvider.profiles.isNotEmpty) {
      filteredProfiles = profileProvider.profiles.toList();
    }

    return Scaffold(
      body: profileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredProfiles.isEmpty
              ? const Center(child: Text('No profiles available'))
              : ListView.builder(
                  itemCount: filteredProfiles.length,
                  itemBuilder: (context, index) {
                    final Profile profile = filteredProfiles[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
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
                                          _selected[index] = !_selected[index];
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        profile.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    // IconButton(
                                    //   icon: const Icon(Icons.edit, color: Colors.red),
                                    //   onPressed: () {
                                    //     Navigator.of(context).push(
                                    //       utils.createRoute(
                                    //         context,
                                    //         ProfileEdit(profile: profile),
                                    //       ),
                                    //     );
                                    //   },
                                    // ),
                                    // IconButton(
                                    //   icon: const Icon(Icons.delete, color: Colors.red),
                                    //   onPressed: () {
                                    //     showDialog<String>(
                                    //       context: context,
                                    //       builder: (BuildContext context) => DeleteDialog(
                                    //         title: "Delete Profile",
                                    //         content: "Are you sure?",
                                    //         pos: "Yes",
                                    //         neg: "Cancel",
                                    //         id: profile.id!,
                                    //         answer: _delete,
                                    //       ),
                                    //     );
                                    //   },
                                    // ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Text(
                                //   '${profile.company?.name}',
                                //   style: const TextStyle(color: Colors.grey),
                                // ),
                                // profile.branch?.name != null
                                //     ? Text(
                                //         'Branch: ${profile.branch?.name}',
                                //         style:
                                //             const TextStyle(color: Colors.grey),
                                //       )
                                //     : SizedBox.shrink(),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showMore[index] = !_showMore[index];
                                    });
                                  },
                                  child: Text(
                                    _showMore[index]
                                        ? 'Show less'
                                        : 'Show more',
                                    style: const TextStyle(
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
                                          // profile.position?.name != null
                                          //     ? Text(
                                          //         'Role: ${profile.position?.name}',
                                          //         style: const TextStyle(
                                          //             color: Colors.grey),
                                          //       )
                                          //     : SizedBox.shrink(),
                                          // profile.section?.name != null
                                          //     ? Text(
                                          //         'section: ${profile.section?.name}',
                                          //         style: const TextStyle(
                                          //             color: Colors.grey),
                                          //       )
                                          //     : SizedBox.shrink(),
                                        ],
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  _header() {
    return Card(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _allSelected,
            onChanged: (value) {
              setState(() {
                _allSelected = value!;
                _selected =
                    List<bool>.filled(200, _allSelected, growable: true);
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                utils.createRoute(
                    context,
                    ProfileAdd(
                      resource: [],
                    )),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              "Add",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
