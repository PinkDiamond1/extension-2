import 'dart:convert';
import 'package:defi_wallet/helpers/encrypt_helper.dart';
import 'package:defi_wallet/models/account_model.dart';
import 'package:defi_wallet/models/lock_analytics_model.dart';
import 'package:defi_wallet/models/lock_staking_model.dart';
import 'package:defi_wallet/models/lock_user_model.dart';
import 'package:defi_wallet/models/lock_withdraw_model.dart';
import 'package:defi_wallet/services/lock_service.dart';
import 'package:defichaindart/defichaindart.dart';
import 'package:http/http.dart' as http;


class LockRequests {
  LockService lockService = LockService();
  EncryptHelper encryptHelper = EncryptHelper();

  Future<String> signUp(AccountModel account, ECPair keyPair) async {
    try {
      dynamic data = lockService.getAddressAndSignature(account, keyPair);

      final Uri url = Uri.parse('https://api.lock.space/v1/auth/sign-up');

      final headers = {
        'Content-type': 'application/json',
      };

      final body = jsonEncode(data);

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body)['accessToken'];
      } else {
        return '';
      }
    } catch (_) {
      return '';
    }
  }

  Future<String> signIn(AccountModel account, ECPair keyPair) async {
    try {
      dynamic data = lockService.getAddressAndSignature(account, keyPair);

      final Uri url = Uri.parse('https://api.lock.space/v1/auth/sign-in');

      final headers = {
        'Content-type': 'application/json',
      };

      final body = jsonEncode(data);

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body)['accessToken'];
      } else {
        return '';
      }
    } catch (_) {
      return '';
    }
  }

  Future<LockUserModel?> getKYC(String accessToken) async {
    try {
      final Uri url = Uri.parse('https://api.lock.space/v1/kyc');

      final headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await http.post(url, headers: headers);
      dynamic data = jsonDecode(response.body);
      return LockUserModel.fromJson(data);
    } catch (_) {
      print(_);
      return null;
    }
  }

  Future<LockUserModel?> getUser(String accessToken) async {
    try {
      final Uri url = Uri.parse('https://api.lock.space/v1/user');

      final headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);

        return LockUserModel.fromJson(data);
      } else {
        throw Error.safeToString(response.statusCode);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<LockStakingModel?> getStaking(String accessToken) async {
    try {
      final Uri url = Uri.parse(
          'https://api.lock.space/v1/staking?asset=DFI&blockchain=DeFiChain&strategy=Masternode');

      final headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await http.get(url, headers: headers);
      dynamic data = jsonDecode(response.body);
      return LockStakingModel.fromJson(data);
    } catch (error) {
      return null;
    }
  }

  Future<bool> setDeposit(
    String accessToken,
    int stakingId,
    double amount,
    String txId,
  ) async {
    try {
      final Uri url =
          Uri.parse('https://api.lock.space/v1/staking/$stakingId/deposit');

      final headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      final body = jsonEncode({
        'amount': amount,
        'txId': txId,
        'asset': 'DFI', // TODO: remove 'DFI' and implement token selector
      });

      final response = await http.post(url, headers: headers, body: body);
      dynamic data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      print(_);
      return false;
    }
  }

  Future<LockWithdrawModel?> requestWithdraw(
    String accessToken,
    int stakingId,
    double amount,
  ) async {
    try {
      final Uri url =
          Uri.parse('https://api.lock.space/v1/staking/$stakingId/withdrawal');

      final headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      final body = jsonEncode({
        'amount': amount,
        'asset': 'DFI', // TODO: remove 'DFI' and implement token selector
      });

      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic data = jsonDecode(response.body);
        return LockWithdrawModel.fromJson(data);
      } else {
        return null;
      }
    } catch (_) {
      print(_);
      return null;
    }
  }

  Future<List<LockWithdrawModel>?> getWithdraws(
      String accessToken,
      int stakingId
      ) async {
    try {
      final Uri url =
      Uri.parse('https://api.lock.space/v1/staking/$stakingId/withdrawal/drafts');

      final headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> data = jsonDecode(response.body);
        List<LockWithdrawModel> list = List.generate(
            data.length, (index) => LockWithdrawModel.fromJson(data[index]));
        return list;
      } else {
        return null;
      }
    } catch (_) {
      print(_);
      return null;
    }
  }

  Future<LockWithdrawModel?> changeAmountWithdraw(
      String accessToken,
      int stakingId, int withdrawId, double amount
      ) async {
    try {
      final Uri url =
      Uri.parse('https://api.lock.space/v1/staking/$stakingId/withdrawal/$withdrawId/amount');

      final headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final body = jsonEncode({
        'amount': amount,
      });

      final response = await http.patch(url, headers: headers, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic data = jsonDecode(response.body);
        return LockWithdrawModel.fromJson(data);
      } else {
        return null;
      }
    } catch (_) {
      print(_);
      return null;
    }
  }

  Future<LockStakingModel?> signedWithdraw(
    String accessToken,
    int stakingId,
    LockWithdrawModel withdrawModel,
  ) async {
    try {
      final Uri url = Uri.parse(
          'https://api.lock.space/v1/staking/$stakingId/withdrawal/${withdrawModel.id}/sign');

      final headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      final body = jsonEncode({
        'signature': withdrawModel.signature,
      });

      final response = await http.patch(url, headers: headers, body: body);
      dynamic data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return LockStakingModel.fromJson(data);
      } else {
        return null;
      }
    } catch (_) {
      print(_);
      return null;
    }
  }

  Future<LockAnalyticsModel?> getAnalytics(String accessToken) async {
    try {
      final Uri url = Uri.parse('https://api.lock.space/v1/analytics/staking?asset=DFI&blockchain=DeFiChain&strategy=Masternode');

      final headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await http.get(url, headers: headers);
      dynamic data = jsonDecode(response.body);
      return LockAnalyticsModel.fromJson(data);
    } catch (_) {
      print(_);
      return null;
    }
  }
}
