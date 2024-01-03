import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vx_index/businesses/businessesScreen.dart';
import 'package:vx_index/categories/categoriesScreen.dart';
import 'package:vx_index/commodities/commoditiesScreen.dart';
import 'package:vx_index/messages/messages_screen.dart';
import 'package:vx_index/screens/widgets/nav_bar.dart';
import 'package:vx_index/screens/widgets/tab_bar.dart';
import 'package:vx_index/users/userModel.dart';
import 'package:vx_index/users/usersScreen.dart';

import '../../currencies/currenciesScreen.dart';
import '../../global.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key, required this.user});
  final User user;

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;
  List<String> image = [
    'https://cdn.pixabay.com/photo/2021/06/01/07/03/sparrow-6300790_960_720.jpg',
    'https://cdn.pixabay.com/photo/2017/10/20/10/58/elephant-2870777_960_720.jpg',
    'https://cdn.pixabay.com/photo/2014/09/08/17/32/humming-bird-439364_960_720.jpg',
    'https://cdn.pixabay.com/photo/2018/05/03/22/34/lion-3372720_960_720.jpg',
    'https://cdn.pixabay.com/photo/2021/06/01/07/03/sparrow-6300790_960_720.jpg',
    'https://cdn.pixabay.com/photo/2017/10/20/10/58/elephant-2870777_960_720.jpg',
    'https://cdn.pixabay.com/photo/2014/09/08/17/32/humming-bird-439364_960_720.jpg',
    'https://cdn.pixabay.com/photo/2018/05/03/22/34/lion-3372720_960_720.jpg',
    'https://cdn.pixabay.com/photo/2021/06/01/07/03/sparrow-6300790_960_720.jpg',
    'https://cdn.pixabay.com/photo/2017/10/20/10/58/elephant-2870777_960_720.jpg',
    'https://cdn.pixabay.com/photo/2014/09/08/17/32/humming-bird-439364_960_720.jpg',
    'https://cdn.pixabay.com/photo/2018/05/03/22/34/lion-3372720_960_720.jpg'
  ];
  List<Map<String, dynamic>> title = [
    {'name': 'Users', 'object': 'users', "screen": const UsersScreen()},
    {
      'name': 'Businesses',
      'object': 'businesses',
      "screen": const BusinessesScreen()
    },
    {
      'name': 'Currencies',
      'object': 'currencies',
      "screen": const CurrenciesScreen()
    },
    {
      'name': 'Categories',
      'object': 'categories',
      "screen": const CategoriesScreen()
    },
    {
      'name': 'Commodities',
      'object': 'commodities',
      "screen": const CommoditiesScreen()
    },
    {
      'name': 'Delivery methods',
      'object': 'deliverymethods',
      "screen": const UsersScreen()
    },
    {'name': 'Inboxes', 'object': 'inboxes', "screen": const UsersScreen()},
    {
      'name': 'Payment terms',
      'object': 'paymentterms',
      "screen": const UsersScreen()
    },
    {'name': 'Prices', 'object': 'categories', "screen": const UsersScreen()},
    {'name': 'Quotations', 'object': 'users', "screen": const UsersScreen()},
    {
      'name': 'request4quotes',
      'object': 'request4quotes',
      "screen": const UsersScreen()
    },
    {'name': 'won', 'object': 'rfqwons', "screen": const UsersScreen()},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VX Index"),
        backgroundColor: colorPrimary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const MessagesScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.notifications_outlined),
            color: colorDanger,
            iconSize: 20,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: title.length,
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          return card(image[index], title[index]['name'],
              title[index]['screen'], context);
        },
      ),
      drawer: NavBar(
        user: widget.user,
      ),
      bottomNavigationBar: BottomTabBar(onItemTapped: _onItemTapped),
    );
  }

  Widget card(String image, String title, screen, BuildContext context) {
    return Card(
      color: Colors.yellow[50],
      elevation: 8.0,
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.network(
              image,
              height: MediaQuery.of(context).size.width * (3 / 4),
              width: MediaQuery.of(context).size.width,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return screen;
                  },
                ),
              );
            },
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 38.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }
}
