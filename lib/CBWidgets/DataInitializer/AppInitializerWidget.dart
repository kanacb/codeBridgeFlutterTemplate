import 'package:flutter/material.dart';
import 'DataInitializer.dart';
import '../../Utils/HiveSetup.dart';

class AppInitializerWidget extends StatefulWidget {
  final Widget child;

  const AppInitializerWidget({required this.child, super.key});

  @override
  State<AppInitializerWidget> createState() => _AppInitializerWidgetState();
}

class _AppInitializerWidgetState extends State<AppInitializerWidget> {
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();

    // Delay until first frame is rendered so context is fully mounted
    _initializationFuture = Future.delayed(Duration.zero, () async {
      await HiveSetup.initializeHive();
      final initializer = DataInitializer(context);
      return initializer.initializeAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
              title: 'CodeBridge',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
                useMaterial3: true,
              ),
              home: const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ));
        }

        if (snapshot.hasError) {
          return MaterialApp(
              title: 'CodeBridge',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
                useMaterial3: true,
              ),
              home: Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')),
              ));
        }

        return widget.child;
      },
    );
  }
}
