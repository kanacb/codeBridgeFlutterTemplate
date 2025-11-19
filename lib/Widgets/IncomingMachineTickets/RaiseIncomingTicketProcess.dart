import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../App/MenuBottomBar/Profile/Profile.dart';
import '../IncomingMachineChecklists/IncomingMachineChecklistsProvider.dart';
import '../IncomingMachineChecks/IncomingMachineChecksProvider.dart';

class RaiseIncomingTicketProcess {
  RaiseIncomingTicketProcess();

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
  ) async {
    List<dynamic> checklists = [];
    List<dynamic> checks = [];

    checklists = Provider.of<IncomingMachineChecklistsProvider>(context, listen: false).data;
    final checklistsIds = checklists.map((checklist) => checklist.id).toSet();
    checks =
        Provider.of<IncomingMachineChecksProvider>(context, listen: false).data
            .where((check) => checklistsIds.contains(check.checkListId)).toList();

    return {"checklists": checklists, "checks": checks};
  }
}
