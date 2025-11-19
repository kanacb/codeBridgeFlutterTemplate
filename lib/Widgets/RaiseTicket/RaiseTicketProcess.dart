import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../../Utils/Methods.dart';
import '../AtlasChecklists/AtlasChecklistsProvider.dart';
import '../AtlasChecks/AtlasChecksProvider.dart';
import '../ExternalChecklists/ExternalChecklistsProvider.dart';
import '../ExternalChecks/ExternalChecksProvider.dart';
import '../AtlasMachines/AtlasMachines.dart';
import '../AtlasMachines/AtlasMachinesProvider.dart';

class RaiseTicketProcess {
  RaiseTicketProcess();

  Future<List<AtlasMachines>?> FindMachines(
    BuildContext context,
    String qrcode,
  ) async {
    try {
      List<AtlasMachines> allMachines =
          Provider.of<AtlasMachinesProvider>(context, listen: false).data;
      // find machine in local storage
      return allMachines.where((machine) {
        return qrcode == machine.serialNumber;
      }).toList();
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading local data: $error')),
        );
      }
    }
    return null;
  }

  Future<AtlasMachines?> FetchMachine(
    BuildContext context,
    String qrcode,
  ) async {
    AtlasMachinesProvider()
        .fetchBySerialNoAndSave(qrcode)
        .then((response) async {
          return response.data;
        })
        .catchError((onError) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading server data $qrcode: $onError'),
              ),
            );
          }
          return null;
        });
  }

  bool MachineOwnerStatus(
    AtlasMachines machine,
    Profile? profile,
  ) {
    bool status = false;

    // check company in profile matches machine company
    print("User: ${profile?.company?.name}");
    print("Machine: ${machine.ownership.companyId.name}");

    if (profile?.role?.name == "Admin") {
      status = true;
    }
    else if (machine.ownership.companyId.name == profile?.company?.name) {
      status = true;
    }
    return status;
  }

  Future<Map<String, List>> ChecklistsNChecks(
    BuildContext context,
    AtlasMachines machine,
  ) async {
    List<dynamic> checklists = [];
    List<dynamic> checks = [];
    final List<String> internal = [
      "Etika Sdn Bhd",
      "Atlas Vending(M) Sdn Bhd",
      "IRMS Sdn Bhd",
    ];

    if (internal.contains(machine.ownership.companyId.name)) {
      checklists =
          Provider.of<AtlasChecklistsProvider>(context, listen: false).data
              .where(
                (v) => v.vendingMachineId == machine.vendingMachineType?.sId,
              )
              .toList();
      final checklistsIds = checklists.map((checklist) => checklist.id).toSet();
      checks =
          Provider.of<AtlasChecksProvider>(context, listen: false).data
              .where((check) => checklistsIds.contains(check.checkListId)).toList();
    } else {
      checklists =
          Provider.of<ExternalChecklistsProvider>(context, listen: false).data
              .where(
                (v) => v.vendingMachineId == machine.vendingMachineType?.sId,
              )
              .toList();
      checks =
          Provider.of<ExternalChecksProvider>(context, listen: false).data
              .where((check) => check.checkListId == checklists[0].id)
              .toList();
    }

    return {"checklists": checklists, "checks": checks};
  }
}
