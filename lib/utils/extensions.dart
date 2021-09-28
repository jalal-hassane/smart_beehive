import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isNullOrEmpty(String? string) => string == null || string.isEmpty;

// unfocus
unFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

/*Future<void> launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  } else {
    throw 'Could not launch $url';
  }
}*/

showSnackBar(BuildContext context, String text, {SnackBarAction? action}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
      ),
      action: action,
    ),
  );
}