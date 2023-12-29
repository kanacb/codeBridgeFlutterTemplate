import 'package:vx_index/screens/widgets/loading.dart';
import 'package:flutter/material.dart';

import 'categoryModel.dart';
import 'categoriesService.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late bool isLoading;
  List<Category> categories = [];
  String? error;

  fetchCategories() {
    print("fetchCategories");
    CategoriesAPI categoriesAPI = CategoriesAPI();
    categoriesAPI.getCategories().then(
      (response) {
        isLoading = false;
        if (response.errorMessage == null) {
          setState(() {
            categories = response.data!;
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
    fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 12,
        titleSpacing: 10,
        title: const Text(
          'App Categories',
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                fetchCategories();
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
              ? categories.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "Categories list is empty for now",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: categories.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            categories[index].name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            categories[index].description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Clicked ${categories[index].name}"),
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
