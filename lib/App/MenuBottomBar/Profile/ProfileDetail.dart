import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ProfileProvider.dart';

class ProfileDetailPage extends StatelessWidget {
  final String profileId;

  const ProfileDetailPage({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Profile Details')),
      body: FutureBuilder(
        future: profileProvider.fetchOneAndSave(profileId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            final profile = profileProvider.profiles.firstWhere((profile) => profile.id == profileId);
            if (profile != null) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${profile.name}', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),

                  ],
                ),
              );
            } else {
              return Center(child: Text('Profile not found'));
            }
          }
        },
      ),
    );
  }
}
