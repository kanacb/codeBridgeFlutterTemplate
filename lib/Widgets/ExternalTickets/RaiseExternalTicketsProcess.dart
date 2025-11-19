import 'package:aims/Widgets/ExternalMachines/ExternalMachines.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../ExternalChecklists/ExternalChecklistsProvider.dart';
import '../ExternalChecks/ExternalChecksProvider.dart';


class RaiseExternalTicketsProcess {
  RaiseExternalTicketsProcess();

  bool MachineOwnerStatus(
      dynamic machine,
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
      ExternalMachines machine,
      ) async {
    List<dynamic> checklists = [];
    List<dynamic> checks = [];

    checklists =
        Provider.of<ExternalChecklistsProvider>(context, listen: false).data
            .where((v) => v.vendingMachineId?.sId == machine.vendingMachineType?.sId,).toList();

    final checklistsIds = checklists.map((checklist) => checklist.id).toSet();
    checks =
        Provider.of<ExternalChecksProvider>(context, listen: false).data
            .where((check) => checklistsIds.contains(check.checkListId)).toList();

    return {"checklists": checklists, "checks": checks};
  }
}
