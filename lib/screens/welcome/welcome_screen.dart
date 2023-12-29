import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vx_index/businesses/businessesScreen.dart';
import 'package:vx_index/categories/categoriesScreen.dart';
import 'package:vx_index/commodities/commoditiesScreen.dart';
import 'package:vx_index/screens/messages.dart';
import 'package:vx_index/screens/welcome/business_icon.dart';
import 'package:vx_index/screens/welcome/oils_icon.dart';
import 'package:vx_index/screens/widgets/nav_bar.dart';
import 'package:vx_index/screens/widgets/tab_bar.dart';
import 'package:vx_index/users/userModel.dart';
import 'package:vx_index/users/usersScreen.dart';

import '../../currencies/currenciesScreen.dart';
import '../../global.dart';
import 'app_bar_title.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.user});
  final User user;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
        title: const AppBarTitle(),
        backgroundColor: colorSecondary,
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
            icon: const Icon(Icons.favorite_outline),
            color: colorDanger,
            iconSize: 20,
          ),
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
      body: _selectedIndex == 0 ? buyer(context) : _selectedIndex == 1 ? seller(context) : admin(context),
      drawer: NavBar(
        user: widget.user,
      ),
      bottomNavigationBar: BottomTabBar(onItemTapped: _onItemTapped),
    );
  }

  Widget buyer(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        card(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQm1OLI1pm6htVR0lsDkuybur1gtyacpTIBAg&usqp=CAU",
            'Industrial Diesel Oils',
            context),
        const OilIcons(),
        Text(
          "RFQ Specially for you",
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: 13, foreground: Paint()),
        ),
        const BusinessIcons(),
        const Text("RFQ Just in"),
      ],
    );
  }

  Widget seller(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        card(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQm1OLI1pm6htVR0lsDkuybur1gtyacpTIBAg&usqp=CAU",
            'Industrial Diesel Oils',
            context),
        const OilIcons(),
        Text(
          "RFQ Specially for you",
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: 13, foreground: Paint()),
        ),
        const BusinessIcons(),
        const Text("RFQ Just in"),
      ],
    );
  }

  Widget admin(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        card(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQm1OLI1pm6htVR0lsDkuybur1gtyacpTIBAg&usqp=CAU",
            'Industrial Diesel Oils',
            context),
        const OilIcons(),
        Text(
          "RFQ Specially for you",
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: 13, foreground: Paint()),
        ),
        const BusinessIcons(),
        const Text("RFQ Just in"),
      ],
    );
  }

  Widget card(String image, String title, BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8.0,
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              title,
              style: TextStyle(fontSize: 12),
            ),
            const Text("RM 3.15/liter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.network(
              image,
              height: MediaQuery.of(context).size.width * (3 / 4) / 4,
              width: MediaQuery.of(context).size.width / 4,
            ),
          ),
        ],
      ),
    );
  }
}
