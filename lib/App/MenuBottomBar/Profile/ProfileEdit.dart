import 'Profile.dart';
import 'package:flutter/cupertino.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key, required this.profile });

  final Profile profile;
  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
