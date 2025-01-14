import 'package:defi_wallet/bloc/transaction/transaction_state.dart';
import 'package:defi_wallet/config/config.dart';
import 'package:defi_wallet/screens/auth/password_screen.dart';
import 'package:defi_wallet/screens/auth/recovery/recovery_screen.dart';
import 'package:defi_wallet/screens/auth/signup/signup_placeholder_screen.dart';
import 'package:defi_wallet/screens/ledger/guide/connect_ledger_first_screen.dart';
import 'package:defi_wallet/utils/theme/theme.dart';
import 'package:defi_wallet/widgets/buttons/accent_button.dart';
import 'package:defi_wallet/widgets/buttons/new_primary_button.dart';
import 'package:defi_wallet/widgets/extension_welcome_bg.dart';
import 'package:defi_wallet/widgets/responsive/stretch_box.dart';
import 'package:defi_wallet/widgets/scaffold_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:defi_wallet/client/hive_names.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatelessWidget {
  signUpFlowCallback(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => PasswordScreen(
          onSubmitted: (String password) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    SignupPlaceholderScreen(
                  password: password,
                ),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(builder: (
      BuildContext context,
      bool isFullScreen,
      TransactionState txState,
    ) {
      return Scaffold(
        body: Stack(
          children: [
            ExtensionWelcomeBg(),
            Container(
              padding: authPaddingContainer.copyWith(top: 0, left: 0, right: 0),
              child: Center(
                child: StretchBox(
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                            // child: WelcomePositionedLogo(),
                            ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: isFullScreen
                                  ? buttonFullWidth
                                  : buttonSmallWidth,
                              child: AccentButton(
                                isOpasity: true,
                                isCheckLock: false,
                                label: 'Import using secret Recovery Phrase',
                                callback: () async {
                                  var box =
                                      await Hive.openBox(HiveBoxes.client);
                                  await box.put(HiveNames.openedMnemonic, null);
                                  await box.close();
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              RecoveryScreen(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                              ),
                            ),
                            // SizedBox(height: 12),
                            // Container(
                            //   width: isFullScreen
                            //       ? buttonFullWidth
                            //       : buttonSmallWidth,
                            //   child: AccentButton(
                            //     isOpasity: true,
                            //     isCheckLock: false,
                            //     label: 'Set up wallet with Ledger',
                            //     callback: () {
                            //       Navigator.push(
                            //         context,
                            //         PageRouteBuilder(
                            //           pageBuilder:
                            //               (context, animation1, animation2) =>
                            //                   ConnectLedgerFirstScreen(),
                            //           transitionDuration: Duration.zero,
                            //           reverseTransitionDuration: Duration.zero,
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                            SizedBox(height: 12),
                            NewPrimaryButton(
                              width: isFullScreen
                                  ? buttonFullWidth
                                  : buttonSmallWidth,
                              title: 'Create a new wallet',
                              callback: () => signUpFlowCallback(context),
                            ),
                            SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'By proceeding, you agree to these ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: Colors.white, fontSize: 11),
                                ),
                                InkWell(
                                  child: Text(
                                    'Terms and Conditions',
                                    style: jellyLink,
                                  ),
                                  onTap: () {
                                    launch(
                                      JellyLinks.termsAndConditions,
                                    );
                                  },
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
            )
          ],
        ),
      );
    });
  }
}
