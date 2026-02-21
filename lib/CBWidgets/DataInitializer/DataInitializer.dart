import 'package:aims/Widgets/IncomingMachineChecklists/IncomingMachineChecklistsProvider.dart';
import 'package:aims/Widgets/IncomingMachineChecks/IncomingMachineChecksProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rename/platform_file_editors/abs_platform_file_editor.dart';

import '../AtlasChecklists/AtlasChecklistsProvider.dart';
import '../AtlasChecks/AtlasChecksProvider.dart';
import '../MemChecks/MemChecksProvider.dart';
import '../MemMachineChecklists/MemChecklistsProvider.dart';
import '../VendingMachine/VendingMachineProvider.dart';
import '../Companies/CompanyProvider.dart';
import '../ExternalChecklists/ExternalChecklistsProvider.dart';
import '../ExternalChecks/ExternalChecksProvider.dart';
import '../AtlasTickets/AtlasTicketProvider.dart';
import 'DataFetchable.dart';

class DataInitializer {
  final BuildContext context;

  DataInitializer(this.context);

  // List of providers to initialize
  final Map<String, DataFetchable> Function(BuildContext) _providerMap =
      (ctx) => {
        'companies': Provider.of<CompanyProvider>(ctx, listen: false),
        'vms': Provider.of<VendingMachineProvider>(ctx, listen: false),
        'incomingMachineChecklists': Provider.of<IncomingMachineChecklistsProvider>(ctx, listen: false),
        'incomingMachineChecks': Provider.of<IncomingMachineChecksProvider>(ctx, listen: false),
        'atlasChecklists': Provider.of<AtlasChecklistsProvider>(ctx, listen: false),
        'atlasChecks': Provider.of<AtlasChecksProvider>(ctx, listen: false),
        'externalChecklists': Provider.of<ExternalChecklistsProvider>(ctx, listen: false),
        'externalChecks': Provider.of<ExternalChecksProvider>(ctx, listen: false),
        'memChecklists': Provider.of<MemChecklistsProvider>(ctx, listen: false),
        'memChecks': Provider.of<MemChecksProvider>(ctx, listen: false),
        'atlasTickets': Provider.of<AtlasTicketProvider>(ctx, listen: false),
        // Add more mappings here
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
