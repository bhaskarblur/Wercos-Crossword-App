
import 'package:flutter/cupertino.dart';

class CustomImageButton extends StatelessWidget {
  const CustomImageButton({
  super.key, required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/images/inner_shadow.png",
           ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              image,

            ),
          ),
        ],
      ),
    );
  }
}