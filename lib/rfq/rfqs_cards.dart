import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vx_index/rfq/rfq_model.dart';

import 'rfq_service.dart';

class RFQIcons extends StatefulWidget {
  const RFQIcons({super.key});
  @override
  State<RFQIcons> createState() => _RFQIconsState();
}

class _RFQIconsState extends State<RFQIcons> {
  String? error;
  late bool _isLoading;
  List<RFQ> _rfqs = [];
  RfqAPI rfqAPI = RfqAPI();

  fetchCommodities() {
    rfqAPI.getRFqs().then(
      (response) {
        _isLoading = false;
        if (response.errorMessage == null) {
          setState(() {
            _rfqs = response.data!;
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
          itemCount: _rfqs.length,
          itemBuilder: (
            BuildContext context,
            int index,
          ) {
            return card(
                _rfqs[index].quantity.toString(), _rfqs[index].isExpired! ? "true" : "false", context);
          }),
    );
  }

  Widget card(String image, String title, BuildContext context) {
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
        ],
      ),
    );
  }
}
