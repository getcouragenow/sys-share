import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:sys_core/pkg/widgets/notification.dart';
import 'package:sys_share_sys_account_service/pkg/i18n/sys_account_localization.dart';
import 'package:sys_share_sys_account_service/pkg/shared_widgets/dialog_footer.dart';
import 'package:sys_share_sys_account_service/pkg/shared_widgets/dialog_header.dart';
import 'package:sys_share_sys_account_service/view/widgets/reset_password_dialog.dart';
import 'package:sys_share_sys_account_service/view/widgets/view_model/forgot_password_view_model.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({Key key}) : super(key: key);

  @override
  ForgotPasswordDialogState createState() => ForgotPasswordDialogState();
}

class ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _emailCtrl = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      viewModelBuilder: () => ForgotPasswordViewModel(),
      onModelReady: (ForgotPasswordViewModel model) {
        _emailCtrl.text = model.getEmail;
      },
      builder: (context, model, child) => Dialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 400,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  SharedDialogHeader(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      SysAccountLocalizations.of(context).translate('email'),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle2.color,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      controller: _emailCtrl,
                      autofocus: false,
                      onChanged: (v) => model.setEmail(v),
                      enabled: model.isEmailEnabled,
                      onSubmitted: (v) {
                        _emailFocusNode.unfocus();
                      },
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color),
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 3,
                          ),
                        ),
                        filled: true,
                        hintStyle: new TextStyle(
                          color: Colors.blueGrey[300],
                        ),
                        hintText: SysAccountLocalizations.of(context)
                            .translate('email'),
                        fillColor: Theme.of(context).dialogBackgroundColor,
                        errorText: model.validateEmailText(),
                        errorStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: double.maxFinite,
                            child: FlatButton(
                              color: Colors.blueGrey[700],
                              disabledColor: Colors.grey[400],
                              hoverColor: Colors.blueGrey[900],
                              highlightColor: Colors.black,
                              onPressed: model.isForgotPasswordValid
                                  ? () async {
                                      await model.submitEmail().then((_) {
                                        if (model.successMsg.isNotEmpty) {
                                          Navigator.pop(context);
                                          notify(
                                            context: context,
                                            message: model.successMsg,
                                            error: false,
                                          );
                                          showDialog(
                                            barrierDismissible: false,
                                            context: buildContext,
                                            builder: (context) =>
                                                ResetPasswordDialog(),
                                          );
                                        } else {
                                          notify(
                                              context: context,
                                              message: model.errMsg,
                                              error: true);
                                        }
                                      });
                                    }
                                  : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 15.0,
                                  bottom: 15.0,
                                ),
                                child: model.buzy
                                    ? SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : Text(SysAccountLocalizations.of(context)
                                        .translate('resetPassword')),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SharedDialogFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
