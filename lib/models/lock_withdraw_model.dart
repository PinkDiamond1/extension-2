class LockWithdrawModel {
  int? id;
  String? signMessage;
  String? signature;
  double? amount;

  LockWithdrawModel({
    this.id,
    this.signMessage,
    this.signature,
    this.amount,
  });

  LockWithdrawModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.signMessage = json["signMessage"];
    this.signature = json["signature"];
    this.amount = json["amount"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["signMessage"] = this.signMessage;
    data["signature"] = this.signature;
    data["amount"] = this.amount;

    return data;
  }
}
