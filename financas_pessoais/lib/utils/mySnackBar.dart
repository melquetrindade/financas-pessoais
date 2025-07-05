import 'package:flutter/material.dart';

class MySnackBar {
  MySnackBar._();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mensagem(
      String label, Color cor, Icon icon, String menssage, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          icon,
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              menssage,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
      backgroundColor: cor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      duration: Duration(seconds: 10),
      action: SnackBarAction(
        label: label,
        textColor: Colors.white,
        onPressed: () {},
      ),
    ));
  }
}