import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rename/platform_file_editors/abs_platform_file_editor.dart';

import 'DataFetchable.dart';
// ~cb-data-initializer-provider-import~

class DataInitializer {
  final BuildContext context;

  DataInitializer(this.context);

  // List of providers to initialize
  final Map<String, DataFetchable> Function(BuildContext) _providerMap =
      (ctx) => {
        //'companies': Provider.of<CompanyProvider>(ctx, listen: false),
        // ~cb-data-initializer-provider-map~
      };

  // Method to initialize all providers' fetchAllAndSave methods
  Future<void> initializeAll() async {
    final registry = _providerMap(context);

    await Future.wait(
      registry.values.map((provider) {
        return provider.fetchAllAndSave();
      }),
    );
  }

  Future<void> fetchByName(String providerName) async {
    final registry = _providerMap(context);
    final provider = registry[providerName];
    if (provider == null) {
      throw Exception("No provider found with name '$providerName'.");
    }
    await provider.fetchAllAndSave();
  }
}
