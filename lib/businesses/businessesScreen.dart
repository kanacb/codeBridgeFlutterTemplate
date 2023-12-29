import 'package:vx_index/businesses/businessDialogCreateScreen.dart';
import 'package:vx_index/businesses/businessDialogViewScreen.dart';
import 'package:vx_index/screens/widgets/loading.dart';
import 'package:flutter/material.dart';
import '../global.dart';
import 'businessModel.dart';
import 'businessesService.dart';
import "package:moment_dart/moment_dart.dart";

class BusinessesScreen extends StatefulWidget {
  const BusinessesScreen({super.key, this.scrollTo = 0});
  final int scrollTo;

  @override
  State<BusinessesScreen> createState() => _BusinessesScreenState();
}

class _BusinessesScreenState extends State<BusinessesScreen> {
  late bool isLoading;
  List<Business> businesses = [];
  String? error;
  BusinessesAPI businessesAPI = BusinessesAPI();

  fetchBusinesses() {
    businessesAPI.getBusinesses().then(
      (response) {
        isLoading = false;
        if (response.errorMessage == null) {
          setState(() {
            businesses = response.data!;
            isLoading = false;
          });
        } else {
          setState(() {
            error = response.errorMessage;
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  void initState() {
    isLoading = true;
    fetchBusinesses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 12,
        titleSpacing: 10,
        backgroundColor: colorPrimary,
        title: const Text(
          'App Businesses',
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        actions: [],
      ),
      body: isLoading
          ? const LoadingWidget()
          : error == null
              ? businesses.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "Businesses list is empty for now",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: businesses.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final DateTime tempDate =
                            DateTime.parse(businesses[index].updatedAt);
                        final moment =
                            Moment(tempDate, localization: LocalizationEnUs());
                        return ListTile(
                          leading: Text(moment.fromNow()),
                          title: Text(
                            businesses[index].name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            businesses[index].reg,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_rounded),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return BusinessDialogView(
                                      index: index, data: businesses[index]);
                                },
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          indent: 16,
                          endIndent: 16,
                          height: 1,
                        );
                      },
                    )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      error!,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                ),
    );
  }
}
