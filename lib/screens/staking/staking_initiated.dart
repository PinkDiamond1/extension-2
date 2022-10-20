import 'package:defi_wallet/bloc/transaction/transaction_bloc.dart';
import 'package:defi_wallet/config/config.dart';
import 'package:defi_wallet/models/tx_error_model.dart';
import 'package:defi_wallet/screens/home/home_screen.dart';
import 'package:defi_wallet/widgets/buttons/primary_button.dart';
import 'package:defi_wallet/widgets/responsive/stretch_box.dart';
import 'package:defi_wallet/widgets/scaffold_constrained_box.dart';
import 'package:defi_wallet/widgets/toolbar/auth_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StakingInitiated extends StatelessWidget {
  final TxErrorModel? txResponse;

  const StakingInitiated({Key? key, this.txResponse}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScaffoldConstrainedBox(
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < ScreenSizes.medium) {
            return Scaffold(
              appBar: AuthAppBar(),
              body: _buildBody(context),
            );
          } else {
            return Container(
              padding: EdgeInsets.only(top: 20),
              child: Scaffold(
                appBar: AuthAppBar(
                  isSmall: false,
                ),
                body: _buildBody(context, isCustomBgColor: true),
              ),
            );
          }
        }),
      );

  Widget _buildBody(context, {isCustomBgColor = false}) {
    TransactionCubit transactionCubit =
        BlocProvider.of<TransactionCubit>(context);

    transactionCubit.setOngoingTransaction(txResponse!.txid!);
    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Center(
          child: StretchBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        txResponse!.isError
                            ? 'assets/error_gif.gif'
                            : 'assets/success_gif.gif',
                        height: 126,
                        width: 124,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 60),
                        child: Text(
                          txResponse!.isError
                              ? 'Something went wrong'
                              : 'Transaction initiated',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      if (!txResponse!.isError)
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          width: 300,
                          child: Text(
                            'Your transaction is now processed in the background. You will receive a confirmation Email from DFX. It can take up to 24h until your staking balance is updated. ',
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                    ],
                  ),
                ),
                PrimaryButton(
                  label: 'Done ',
                  callback: () {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              HomeScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}