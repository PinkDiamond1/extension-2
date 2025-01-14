import 'dart:async';

import 'package:defi_wallet/bloc/account/account_cubit.dart';
import 'package:defi_wallet/bloc/transaction/transaction_state.dart';
import 'package:defi_wallet/client/hive_names.dart';
import 'package:defi_wallet/helpers/settings_helper.dart';
import 'package:defi_wallet/ledger/jelly_ledger.dart';
import 'package:defi_wallet/mixins/theme_mixin.dart';
import 'package:defi_wallet/screens/ledger/ledger_error_dialog.dart';
import 'package:defi_wallet/widgets/loader/jumping_dots.dart';
import 'package:defi_wallet/widgets/responsive/stretch_box.dart';
import 'package:defi_wallet/widgets/scaffold_wrapper.dart';
import 'package:defi_wallet/widgets/toolbar/welcome_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class LedgerAuthLoaderScreen extends StatefulWidget {
  final bool isFullSize;
  final Function() callback;
  final Function() errorCallback;
  String currentStatus;

  LedgerAuthLoaderScreen({
    Key? key,
    required this.callback,
    required this.errorCallback,
    this.isFullSize = true,
    this.currentStatus = 'first-step',
  }) : super(key: key);

  @override
  State<LedgerAuthLoaderScreen> createState() => _LedgerAuthLoaderScreenState();
}

class _LedgerAuthLoaderScreenState extends State<LedgerAuthLoaderScreen>
    with ThemeMixin {
  String firstStepText = 'One second, Jelly is searching for your addresses...';
  String secondStepText = 'Ugh.. What a mess...';
  String thirdStepText = 'Okay, almost done...';
  String currentText = '';

  // String currentStatus = 'first-step';
  double loaderImageWidth = 54;

  void initState() {
    super.initState();
  }

  Future init() async {
    var box = await Hive.openBox(HiveBoxes.client);
    await box.put(HiveNames.walletType, "ledger");
    await box.close();

    jellyLedgerInit();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentStatus == 'first-step') {
      currentText = firstStepText;
    }
    if (widget.currentStatus == 'first-step') {
      Future.delayed(const Duration(milliseconds: 10), () async {
        await restoreWallet();
      });
    }
    return ScaffoldWrapper(
      builder: (
        BuildContext context,
        bool isFullScreen,
        TransactionState txState,
      ) {
        return Scaffold(
          appBar: WelcomeAppBar(
            progress: 0.3,
            onBack: () {},
          ),
          body: Container(
            padding: EdgeInsets.only(
              top: 40,
              bottom: 24,
              left: 16,
              right: 16,
            ),
            child: Center(
              child: StretchBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/defi_love_ledger.png',
                              width: 304.99,
                              height: 247.3,
                            ),
                            SizedBox(
                              width: 23,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(
                          isDarkTheme()
                              ? 'assets/images/loader_dark_bg.gif'
                              : 'assets/images/loader_white_bg.gif',
                          width: loaderImageWidth,
                        ),
                        SizedBox(
                          height: 39,
                        ),
                        Container(
                          height: 153,
                          child: Text(
                            currentText,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .color!
                                          .withOpacity(0.6),
                                    ),
                          ),
                        ),
                      ],
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

  Future restoreWallet() async {
    await init();
    try {
      AccountCubit accountCubit = BlocProvider.of<AccountCubit>(context);
      await accountCubit.restoreLedgerAccount(SettingsHelper.settings.network,
          (need, restored) {
        getStatusText(widget.currentStatus, need, restored);
      });

      widget.callback!();
    } on Exception catch (error) {
      print(error);
      await showDialog(
        barrierColor: Color(0x0f180245),
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          return LedgerErrorDialog(error: error);
        },
      );
      widget.errorCallback();
    }
  }

  getStatusText(String currentStatus, int need, int restored) async {
    print(need);
    print(restored);
    print(currentStatus);
    if (currentStatus == 'first-step' && restored >= 3) {
      setState(() {
        widget.currentStatus = 'second-step';
        currentText = secondStepText;
      });
    }
    if (currentStatus == 'second-step' && restored >= 6) {
      setState(() {
        widget.currentStatus = 'third-step';
        currentText = thirdStepText;
      });
    }
    if (currentStatus == 'third-step' && need == restored) {
      widget.callback!();
    }
  }
}
