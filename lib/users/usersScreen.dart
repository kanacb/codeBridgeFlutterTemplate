import 'package:vx_index/users/userModel.dart';
import 'package:vx_index/screens/widgets/loading.dart';
import 'package:vx_index/users/usersService.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late bool isLoading;
  List<User> users = [];
  String? error;

  fetchUsers() {
    print("fetchUsers");
    UsersAPI usersAPI = UsersAPI();
    usersAPI.getUsers().then(
      (response) {
        isLoading = false;
        if (response.errorMessage == null) {
          setState(() {
            users = response.data!;
            isLoading = false;
          });
        } else {
          setState(() {
            error = response.errorMessage;
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  void initState() {
    isLoading = true;
    fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 12,
        titleSpacing: 10,
        title: const Text(
          'App Users',
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                fetchUsers();
              });
            },
            icon: const Icon(Icons.refresh_rounded),
            color: const Color(0xFFfd2c2c),
            iconSize: 20,
          ),
        ],
      ),
      body: isLoading
          ? const LoadingWidget()
          : error == null
              ? users.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "Users list is empty for now",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: users.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(users[index].imageUrl),
                            maxRadius: 24,
                          ),
                          title: Text(
                            users[index].name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            users[index].email,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Clicked ${users[index].name}"),
                                elevation: 2,
                                duration: const Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(5),
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          indent: 16,
                          endIndent: 16,
                          height: 1,
                        );
                      },
                    )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      error!,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                ),
    );
  }
}