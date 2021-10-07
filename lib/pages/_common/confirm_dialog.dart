import 'package:flutter/material.dart';

/// TODO: swap to "negation" or create ans "not'ed" alias for this function, if is "not'et" we don't need to negate on the caller
///
/// ex.:
///   // instead of
///   final confirmed = await askConfirmation();
///   if(!confirmed) return cancelProcess();
///
///   // it would be
///   final denied = await askDenial();
///   if(denied) return cancelProcess(); 
///
Future askConfirmation(
  BuildContext context, {
  Widget title,
  Widget content,
}) async {
  // set up the buttons

  if (title == null) title = Text("Confirm");
  // if (content == null) content = Text("R U SURE?");

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: title,
    content: content,
    actions: [
      TextButton(
        child: Text("CANCEL"),
        onPressed: () => Navigator.pop(context, false),
      ),
      TextButton(
        child: Text("OK"),
        onPressed: () => Navigator.pop(context, true),
      ),
    ],
  );

  // show the dialog
  final result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  return result == null ? false : result;
}
