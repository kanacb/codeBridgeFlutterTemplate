import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});


  @override
  Widget build(BuildContext context) {
    String cbLogo = 'assets/images/cb-logo.svg';
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Powered By", style: TextStyle(fontSize: 9),),
        SvgPicture.asset(
          cbLogo,
          width: 20,
          height: 20,
        ),
        const Text("CodeBridge", style: TextStyle(fontSize: 9),)
      ],
    );
  }
}
