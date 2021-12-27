import 'package:firebaseLoginBloc/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static SnackBar displaySnackBar(String message,
      {String actionMessage, VoidCallback onClick}) {
    return SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white, fontSize: 14.0)),
      action: (actionMessage != null)
          ? SnackBarAction(
              textColor: Colors.white,
              label: actionMessage,
              onPressed: () {
                return onClick();
              },
            )
          : null,
      duration: Duration(seconds: 2),
      backgroundColor: primaryColor,
    );
  }

  static void dismissProgressBar(context) {
    return Navigator.pop(context);
  }

  static Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  static Future<bool> displayToast(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: primaryColor,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}
