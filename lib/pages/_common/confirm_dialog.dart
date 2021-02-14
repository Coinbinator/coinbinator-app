import 'package:flutter/material.dart';

/// todo: talvez trocar de "confirmação" por "negacao" ( ou criar um alias de negação, para evitar a necessidade de inverter o resultado nos "ifs" )
///
/// ex.:
///   // instead of
///   final confirmed = await askConfirmation();
///   if( !confirmed ) return cancelProcess();
///
///   // it would be
///   final denied = await askDenial();
///   if( denied ) return cancelProcess();
///
Future askConfirmation(
  BuildContext context, {
  Widget title,
  Widget content,
}) async {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () => Navigator.pop(context, false),
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed: () => Navigator.pop(context, true),
  );

  if (title == null) {
    title = Text("Confirm");
  }

  if (content == null) {
    content = Text("R U SURE?");
  }

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: title,
    content: content,
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
