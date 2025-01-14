part of 'staking_cubit.dart';

enum StakingStatusList { initial, loading, success, restore, failure }

enum StakingType { Reinvest, Wallet, BankAccount }

class StakingState extends Equatable {
  final StakingStatusList status;
  final int amount;
  final StakingType rewardType;
  final StakingType paymentType;
  final AssetByFiatModel? rewardAsset;
  final AssetByFiatModel? paymentAsset;
  final IbanModel? paybackSell;
  final IbanModel? rewardSell;
  final String? depositAddress;
  final List<StakingModel>? routes;

  StakingState({
    this.status = StakingStatusList.success,
    this.amount = 0,
    this.rewardType = StakingType.Reinvest,
    this.paymentType = StakingType.Reinvest,
    this.rewardAsset,
    this.paymentAsset,
    this.paybackSell,
    this.rewardSell,
    this.depositAddress,
    this.routes,
  });

  @override
  List<Object?> get props => [
        status,
        amount,
        rewardType,
        paymentType,
        rewardAsset,
        paymentAsset,
        paybackSell,
        rewardSell,
        depositAddress,
        routes,
      ];

  StakingState copyWith({
    StakingStatusList? status,
    int? amount = 0,
    StakingType? rewardType,
    StakingType? paymentType,
    AssetByFiatModel? rewardAsset,
    AssetByFiatModel? paymentAsset,
    IbanModel? paybackSell,
    IbanModel? rewardSell,
    String? depositAddress,
    List<StakingModel>? routes,
  }) {
    return StakingState(
      status: status ?? this.status,
      amount: amount ?? this.amount,
      rewardType: rewardType ?? this.rewardType,
      paymentType: paymentType ?? this.paymentType,
      rewardAsset: rewardAsset ?? this.rewardAsset,
      paymentAsset: paymentAsset ?? this.paymentAsset,
      paybackSell: paybackSell ?? this.paybackSell,
      rewardSell: rewardSell ?? this.rewardSell,
      depositAddress: depositAddress ?? this.depositAddress,
      routes: routes ?? this.routes,
    );
  }
}
