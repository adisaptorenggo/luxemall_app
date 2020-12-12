import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:luxemall_app/utils/string_resource.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'dev_log.dart';

Future<ProgressDialog> loadingDialog(BuildContext context, String text) async{
  ProgressDialog progressDialog = ProgressDialog(
      context, type: ProgressDialogType.Normal,
      isDismissible: false, showLogs: kReleaseMode
  );

  progressDialog.style(
    message: text,
  );

  await progressDialog.show();
  return progressDialog;
}


void lxShowDialog(BuildContext context, String titleText, String contentText, {Function btnPressed}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titleText),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Center(child: Text(contentText)),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: (){
              DevLog.d(DevLog.ADI, 'Ok Button Pressed');
              Navigator.pop(context);
              if (btnPressed != null){
                btnPressed();
              }
            },
          ),
        ],
      );
    },
  );
}

void lxShowDialogTwoAction(BuildContext context, String titleText, String contentText, {Function btnPressed}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titleText),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Center(child: Text(contentText)),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: (){
              DevLog.d(DevLog.ADI, 'Cancel Button Pressed');
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: (){
              DevLog.d(DevLog.ADI, 'Ok Button Pressed');
              Navigator.pop(context);
              if (btnPressed != null){
                btnPressed();
              }
            },
          ),
        ],
      );
    },
  );
}

