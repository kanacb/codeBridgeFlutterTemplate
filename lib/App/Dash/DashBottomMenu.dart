import '../../App/Dash/DashboardHelp.dart';
import '../../App/Dash/DashEditableCards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardBottomMenu extends StatelessWidget {
  const DashboardBottomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Manage cards'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EditableCardDash()));
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help'),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DashboardHelp())),
          ),
        ],
      ),
    );
  }
}
