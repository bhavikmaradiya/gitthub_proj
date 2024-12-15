import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../const/assets.dart';
import '../const/dimens.dart';

class AppSearchView extends StatelessWidget {
  final VoidCallback onCloseSearch;
  final Function(String) onTextChange;

  const AppSearchView({
    Key? key,
    required this.onCloseSearch,
    required this.onTextChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return ColoredBox(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: Dimens.dimens_20.sp,
              ),
              cursorColor: Colors.black,
              cursorWidth: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: appLocalizations.search,
                hintStyle: TextStyle(
                  fontSize: Dimens.dimens_20.sp,
                  color: Colors.grey,
                ),
                fillColor: Colors.white,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                onTextChange(value);
              },
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onCloseSearch();
              },
              borderRadius: BorderRadius.circular(
                Dimens.dimens_10.r,
              ),
              child: _closeSearchWidget(
                context,
                appLocalizations,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _closeSearchWidget(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    return UnconstrainedBox(
      child: Padding(
        padding: EdgeInsets.all(
          Dimens.dimens_10.w,
        ),
        child: SvgPicture.asset(
          Assets.icClose,
          width: Dimens.dimens_30.w,
          height: Dimens.dimens_30.w,
        ),
      ),
    );
  }
}
