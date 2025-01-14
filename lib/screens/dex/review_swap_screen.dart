import 'package:defi_wallet/bloc/account/account_cubit.dart';
import 'package:defi_wallet/bloc/bitcoin/bitcoin_cubit.dart';
import 'package:defi_wallet/bloc/tokens/tokens_cubit.dart';
import 'package:defi_wallet/bloc/transaction/transaction_bloc.dart';
import 'package:defi_wallet/bloc/transaction/transaction_state.dart';
import 'package:defi_wallet/config/config.dart';
import 'package:defi_wallet/services/hd_wallet_service.dart';
import 'package:defi_wallet/widgets/loader/loader_new.dart';
import 'package:defi_wallet/widgets/password_bottom_sheet.dart';
import 'package:defi_wallet/widgets/responsive/stretch_box.dart';
import 'package:defi_wallet/widgets/scaffold_constrained_box.dart';
import 'package:defi_wallet/helpers/balances_helper.dart';
import 'package:defi_wallet/models/token_model.dart';
import 'package:defi_wallet/screens/dex/swap_status.dart';
import 'package:defi_wallet/services/transaction_service.dart';
import 'package:defi_wallet/utils/app_theme/app_theme.dart';
import 'package:defi_wallet/widgets/buttons/restore_button.dart';
import 'package:defi_wallet/widgets/toolbar/main_app_bar.dart';
import 'package:defichaindart/defichaindart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './widgets/review_details.dart';

class ReviewSwapScreen extends StatefulWidget {
  final String assetFrom;
  final String assetTo;
  final double amountFrom;
  final double amountTo;
  final double slippage;
  final String btcTx;

  const ReviewSwapScreen(this.assetFrom, this.assetTo, this.amountFrom,
      this.amountTo, this.slippage,
      {this.btcTx = ''});

  @override
  _ReviewSwapScreenState createState() => _ReviewSwapScreenState();
}

class _ReviewSwapScreenState extends State<ReviewSwapScreen> {
  BalancesHelper balancesHelper = BalancesHelper();
  TransactionService transactionService = TransactionService();
  bool isFailed = false;
  double toolbarHeight = 55;
  double toolbarHeightWithBottom = 105;
  String secondStepLoaderText =
      'One second, Jelly is preparing your transaction!';
  String appBarTitle = 'Swap';

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) => ScaffoldConstrainedBox(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < ScreenSizes.medium) {
                return Scaffold(
                  body: _buildBody(context),
                  appBar: MainAppBar(
                      title: appBarTitle,
                      isShowBottom: !(state is TransactionInitialState),
                      height: !(state is TransactionInitialState)
                          ? toolbarHeightWithBottom
                          : toolbarHeight),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Scaffold(
                    body: _buildBody(context, isCustomBgColor: true),
                    appBar: MainAppBar(
                      title: appBarTitle,
                      action: null,
                      isShowBottom: !(state is TransactionInitialState),
                      height: !(state is TransactionInitialState)
                          ? toolbarHeightWithBottom
                          : toolbarHeight,
                      isSmall: true,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      );

  Widget _buildBody(context, {isCustomBgColor = false}) => Container(
        color: Theme.of(context).dialogBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        child: Center(
          child: StretchBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 12),
                    ReviewDetails(
                      tokenImgUrl:
                          tokenHelper.getImageNameByTokenName(widget.assetFrom),
                      amountStyling:
                          balancesHelper.numberStyling(widget.amountFrom),
                      currency: widget.assetFrom,
                      isBtc: widget.btcTx != '',
                    ),
                    SizedBox(height: 24),
                    Text(
                      'To',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 12),
                    ReviewDetails(
                      tokenImgUrl:
                          tokenHelper.getImageNameByTokenName(widget.assetTo),
                      amountStyling:
                          balancesHelper.numberStyling(widget.amountTo),
                      currency: widget.assetTo,
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Some error. Please try later',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: isFailed
                                  ? AppTheme.redErrorColor
                                  : Colors.transparent,
                            ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: BlocBuilder<AccountCubit, AccountState>(
                      builder: (context, state) {
                    return BlocBuilder<TokensCubit, TokensState>(
                      builder: (context, tokensState) {
                        if (tokensState.status == TokensStatusList.success) {
                          return PendingButton(
                            'SWAP',
                            isCheckLock: false,
                            callback: (parent) {
                              if (widget.btcTx != '') {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            LoaderNew(
                                      title: appBarTitle,
                                      secondStepLoaderText:
                                          secondStepLoaderText,
                                      callback: () {
                                        submitSwap(state, tokensState, "");
                                      },
                                    ),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              } else {
                                isCustomBgColor
                                    ? PasswordBottomSheet
                                        .provideWithPasswordFullScreen(
                                            context, state.activeAccount!,
                                            (password) async {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1,
                                                    animation2) =>
                                                LoaderNew(
                                              title: appBarTitle,
                                              secondStepLoaderText:
                                                  secondStepLoaderText,
                                              callback: () {
                                                submitSwap(
                                                  state,
                                                  tokensState,
                                                  password,
                                                );
                                              },
                                            ),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero,
                                          ),
                                        );
                                      })
                                    : PasswordBottomSheet.provideWithPassword(
                                        context, state.activeAccount!,
                                        (password) async {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1,
                                                    animation2) =>
                                                LoaderNew(
                                              title: appBarTitle,
                                              secondStepLoaderText:
                                                  secondStepLoaderText,
                                              callback: () {
                                                submitSwap(
                                                  state,
                                                  tokensState,
                                                  password,
                                                );
                                              },
                                            ),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero,
                                          ),
                                        );
                                      });
                              }
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      );

  submitSwap(state, tokenState, String password) async {
    if (state.status == AccountStatusList.success) {
      try {
        if (widget.btcTx != '') {
          BitcoinCubit bitcoinCubit = BlocProvider.of<BitcoinCubit>(context);
          var txResponse = await bitcoinCubit.sendTransaction(widget.btcTx);
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    SwapStatusScreen(
                        appBarTitle: appBarTitle,
                        txResponse: txResponse,
                        amount: widget.amountFrom,
                        assetFrom: widget.assetFrom,
                        assetTo: widget.assetTo),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ));
        }
        if (widget.assetFrom != widget.assetTo) {
          ECPair keyPair = await HDWalletService()
              .getKeypairFromStorage(password, state.activeAccount.index!);
          var txResponse = await transactionService.createAndSendSwap(
              keyPair: keyPair,
              account: state.activeAccount,
              tokenFrom: widget.assetFrom,
              tokenTo: widget.assetTo,
              amount: balancesHelper.toSatoshi(widget.amountFrom.toString()),
              amountTo: balancesHelper.toSatoshi(widget.amountTo.toString()),
              slippage: widget.slippage,
              tokens: tokenState.tokens);
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  SwapStatusScreen(
                      appBarTitle: appBarTitle,
                      txResponse: txResponse,
                      amount: widget.amountFrom,
                      assetFrom: widget.assetFrom,
                      assetTo: widget.assetTo),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      } catch (err) {
        setState(() {
          isFailed = true;
        });
      }
    }
  }
}
