import 'package:aims/Widgets/AtlasMachines/AtlasMachinesProvider.dart';
import 'package:aims/Widgets/ExternalMachines/ExternalMachinesProvider.dart';
import 'package:aims/Widgets/IncomingMachineAbortHistory/IncomingMachineAbortHistoryProvider.dart';
import 'package:aims/Widgets/IrmsMachines/IrmsMachinesProvider.dart';
import 'package:aims/Widgets/IrmsWarehouseParts/IrmsWarehouseParts.dart';
import 'package:aims/Widgets/IrmsWarehouseParts/IrmsWarehousePartsProvider.dart';
import 'package:aims/Widgets/MemMachineChecklists/MemChecklists.dart';
import 'package:aims/Widgets/MemMachineChecklists/MemChecklistsProvider.dart';
import 'package:aims/Widgets/MemMachines/MemMachines.dart';
import 'package:aims/Widgets/MemParts/MemParts.dart';
import 'package:aims/Widgets/MemParts/MemPartsProvider.dart';
import 'package:aims/Widgets/MemTickets/MemTicket.dart';
import 'package:aims/Widgets/MemTickets/UsedPart.dart';
import 'package:aims/Widgets/Positions/Positions.dart';
import 'package:aims/Widgets/Positions/PositionsProvider.dart';

import '../Widgets/AtlasMachines/AtlasMachines.dart';
import '../Widgets/Branches/Branches.dart';
import '../Widgets/Companies/Companies.dart';
import '../Widgets/Companies/CompanyProvider.dart';
import '../Widgets/CustomerPurchaseOrders/CustomerPurchaseOrdersProvider.dart';
import '../Widgets/DeliveryOrderItems/DeliveryOrderItemsProvider.dart';
import '../Widgets/DisposalDetails/DisposalDetailsProvider.dart';
import '../Widgets/ExternalMachines/ExternalMachines.dart';
import '../Widgets/IncomingMachineAbortHistory/IncomingMachineAbortHistory.dart';
import '../Widgets/IncomingMachineTickets/ChecklistResponse.dart';
import '../Widgets/IncomingMachineTickets/JobStation.dart';
import '../Widgets/IrmsMachines/IrmsMachines.dart';
import '../Widgets/IrmsParts/IrmsParts.dart';
import '../Widgets/IrmsParts/IrmsPartsProvider.dart';
import '../Widgets/JobStationQueues/JobStationInsideQueue.dart';
import '../Widgets/JobStationQueues/JobStationQueue.dart';
import '../Widgets/JobStationQueues/JobStationQueueProvider.dart';
import '../Widgets/MemChecks/MemChecks.dart';
import '../Widgets/MemChecks/MemChecksProvider.dart';
import '../Widgets/MemMachines/MemMachinesProvider.dart';
import '../Widgets/MemTickets/MemTicketProvider.dart';
import '../Widgets/PartRequestDetails/PartRequestDetailsProvider.dart';
import '../Widgets/Phones/Phone.dart';
import '../Widgets/PurchaseOrderItems/PurchaseOrderItemsProvider.dart';
import '../Widgets/SampleDetails/SampleDetailsProvider.dart';
import '../Widgets/TransferDetails/TransferDetailsProvider.dart';
import '../Widgets/VendingMachine/VendingMachine.dart';
import '../Widgets/VendingMachine/VendingMachineProvider.dart';
import '../Widgets/WarehouseMaster/WarehouseMasterProvider.dart';
import '../Widgets/irmsDeliveryOrder/irmsDeliveryOrdersProvider.dart';
import '../Widgets/irmsQuotations/irmsQuotationsProvider.dart';

import '../Widgets/AtlasChecklists/AtlasChecklistsProvider.dart';
import '../Widgets/AtlasChecks/AtlasChecksProvider.dart';
import '../Widgets/CustomerPurchaseOrders/CustomerPurchaseOrders.dart';
import '../Widgets/CustomerSalesOrders/CustomerSalesOrders.dart';
import '../Widgets/CustomerSalesOrders/CustomerSalesOrdersProvider.dart';
import '../Widgets/DeliveryOrderItems/DeliveryOrderItems.dart';
import '../Widgets/DisposalDetails/DisposalDetails.dart';
import '../Widgets/IncomingMachineChecklists/IncomingMachineChecklists.dart';
import '../Widgets/JobStationTickets/JobStationTicket.dart';
import '../Widgets/JobStations/JobStations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../App/MenuBottomBar/Profile/ProfileProvider.dart';
import '../App/MenuBottomBar/Profile/Profile.dart';
import '../App/MenuBottomBar/Inbox/Inbox.dart';
import '../App/MenuBottomBar/Inbox/InboxProvider.dart';
import '../App/Dash/Notifications/CBNotification.dart';
import '../App/Dash/Notifications/NotificationProvider.dart';
import '../Widgets/AtlasChecklists/AtlasChecklists.dart';
import '../Widgets/AtlasChecks/AtlasChecks.dart';
import '../Widgets/Comments/CommentProvider.dart';
import '../Widgets/Comments/Comment.dart';
import '../Widgets/IncomingMachineChecklists/IncomingMachineChecklistsProvider.dart';
import '../Widgets/IncomingMachineChecks/IncomingMachineChecks.dart';
import '../Widgets/IncomingMachineChecks/IncomingMachineChecksProvider.dart';
import '../Widgets/JobStationTickets/JobStationTicketProvider.dart';
import '../Widgets/JobStations/JobStationsProvider.dart';
import '../Widgets/PartRequestDetails/PartRequestDetails.dart';
import '../Widgets/PartsMaster/PartsMaster.dart';
import '../Widgets/PartsMaster/PartsMasterProvider.dart';
import '../Widgets/PurchaseOrderItems/PurchaseOrderItems.dart';
import '../Widgets/QuotationItems/QuotationItems.dart';
import '../Widgets/QuotationItems/QuotationItemsProvider.dart';
import '../Widgets/SalesOrderItems/SalesOrderItems.dart';
import '../Widgets/SalesOrderItems/SalesOrderItemsProvider.dart';
import '../Widgets/SampleDetails/SampleDetails.dart';
import '../Widgets/StockInDetails/StockInDetails.dart';
import '../Widgets/StockInDetails/StockInDetailsProvider.dart';
import '../Widgets/StockOutDetails/StockOutDetails.dart';
import '../Widgets/StockOutDetails/StockOutDetailsProvider.dart';
import '../Widgets/TransferDetails/TransferDetails.dart';
import '../Widgets/UserInvites/UserInvite.dart';
import '../Widgets/UserInvites/UserInviteProvider.dart';
import '../Widgets/DocumentsStorage/DocumentStorage.dart';
import '../Widgets/DocumentsStorage/DocumentStorageProvider.dart';
import '../Widgets/ExternalChecklists/ExternalChecklists.dart';
import '../Widgets/MachineMaster/MachineMaster.dart';
import '../Widgets/MachineMaster/MachineMasterProvider.dart';
import '../Widgets/Users/User.dart';
import '../Widgets/Users/UserProvider.dart';
import '../Widgets/AtlasTickets/AtlasTicket.dart';
import '../Widgets/AtlasTickets/AtlasTicketProvider.dart';
import '../Widgets/ExternalChecklists/ExternalChecklistsProvider.dart';
import '../Widgets/ExternalChecks/ExternalChecks.dart';
import '../Widgets/ExternalChecks/ExternalChecksProvider.dart';
import '../Widgets/ExternalTickets/ExternalTickets.dart';
import '../Widgets/ExternalTickets/ExternalTicketsProvider.dart';
import '../Widgets/IncomingMachineTickets/IncomingMachineTicket.dart';
import '../Widgets/IncomingMachineTickets/IncomingMachineTicketProvider.dart';
import '../Widgets/WarehouseMaster/WarehouseMaster.dart';
import '../Widgets/irmsDeliveryOrder/irmsDeliveryOrders.dart';
import '../Widgets/irmsQuotations/irmsQuotations.dart';
import 'Services/IdName.dart';
// ~cb-add-imports~

class HiveSetup {
  static Future<void> initializeHive() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(InboxAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(CommentAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(UserInviteAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(CBNotificationAdapter()); // 5
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(DocumentStorageAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(ExternalTicketsAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(AtlasTicketAdapter());
    }
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(IncomingMachineTicketAdapter());
    }
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(ExternalChecklistsAdapter()); // 10
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(ExternalChecksAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(MachineMasterAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(AtlasChecklistsAdapter());
    }
    if (!Hive.isAdapterRegistered(14)) {
      Hive.registerAdapter(AtlasChecksAdapter());
    }
    if (!Hive.isAdapterRegistered(15)) {
      Hive.registerAdapter(IncomingMachineChecklistsAdapter()); // 15
    }
    if (!Hive.isAdapterRegistered(16)) {
      Hive.registerAdapter(IncomingMachineChecksAdapter());
    }
    if (!Hive.isAdapterRegistered(17)) {
      Hive.registerAdapter(JobStationsAdapter());
    }
    if (!Hive.isAdapterRegistered(18)) {
      Hive.registerAdapter(JobStationTicketAdapter());
    }
    if (!Hive.isAdapterRegistered(19)) {
      Hive.registerAdapter(IdNameAdapter());
    }
    if (!Hive.isAdapterRegistered(20)) {
      Hive.registerAdapter(PartsMasterAdapter()); //20
    }
    if (!Hive.isAdapterRegistered(21)) {
      Hive.registerAdapter(CustomerPurchaseOrdersAdapter());
    }
    if (!Hive.isAdapterRegistered(22)) {
      Hive.registerAdapter(CustomerSalesOrdersAdapter());
    }
    if (!Hive.isAdapterRegistered(23)) {
      Hive.registerAdapter(DeliveryOrderItemsAdapter());
    }
    if (!Hive.isAdapterRegistered(24)) {
      Hive.registerAdapter(DisposalDetailsAdapter());
    }
    if (!Hive.isAdapterRegistered(25)) {
      Hive.registerAdapter(irmsDeliveryOrdersAdapter()); //25
    }
    if (!Hive.isAdapterRegistered(26)) {
      Hive.registerAdapter(irmsQuotationsAdapter());
    }
    if (!Hive.isAdapterRegistered(27)) {
      Hive.registerAdapter(PartRequestDetailsAdapter());
    }
    if (!Hive.isAdapterRegistered(28)) {
      Hive.registerAdapter(PurchaseOrderItemsAdapter());
    }
    if (!Hive.isAdapterRegistered(29)) {
      Hive.registerAdapter(QuotationItemsAdapter());
    }
    if (!Hive.isAdapterRegistered(30)) {
      Hive.registerAdapter(SalesOrderItemsAdapter()); //30
    }
    if (!Hive.isAdapterRegistered(31)) {
      Hive.registerAdapter(SampleDetailsAdapter());
    }
    if (!Hive.isAdapterRegistered(32)) {
      Hive.registerAdapter(StockInDetailsAdapter());
    }
    if (!Hive.isAdapterRegistered(33)) {
      Hive.registerAdapter(StockOutDetailsAdapter());
    }
    if (!Hive.isAdapterRegistered(34)) {
      Hive.registerAdapter(TransferDetailsAdapter());
    }
    if (!Hive.isAdapterRegistered(35)) {
      Hive.registerAdapter(WarehouseMasterAdapter()); //35
    }
    // if (!Hive.isAdapterRegistered(36)) {
    // Hive.registerAdapter(WarehouseMasterAdapter());
    // }
    if (!Hive.isAdapterRegistered(37)) {
      Hive.registerAdapter(BranchesAdapter());
    }
    if (!Hive.isAdapterRegistered(38)) {
      Hive.registerAdapter(CompaniesAdapter());
    }
    if (!Hive.isAdapterRegistered(39)) {
      Hive.registerAdapter(VendingMachineAdapter());
    }
    if (!Hive.isAdapterRegistered(40)) {
      Hive.registerAdapter(ChecklistResponseAdapter());
    }
    if (!Hive.isAdapterRegistered(41)) {
      Hive.registerAdapter(JobStationAdapter());
    }
    if (!Hive.isAdapterRegistered(42)) {
      Hive.registerAdapter(AtlasMachinesAdapter());
    }
    if (!Hive.isAdapterRegistered(43)) {
      Hive.registerAdapter(IrmsMachinesAdapter());
    }
    if (!Hive.isAdapterRegistered(44)) {
      Hive.registerAdapter(MemMachinesAdapter());
    }
    if (!Hive.isAdapterRegistered(45)) {
      Hive.registerAdapter(ExternalMachinesAdapter());
    }
    if (!Hive.isAdapterRegistered(46)) {
      Hive.registerAdapter(JobStationQueueAdapter());
    }
    if (!Hive.isAdapterRegistered(47)) {
      Hive.registerAdapter(JobStationInsideQueueAdapter());
    }
    if (!Hive.isAdapterRegistered(48)) {
      Hive.registerAdapter(IrmsPartsAdapter());
    }
    if (!Hive.isAdapterRegistered(49)) {
      Hive.registerAdapter(IncomingMachineAbortHistoryAdapter());
    }
    if (!Hive.isAdapterRegistered(50)) {
      Hive.registerAdapter(IrmsWarehousePartsAdapter());
    }
    if (!Hive.isAdapterRegistered(51)) {
      Hive.registerAdapter(MemTicketAdapter());
    }
    if (!Hive.isAdapterRegistered(52)) {
      Hive.registerAdapter(UsedPartAdapter());
    }
    if (!Hive.isAdapterRegistered(53)) {
      Hive.registerAdapter(MemPartsAdapter());
    }
    if (!Hive.isAdapterRegistered(54)) {
      Hive.registerAdapter(MemChecklistsAdapter());
    }
    if (!Hive.isAdapterRegistered(55)) {
      Hive.registerAdapter(MemChecksAdapter());
    }
    if (!Hive.isAdapterRegistered(56)) {
      Hive.registerAdapter(PositionsAdapter());
    }
    if (!Hive.isAdapterRegistered(57)) {
      Hive.registerAdapter(PhoneAdapter());
    }


    // ~cb-add-adapters~1

    // Open required boxes
    if (!Hive.isBoxOpen('usersBox')) {
      await Hive.openBox<User>('usersBox');
    }
    if (!Hive.isBoxOpen('profilesBox')) {
      await Hive.openBox<Profile>('profilesBox');
    }
    if (!Hive.isBoxOpen('inboxesBox')) {
      await Hive.openBox<Inbox>('inboxesBox');
    }
    if (!Hive.isBoxOpen('commentsBox')) {
      await Hive.openBox<Comment>('commentsBox');
    }
    if (!Hive.isBoxOpen('userInvitesBox')) {
      await Hive.openBox<UserInvite>('userInvitesBox');
    }
    if (!Hive.isBoxOpen('notificationsBox')) {
      await Hive.openBox<CBNotification>('notificationsBox');
    }
    if (!Hive.isBoxOpen('documentsStorageBox')) {
      await Hive.openBox<DocumentStorage>('documentsStorageBox');
    }
    if (!Hive.isBoxOpen('atlasTicketsBox')) {
      await Hive.openBox<AtlasTicket>('atlasTicketsBox');
    }
    if (!Hive.isBoxOpen('incomingMachineTicketsBox')) {
      await Hive.openBox<IncomingMachineTicket>('incomingMachineTicketsBox');
    }
    if (!Hive.isBoxOpen('externalTicketsBox')) {
      await Hive.openBox<ExternalTickets>('externalTicketsBox');
    }
    if (!Hive.isBoxOpen('externalChecklistsBox')) {
      await Hive.openBox<ExternalChecklists>('externalChecklistsBox');
    }
    if (!Hive.isBoxOpen('purchaseOrderItemsBox')) {
      await Hive.openBox<ExternalChecks>('externalChecksBox');
    }
    if (!Hive.isBoxOpen('machineMastersBox')) {
      await Hive.openBox<MachineMaster>('machineMastersBox');
    }
    if (!Hive.isBoxOpen('atlasChecklistsBox')) {
      await Hive.openBox<AtlasChecklists>('atlasChecklistsBox');
    }
    if (!Hive.isBoxOpen('atlasChecksBox')) {
      await Hive.openBox<AtlasChecks>('atlasChecksBox');
    }
    if (!Hive.isBoxOpen('incomingMachineChecklistsBox')) {
      await Hive.openBox<IncomingMachineChecklists>(
          'incomingMachineChecklistsBox');
    }
    if (!Hive.isBoxOpen('incomingMachineChecksBox')) {
      await Hive.openBox<IncomingMachineChecks>('incomingMachineChecksBox');
    }
    if (!Hive.isBoxOpen('jobStationsBox')) {
      await Hive.openBox<JobStations>('jobStationsBox');
    }
    if (!Hive.isBoxOpen('jobStationTicketsBox')) {
      await Hive.openBox<JobStationTicket>('jobStationTicketsBox');
    }
    if (!Hive.isBoxOpen('partsMastersBox')) {
      await Hive.openBox<PartsMaster>('partsMastersBox');
    }
    if (!Hive.isBoxOpen('customerPurchaseOrdersBox')) {
      await Hive.openBox<CustomerPurchaseOrders>('customerPurchaseOrdersBox');
    }
    if (!Hive.isBoxOpen('customerSalesOrdersBox')) {
      await Hive.openBox<CustomerSalesOrders>('customerSalesOrdersBox');
    }
    if (!Hive.isBoxOpen('deliveryOrderItemsBox')) {
      await Hive.openBox<DeliveryOrderItems>('deliveryOrderItemsBox');
    }
    if (!Hive.isBoxOpen('disposalDetailsBox')) {
      await Hive.openBox<DisposalDetails>('disposalDetailsBox');
    }
    if (!Hive.isBoxOpen('irmsDeliveryOrdersBox')) {
      await Hive.openBox<irmsDeliveryOrders>('irmsDeliveryOrdersBox');
    }
    if (!Hive.isBoxOpen('irmsQuotationsBox')) {
      await Hive.openBox<irmsQuotations>('irmsQuotationsBox');
    }
    if (!Hive.isBoxOpen('partRequestDetailsBox')) {
      await Hive.openBox<PartRequestDetails>('partRequestDetailsBox');
    }
    if (!Hive.isBoxOpen('purchaseOrderItemsBox')) {
      await Hive.openBox<PurchaseOrderItems>('purchaseOrderItemsBox');
    }
    if (!Hive.isBoxOpen('quotationItemsBox')) {
      await Hive.openBox<QuotationItems>('quotationItemsBox');
    }
    if (!Hive.isBoxOpen('salesOrderItemsBox')) {
      await Hive.openBox<SalesOrderItems>('salesOrderItemsBox');
    }
    if (!Hive.isBoxOpen('sampleDetailsBox')) {
      await Hive.openBox<SampleDetails>('sampleDetailsBox');
    }
    if (!Hive.isBoxOpen('stockInDetailsBox')) {
      await Hive.openBox<StockInDetails>('stockInDetailsBox');
    }
    if (!Hive.isBoxOpen('stockOutDetailsBox')) {
      await Hive.openBox<StockOutDetails>('stockOutDetailsBox');
    }
    if (!Hive.isBoxOpen('transferDetailsBox')) {
      await Hive.openBox<TransferDetails>('transferDetailsBox');
    }
    if (!Hive.isBoxOpen('warehouseMasterBox')) {
      await Hive.openBox<WarehouseMaster>('warehouseMasterBox');
    }

    if (!Hive.isBoxOpen('BranchesBox')) {
      await Hive.openBox<Branches>('BranchesBox');
    }
    if (!Hive.isBoxOpen('CompaniesBox')) {
      await Hive.openBox<Companies>('CompaniesBox');
    }
    if (!Hive.isBoxOpen('VendingMachinesBox')) {
      await Hive.openBox<VendingMachine>('VendingMachinesBox');
    }
    if (!Hive.isBoxOpen('atlasMachinesBox')) {
      await Hive.openBox<AtlasMachines>('atlasMachinesBox');
    }
    if (!Hive.isBoxOpen('irmsMachinesBox')) {
      await Hive.openBox<IrmsMachines>('irmsMachinesBox');
    }
    if (!Hive.isBoxOpen('memMachinesBox')) {
      await Hive.openBox<MemMachines>('memMachinesBox');
    }
    if (!Hive.isBoxOpen('externalMachinesBox')) {
      await Hive.openBox<ExternalMachines>('externalMachinesBox');
    }
    if (!Hive.isBoxOpen('jobStationQueuesBox')) {
      await Hive.openBox<JobStationQueue>('jobStationQueuesBox');
    }
    if (!Hive.isBoxOpen('irmsPartsBox')) {
      await Hive.openBox<IrmsParts>('irmsPartsBox');
    }
    if (!Hive.isBoxOpen('incomingMachineAbortHistoryBox')) {
      await Hive.openBox<IncomingMachineAbortHistory>('incomingMachineAbortHistoryBox');
    }
    if (!Hive.isBoxOpen('irmsWarehousePartsBox')) {
      await Hive.openBox<IrmsWarehouseParts>('irmsWarehousePartsBox');
    }
    if (!Hive.isBoxOpen('memTicketsBox')) {
      await Hive.openBox<MemTicket>('memTicketsBox');
    }
    if (!Hive.isBoxOpen('memPartsBox')) {
      await Hive.openBox<MemParts>('memPartsBox');
    }
    if (!Hive.isBoxOpen('memChecklistsBox')) {
      await Hive.openBox<MemChecklists>('memChecklistsBox');
    }
    if (!Hive.isBoxOpen('memChecksBox')) {
      await Hive.openBox<MemChecks>('memChecksBox');
    }
    if (!Hive.isBoxOpen('positionsBox')) {
      await Hive.openBox<Positions>('positionsBox');
    }

    //
    // ~cb-add-boxes~
  }

  List<SingleChildWidget> providers() {
    return [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => InboxProvider()),
      ChangeNotifierProvider(create: (_) => CommentProvider()),
      ChangeNotifierProvider(create: (_) => UserInviteProvider()),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ChangeNotifierProvider(create: (_) => DocumentStorageProvider()),
      ChangeNotifierProvider(create: (_) => ExternalTicketsProvider()),
      ChangeNotifierProvider(create: (_) => AtlasTicketProvider()),
      ChangeNotifierProvider(create: (_) => IncomingMachineTicketProvider()),
      ChangeNotifierProvider(create: (_) => ExternalChecklistsProvider()),
      ChangeNotifierProvider(create: (_) => ExternalChecksProvider()),
      ChangeNotifierProvider(create: (_) => MachineMasterProvider()),
      ChangeNotifierProvider(create: (_) => AtlasChecklistsProvider()),
      ChangeNotifierProvider(create: (_) => AtlasChecksProvider()),
      ChangeNotifierProvider(
          create: (_) => IncomingMachineChecklistsProvider()),
      ChangeNotifierProvider(create: (_) => IncomingMachineChecksProvider()),
      ChangeNotifierProvider(create: (_) => JobStationsProvider()),
      ChangeNotifierProvider(create: (_) => JobStationTicketProvider()),
      ChangeNotifierProvider(create: (_) => PartsMasterProvider()),
      ChangeNotifierProvider(create: (_) => CustomerPurchaseOrdersProvider()),
      ChangeNotifierProvider(create: (_) => CustomerSalesOrdersProvider()),
      ChangeNotifierProvider(create: (_) => DeliveryOrderItemsProvider()),
      ChangeNotifierProvider(create: (_) => DisposalDetailsProvider()),
      ChangeNotifierProvider(create: (_) => irmsDeliveryOrdersProvider()),
      ChangeNotifierProvider(create: (_) => irmsQuotationsProvider()),
      ChangeNotifierProvider(create: (_) => PartRequestDetailsProvider()),
      ChangeNotifierProvider(create: (_) => PurchaseOrderItemsProvider()),
      ChangeNotifierProvider(create: (_) => QuotationItemsProvider()),
      ChangeNotifierProvider(create: (_) => SalesOrderItemsProvider()),
      ChangeNotifierProvider(create: (_) => SampleDetailsProvider()),
      ChangeNotifierProvider(create: (_) => StockInDetailsProvider()),
      ChangeNotifierProvider(create: (_) => StockOutDetailsProvider()),
      ChangeNotifierProvider(create: (_) => TransferDetailsProvider()),
      ChangeNotifierProvider(create: (_) => WarehouseMasterProvider()),
      ChangeNotifierProvider(create: (_) => CompanyProvider()),
      ChangeNotifierProvider(create: (_) => VendingMachineProvider()),
      ChangeNotifierProvider(create: (_) => AtlasMachinesProvider()),
      ChangeNotifierProvider(create: (_) => IrmsMachinesProvider()),
      ChangeNotifierProvider(create: (_) => MemMachinesProvider()),
      ChangeNotifierProvider(create: (_) => ExternalMachinesProvider()),
      ChangeNotifierProvider(create: (_) => JobStationQueueProvider()),
      ChangeNotifierProvider(create: (_) => IrmsPartsProvider()),
      ChangeNotifierProvider(create: (_) => IncomingMachineAbortHistoryProvider()),
      ChangeNotifierProvider(create: (_) => IrmsWarehousePartsProvider()),
      ChangeNotifierProvider(create: (_) => MemTicketProvider()),
      ChangeNotifierProvider(create: (_) => MemPartsProvider()),
      ChangeNotifierProvider(create: (_) => MemChecklistsProvider()),
      ChangeNotifierProvider(create: (_) => MemChecksProvider()),
      ChangeNotifierProvider(create: (_) => PositionsProvider()),
      // ~cb-add-widgets~
    ];
  }
}
