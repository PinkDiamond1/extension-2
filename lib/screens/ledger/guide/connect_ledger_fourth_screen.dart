import 'package:defi_wallet/bloc/transaction/transaction_state.dart';
import 'package:defi_wallet/ledger/jelly_ledger.dart';
import 'package:defi_wallet/mixins/theme_mixin.dart';
import 'package:defi_wallet/screens/ledger/guide/connect_ledger_final_screen.dart';
import 'package:defi_wallet/screens/ledger/ledger_error_dialog.dart';
import 'package:defi_wallet/screens/ledger/loaders/ledger_auth_loader_screen.dart';
import 'package:defi_wallet/widgets/buttons/accent_button.dart';
import 'package:defi_wallet/widgets/buttons/new_primary_button.dart';
import 'package:defi_wallet/widgets/dotted_tab.dart';
import 'package:defi_wallet/widgets/responsive/stretch_box.dart';
import 'package:defi_wallet/widgets/scaffold_wrapper.dart';
import 'package:defi_wallet/widgets/toolbar/welcome_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart';

class ConnectLedgerFourthScreen extends StatefulWidget {
  const ConnectLedgerFourthScreen({Key? key}) : super(key: key);

  @override
  State<ConnectLedgerFourthScreen> createState() =>
      _ConnectLedgerFourthScreenState();
}

class _ConnectLedgerFourthScreenState extends State<ConnectLedgerFourthScreen>
    with ThemeMixin {
  String subtitleText =
      'Once you set up the wallet with Ledger you can only use Jellywallet with Ledger.';
  String titleText = '4.';

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      builder: (
        BuildContext context,
        bool isFullScreen,
        TransactionState txState,
      ) {
        return Scaffold(
          appBar: WelcomeAppBar(
            progress: 0.3,
          ),
          body: Container(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 24,
              left: 16,
              right: 16,
            ),
            child: Center(
              child: StretchBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 29,
                        ),
                        Image.asset(
                          'assets/images/defi_ledger_screen.png',
                          width: 268.7,
                          height: 247.3,
                        ),
                        // SizedBox(
                        //   width: 23,
                        // ),
                      ],
                    ),
                    Container(
                      child: Column(
                        children: [
                          DottedTab(
                            tabLenth: 4,
                            selectTabIndex: 4,
                          ),
                          SizedBox(
                            height: 19,
                          ),
                          Text(
                            '$titleText Connect Ledger',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 105,
                            child: Text(
                              subtitleText,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .color!
                                        .withOpacity(0.6),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 104,
                                child: AccentButton(
                                  callback: () {
                                    Navigator.pop(context);
                                  },
                                  label: 'Back',
                                ),
                              ),
                              NewPrimaryButton(
                                width: 104,
                                callback: () async {
                                  var usbSupported =
                                      await promiseToFuture(isUsbSupported());

                                  if (usbSupported > 0) {
                                    await showDialog(
                                      barrierColor: Color(0x0f180245),
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return LedgerErrorDialog(
                                            error: new Exception(usbSupported ==
                                                    1
                                                ? "USB_NOT_ALLOWED_IN_POPUP"
                                                : "NO_USB_DEVICE_SELECTED"));
                                      },
                                    );
                                    if (usbSupported == 1) {
                                      openInTab();
                                    }
                                    return;
                                  }
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              LedgerAuthLoaderScreen(
                                        callback: () {
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1,
                                                      animation2) =>
                                                  ConnectLedgerFinalScreen(),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration:
                                                  Duration.zero,
                                            ),
                                          );
                                        },
                                        errorCallback: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                                title: 'Next',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
