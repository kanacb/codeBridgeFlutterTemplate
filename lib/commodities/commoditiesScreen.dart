import 'package:vx_index/screens/widgets/loading.dart';
import 'package:flutter/material.dart';

import 'commodityModel.dart';
import 'commoditiesService.dart';

class CommoditiesScreen extends StatefulWidget {
  const CommoditiesScreen({super.key});

  @override
  State<CommoditiesScreen> createState() => _CommoditiesScreenState();
}

class _CommoditiesScreenState extends State<CommoditiesScreen> {
  late bool isLoading;
  List<Commodity> commodities = [];
  String? error;

  fetchCommodities() {
    print("fetchCommodities");
    CommoditiesAPI commoditiesAPI = CommoditiesAPI();
    commoditiesAPI.getCommodities().then(
      (response) {
        isLoading = false;
        if (response.errorMessage == null) {
          setState(() {
            commodities = response.data!;
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
    fetchCommodities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 12,
        titleSpacing: 10,
        title: const Text(
          'App Commodities',
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                fetchCommodities();
              });
            },
            icon: const Icon(Icons.refresh_rounded),
            color: const Color(0xFFfd2c2c),
            iconSize: 20,
          ),
        ],
      ),
      body: isLoading
          ? const LoadingWidget()
          : error == null
              ? commodities.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "Commodities list is empty for now",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: commodities.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            commodities[index].name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            commodities[index].description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Clicked ${commodities[index].name}"),
                                elevation: 2,
                                duration: const Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(5),
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
