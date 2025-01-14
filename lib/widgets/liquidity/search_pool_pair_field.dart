import 'package:defi_wallet/bloc/tokens/tokens_cubit.dart';
import 'package:defi_wallet/mixins/theme_mixin.dart';
import 'package:defi_wallet/utils/app_theme/app_theme.dart';
import 'package:defi_wallet/utils/theme/theme.dart';
import 'package:defi_wallet/widgets/responsive/stretch_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPoolPairField extends StatefulWidget {
  final TextEditingController controller;
  final TokensState tokensState;

  const SearchPoolPairField(
      {Key? key, required this.controller, required this.tokensState})
      : super(key: key);

  @override
  State<SearchPoolPairField> createState() => _SearchPoolPairFieldState();
}

class _SearchPoolPairFieldState extends State<SearchPoolPairField>
    with ThemeMixin {
  @override
  Widget build(BuildContext context) {
    TokensCubit tokensCubit = BlocProvider.of<TokensCubit>(context);
    return Container(
      height: 48,
      width: 280,
      child: TextField(
        style: Theme.of(context).textTheme.headline4,
        textAlignVertical: TextAlignVertical.center,
        controller: widget.controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.portage.withOpacity(0.12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.pinkColor),
          ),
          isDense: true,
          hintText: 'Search for pool pairs',
          hintStyle: Theme.of(context).textTheme.headline5!.copyWith(
                fontSize: 12,
                color: Theme.of(context)
                    .textTheme
                    .headline5!
                    .color!
                    .withOpacity(0.3),
              ),
          prefixIcon: Icon(
            Icons.search,
            size: 16,
          ),
          contentPadding: const EdgeInsets.only(top: 4, right: 16),
        ),
        onChanged: (value) async {
          tokensCubit.search(widget.tokensState.tokens, value);
        },
      ),
    );
  }
}
