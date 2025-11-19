import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Widgets/Users/User.dart';
import 'ProfileList.dart';
import 'ProfileProvider.dart'; // Assuming this handles data logic
import '../../../Utils/Services/SharedPreferences.dart';


class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  @override
  void initState() {

    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final userData = await getPref("user");
    if (userData != null) {
      setState(() {
        user = User.fromJson(jsonDecode(userData));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(), // Provides the ProfileProvider
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {}, // Add notification action
            ),
          ],
        ),
        body: user == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Details Section
              UserDetails(user: user!),
              const Divider(thickness: 1, height: 20),

              // Tabs for additional info
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Theme.of(context).primaryColor,
                      tabs: const [
                        Tab(text: 'Profile'),
                        Tab(text: 'Logins'),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TabBarView(
                        children: [
                          ProfileNotifier(),
                          Center(child: Text('Login history')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  final User user;

  const UserDetails({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Text(
          user.email ?? '',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     const Text('Employment type', style: TextStyle(color: Colors.grey)),
        //     Text(user.employmentType ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold)),
        //   ],
        // ),
        // const SizedBox(height: 10),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     const Text('Hire date', style: TextStyle(color: Colors.grey)),
        //     Text(user.hireDate ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold)),
        //   ],
        // ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            // Handle change password
          },
          child: const Text(
            'Change password',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
//small comment
