import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../App/MenuBottomBar/Profile/ProfileProvider.dart';
import '../../../Login/Login.dart';
import '../../../Login/Services/authService.dart';
import '../../../Utils/Dialogs/SnackBars.dart';
import '../../../Utils/Services/SharedPreferences.dart'; // Contains savePref and getPref
import '../../../Utils/Validators.dart';
import '../../../Widgets/Users/User.dart';
import '../../Dash/DashMain.dart';
import 'Profile.dart';
import 'ProfilePage.dart';

class ProfilePopUp extends StatefulWidget {
  final BuildContext parentContext;

  const ProfilePopUp({
    Key? key, required this.parentContext}) : super(key: key);

  @override
  State<ProfilePopUp> createState() => _ProfilePopUpState();
}

class _ProfilePopUpState extends State<ProfilePopUp> {
  bool _enabled = true;
  bool isLoading = true;
  Profile? _selectedProfile;
  User? user;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadUser();
    await _loadSelectedProfile();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadUser() async {
    user = User.fromJson(jsonDecode(await getPref("user") ?? ""));
  }

  /// Load the stored profile from shared preferences.
  Future<void> _loadSelectedProfile() async {
    final storedProfileString = await getPref("selectedProfile");
    print("DEBUG: ProfilePopUp - Stored profile string: $storedProfileString");

    if (storedProfileString != null && storedProfileString.isNotEmpty) {
      try {
        final profiles = ProfileProvider().profiles;
        Profile profile = profiles.firstWhere(
          (p) => p.id == storedProfileString,
        );

        setState(() {
          _selectedProfile = profile;
        });
      } catch (e) {
        print("ERROR: ProfilePopUp - Error decoding stored profile: $e");
      }
    } else {
      print("DEBUG: ProfilePopUp - No stored profile found.");
      setState(() {
        _selectedProfile = ProfileProvider().profiles.first;
      });
      _saveSelectedProfile(ProfileProvider().profiles.first);
    }
  }

  /// Save the selected profile into shared preferences.
  void _saveSelectedProfile(Profile profile) async {
    String profileJson = jsonEncode(profile.toJson());
    print("DEBUG: ProfilePopUp - Saving profile: $profileJson");

    await savePref("selectedProfile", profile.id);

    // Verify if the value was actually stored
    final storedProfileString = await getPref("selectedProfile");
    print("DEBUG: Stored profile after saving: $storedProfileString");

    _loadSelectedProfile(); // Reload to ensure UI updates
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profiles = profileProvider.profiles;
    final filteredProfiles = profiles.where((profile) => profile.userId.id == user?.id).toList();
    _enabled = profiles.isEmpty;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display a list of profile tiles.
          Column(
            children: [
              if (isLoading)
                const CircularProgressIndicator()
              else if (filteredProfiles.isNotEmpty)
                ...filteredProfiles.map((profile) => profileTile(profile))
              else
                const Text("No profiles found"),
            ],
          ),
          // Other options for navigation/settings.
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                // onPressed: () async {
                //   await Provider.of<ProfileProvider>(
                //     context,
                //     listen: false,
                //   ).fetchAllAndSave();
                //   Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => ProfilePage()),
                //   );
                // },
                onPressed: () {},
                icon: Icon(Icons.person, color: Colors.purple[900]),
                label: Text(
                  'Profiles',
                  style: TextStyle(color: Colors.purple[900]),
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.settings, color: Colors.purple[900]),
                label: Text(
                  'Settings',
                  style: TextStyle(color: Colors.purple[900]),
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.help_outline_sharp, color: Colors.purple[900]),
                label: Text(
                  'Help',
                  style: TextStyle(color: Colors.purple[900]),
                ),
              ),
              SafeArea(
                child: TextButton.icon(
                  onPressed: () async {
                    AuthService auth = AuthService();
                    await auth.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Login()),
                      ModalRoute.withName('/login'),
                    );
                  },
                  icon: Icon(Icons.logout_outlined, color: Colors.purple[900]),
                  label: Text(
                    'Logout',
                    style: TextStyle(color: Colors.purple[900]),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build a widget for each profile.
  Widget profileTile(Profile profile) {
    // Determine if this profile is the currently selected one.
    bool isSelected = _selectedProfile?.id == profile.id;
    print("DEBUG: Profile tile - ${profile.name} selected: $isSelected");

    // Build the image URL or use a default image.
    String imageUrl =
        (profile.image != null && profile.image!.isNotEmpty)
            ? profile.image!
            : '';

    return InkWell(
      onTap: () {
        _saveSelectedProfile(profile);
        SnackBars snackBar = SnackBars();
        snackBar.SuccessSnackBar(context, "Selected profile: ${profile.name}");
        Navigator.of(context).pop();

        bool isDashboard = widget.parentContext.widget is Dashboard;
        if (!isDashboard) {
          Navigator.of(widget.parentContext).pushReplacement(
            MaterialPageRoute(builder: (_) => Dashboard(i: 1)),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage:
                    Validators.isValidUri(imageUrl)
                        ? NetworkImage(imageUrl)
                        : const AssetImage("assets/images/avatar1.png")
                            as ImageProvider,
              ),
              Text(profile.role?.name ?? "")
            ],
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Skeletonizer(
              enabled: _enabled,
              child: Text(
                profile.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Chip(
                      label: Text(
                        profile.position?.name ?? "loading ...",
                        style: const TextStyle(fontSize: 12.0),
                      ),
                      backgroundColor: Colors.blue,
                      labelStyle: const TextStyle(color: Colors.white),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    Text(
                      profile.branch?.name ?? "No Branch",
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  profile.company?.name ?? "No Company",
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          trailing:
              isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
        ),
      ),
    );
  }
}
