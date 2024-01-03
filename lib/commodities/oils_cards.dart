import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vx_index/commodities/commoditiesService.dart';
import 'package:vx_index/commodities/commodityModel.dart';

class OilIcons extends StatefulWidget {
  const OilIcons({super.key});
  @override
  State<OilIcons> createState() => _OilIconsState();
}

class _OilIconsState extends State<OilIcons> {
  String? error;
  late bool _isLoading;
  List<Commodity> _commodities = [];
  CommoditiesAPI commoditiesAPI = CommoditiesAPI();

  fetchCommodities() {
    commoditiesAPI.getCommodities().then(
      (response) {
        _isLoading = false;
        if (response.errorMessage == null) {
          setState(() {
            _commodities = response.data!;
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
          itemCount: _commodities.length,
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            return card(
                _commodities[index].image, _commodities[index].name, context);
          }),
    );
  }

  Widget card(String image, String title, BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 8.0,
        margin: const EdgeInsets.all(4.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Image.network(
                  image,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(20),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
              ),
            ],
          ),
        ));
  }
}
