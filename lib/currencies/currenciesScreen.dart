import 'package:vx_index/screens/widgets/loading.dart';
import 'package:flutter/material.dart';

import 'currencyModel.dart';
import 'currenciesService.dart';

class CurrenciesScreen extends StatefulWidget {
  const CurrenciesScreen({super.key});

  @override
  State<CurrenciesScreen> createState() => _CurrenciesScreenState();
}

class _CurrenciesScreenState extends State<CurrenciesScreen> {
  late bool isLoading;
  List<Currency> currencies = [];
  String? error;

  fetchCurrencies() {
    print("fetchCurrencies");
    CurrenciesAPI currenciesAPI = CurrenciesAPI();
    currenciesAPI.getCurrencies().then(
      (response) {
        isLoading = false;
        if (response.errorMessage == null) {
          setState(() {
            currencies = response.data!;
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
    fetchCurrencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 12,
        titleSpacing: 10,
        title: const Text(
          'App Currencies',
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                fetchCurrencies();
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
              ? currencies.isEmpty
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
                      itemCount: currencies.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            currencies[index].currency,
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            currencies[index].code,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Clicked ${currencies[index].currency}"),
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
