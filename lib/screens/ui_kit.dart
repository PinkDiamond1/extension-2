import 'package:defi_wallet/bloc/theme/theme_cubit.dart';
import 'package:defi_wallet/helpers/settings_helper.dart';
import 'package:defi_wallet/mixins/snack_bar_mixin.dart';
import 'package:defi_wallet/models/settings_model.dart';
import 'package:defi_wallet/models/token_model.dart';
import 'package:defi_wallet/models/tx_error_model.dart';
import 'package:defi_wallet/widgets/buttons/flat_button.dart';
import 'package:defi_wallet/widgets/buttons/new_primary_button.dart';
import 'package:defi_wallet/widgets/defi_checkbox.dart';
import 'package:defi_wallet/widgets/dialogs/tx_status_dialog.dart';
import 'package:defi_wallet/widgets/fields/amount_field.dart';
import 'package:defi_wallet/widgets/fields/password_text_field.dart';
import 'package:defi_wallet/widgets/selectors/fees_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/selectors/app_selector.dart';

class UiKit extends StatefulWidget {
  const UiKit({Key? key}) : super(key: key);

  @override
  State<UiKit> createState() => _UiKitState();
}

class _UiKitState extends State<UiKit>
    with SnackBarMixin, SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: Duration(seconds: 2),
  )..repeat();
  TextEditingController controller = TextEditingController();
  bool isObscure1 = false;
  bool isObscure2 = true;
  bool value = false;
  List<String> tokensForSwap = [];
  TokensModel? currentAsset;

  @override
  void initState() {
    Future<Null>.delayed(Duration.zero, () {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ui kit'),
        actions: [
          ElevatedButton(
              onPressed: () {
                SettingsHelper settingsHelper = SettingsHelper();
                SettingsModel localSettings = SettingsHelper.settings.clone();
                localSettings.theme =
                    (localSettings.theme == 'Dark') ? 'Light' : 'Dark';
                SettingsHelper.settings = localSettings;
                settingsHelper.saveSettings();
                ThemeCubit themeCubit = BlocProvider.of<ThemeCubit>(context);
                themeCubit.changeTheme();
              },
              child: Icon(Icons.lightbulb))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AmountField(
                onChanged: (value) {
                  //
                },
                onAssetSelect: (TokensModel asset) {
                  print(asset.symbol);
                  setState(() {
                    currentAsset = asset;
                  });
                },
                selectedAsset: TokensModel(
                  name: 'Defi',
                  symbol: 'DFI',
                ),
                controller: TextEditingController(text: '200.50'),
                assets: [
                  TokensModel(
                    symbol: 'DFI',
                    name: 'Defi',
                  ),
                  TokensModel(
                    symbol: 'BTC',
                    name: 'Bitcoin',
                  ),
                  TokensModel(
                    symbol: 'ETH',
                    name: 'Ethereum',
                  ),
                  TokensModel(
                    symbol: 'BCH',
                    name: 'Bitcoin Cash',
                  ),
                  TokensModel(
                    symbol: 'DASH',
                    name: 'Dash',
                  ),
                  TokensModel(
                    symbol: 'XRP',
                    name: 'Ripple',
                  ),
                ],
              ),
              FeesSelector(
                onSelect: (int fee) {
                  //
                },
                activeFee: 2,
                fees: [2, 5, 10],
              ),
              Container(
                child: AppSelector(
                  items: [],
                  onSelect: (String value) {
                    //
                  },
                ),
              ),
              FlatButton(
                title: 'Buy/Sell',
                callback: () {
                  SnackBar snackBar = bottomSnackBar(
                    context,
                    color: Color(0xFF9490EA),
                    title: 'Waiting for transaction',
                    prefix: SizedBox(
                      width: 24,
                      height: 24,
                      child: Opacity(
                        opacity: 0.4,
                        child: RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0)
                              .animate(animationController),
                          child: SvgPicture.asset(
                            'assets/icons/circular_spinner.svg',
                          ),
                        ),
                      ),
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
              Row(
                children: [
                  FlatButton(
                    title: 'TxStatusDialog',
                    callback: () {
                      showDialog(
                        barrierColor: Color(0x0f180245),
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return TxStatusDialog(
                            title: 'Transaction initiated',
                            subtitle: 'Your transaction is now processed in the background. It will take up to 48h until the money arrives in your bank account. Thanks for choosing DFX.',
                            buttonLabel: 'Done',
                            txResponse: TxErrorModel(isError: true),
                            callbackOk: () {
                            },
                            callbackTryAgain: () async {
                            },
                          );
                        },
                      );
                    },
                  ),
                  FlatButton(
                    title: 'Change',
                    isPrimary: false,
                    callback: () {
                      //
                    },
                  ),
                ],
              ),
              PasswordTextField(
                  controller: controller,
                  hint: 'Password',
                  label: 'Password',
                  isShowObscureIcon: true,
                  isObscure: isObscure1,
                  onPressObscure: () {
                    setState(() {
                      isObscure1 = !isObscure1;
                    });
                  }),
              PasswordTextField(
                  controller: controller,
                  hint: 'Password',
                  label: 'Password',
                  isShowObscureIcon: true,
                  isObscure: isObscure2,
                  onPressObscure: () {
                    setState(() {
                      isObscure2 = !isObscure2;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: NewPrimaryButton(
                  title: "Create a new wallet",
                  callback: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: NewPrimaryButton(
                  title: "Create a new wallet",
                  callback: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NewPrimaryButton(
                      width: 150,
                      title: '150',
                      callback: () {},
                    ),
                    NewPrimaryButton(
                      width: value ? 100 : 150,
                      title: value ? '100' : '150',
                      callback: () => redirectToTest(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: DefiCheckbox(
                  callback: (val) {
                    setState(() {
                      value = !value;
                    });
                  },
                  value: value,
                  width: 250,
                  textWidget: Text(
                      'make a type specimen book. It has survived not only five centuries, but also the leap'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  redirectToTest() {}
}
