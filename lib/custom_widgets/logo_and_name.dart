import 'package:flutter/material.dart';

class LogoAndName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset('images/icons/cart_icon.png'),
            Positioned(
              bottom: 0,
              child: Text(
                'Buybes',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
