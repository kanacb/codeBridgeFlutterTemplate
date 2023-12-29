# feathersjs_demo_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

flutter pub run change_app_package_name:main com.cb.vx.index

Steps
1. flutter pub global activate rename
2. flutter pub global run rename --bundleId my.edu.bac.mob.attendance --target android
3. rename setAppName -v "VX Index"

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Clicked ${businesses[index].name}"),
                                elevation: 2,
                                duration: const Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(5),
                              ),
                            );