import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:vx_index/businesses/businessModel.dart';
import 'businessDialogEditScreen.dart';

class BusinessDialogView extends StatelessWidget {
  const BusinessDialogView({super.key, required this.index, required this.data});
  final int index;
  final Business data;

  @override
  Widget build(BuildContext context) {
    final DateTime tempCreatedAt = DateTime.parse(data.createdAt);
    final momentCreatedAt = Moment(tempCreatedAt, localization: LocalizationEnUs());
    final DateTime tempUpdatedAt = DateTime.parse(data.updatedAt);
    final momentUpdatedAt = Moment(tempUpdatedAt, localization: LocalizationEnUs());

    return Scaffold(
      appBar: AppBar(
        title: Text(data.name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BusinessDialogEditScreen(index: index, data: data);
                  },
                ),
              );
            },
            icon: const Icon(Icons.edit),
            color: const Color(0xFFfd2c2c),
            iconSize: 20,
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.only(
              top: 60.0, bottom: 20.0, left: 10.0, right: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widgetRow(context, "Name", data.name),
              widgetRow(context, "Type", data.businessType),
              widgetRow(context, "Registration", data.reg),
              widgetRow(context, "Phone", data.phone),
              widgetRow(context, "Mobile", data.mobile),
              widgetRow(context, "Address", data.address1),
              widgetRow(context, "Address", data.address2),
              widgetRow(context, "City", data.city),
              widgetRow(context, "Postal", data.postalcode),
              widgetRow(context, "State", data.state),
              widgetRow(context, "Country", data.country),
              widgetRow(context, "Created", momentCreatedAt.fromNow()),
              widgetRow(context, "Updated", momentUpdatedAt.fromNow())
            ],
          )),
    );
  }

  Widget widgetRow(BuildContext context, String field, dynamic value) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "$field:",
            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
          const SizedBox(
            width: 10,
          ),
          value.toString().length < 35
              ? Text(
                  value,
                  overflow: TextOverflow.fade,
                  maxLines: 4,
                  style: const TextStyle(
                      fontWeight: FontWeight.w100, fontSize: 15),
                )
              : Expanded(
                  child: Text(
                    value,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w100, fontSize: 15),
                  ),
                ),
        ]);
  }
}
