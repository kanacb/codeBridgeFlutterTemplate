import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vx_index/businesses/businessModel.dart';
import 'package:vx_index/businesses/businessesService.dart';
import 'package:vx_index/commodities/commoditiesService.dart';
import 'package:vx_index/commodities/commodityModel.dart';

class BusinessIcons extends StatefulWidget {
  const BusinessIcons({super.key});
  @override
  State<BusinessIcons> createState() => _BusinessIconsState();
}

class _BusinessIconsState extends State<BusinessIcons> {
  String? error;
  late bool _isLoading;
  List<Business> _businesses = [];
  BusinessesAPI businessesAPI = BusinessesAPI();

  fetchCommodities() {
    businessesAPI.getBusinesses().then(
      (response) {
        _isLoading = false;
        if (response.errorMessage == null) {
          setState(() {
            _businesses = response.data!;
            _isLoading = false;
          });
        } else {
          setState(() {
            error = response.errorMessage;
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    fetchCommodities();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _businesses.length,
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            return card(
                'https://loremflickr.com/640/480/nature?lock=98568', _businesses[index].name, _businesses[index].city, context);
          }),
    );
  }

  Widget card(String image, String title, String city, BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8.0,
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w100, fontSize: 12),),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Image.network(
              image,
              height: MediaQuery.of(context).size.width * (3 / 4) / 3,
              fit: BoxFit.fill,
            ),
          ),
          Text(city, style: TextStyle(fontWeight: FontWeight.w100, fontSize: 12),),
        ],
      ),
    );
  }
}
