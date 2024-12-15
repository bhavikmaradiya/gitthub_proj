import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/theme_config.dart';
import '../const/assets.dart';
import '../const/dimens.dart';
import '../const/strings.dart';

class ToolBar extends StatelessWidget {
  final String title;
  final Function? onInwardSearch;
  final Function? onLogout;
  final Widget? starredFilter;

  const ToolBar({
    Key? key,
    required this.title,
    this.onInwardSearch,
    this.onLogout,
    this.starredFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            offset: Offset(
              0,
              Dimens.dimens_10.h,
            ),
            blurRadius: Dimens.dimens_5.r,
          ),
        ],
        color: Colors.white,
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: false,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(
            Dimens.dimens_10.r,
          ),
          child: UnconstrainedBox(
            child: SvgPicture.asset(
              Assets.icGithub,
              height: Dimens.dimens_30.w,
              width: Dimens.dimens_30.w,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: Dimens.dimens_20.sp,
            fontFamily: ThemeConfig.appFonts,
          ),
        ),
        actions: [
          if (starredFilter != null)
            Container(
              child: starredFilter!,
            ),
          if (starredFilter != null)
            SizedBox(
              width: Dimens.dimens_7.w,
            ),
          if (onInwardSearch != null)
            InkWell(
              onTap: () {
                onInwardSearch!();
              },
              borderRadius: BorderRadius.circular(
                Dimens.dimens_10.r,
              ),
              child: _inwardSearchWidget(
                appLocalizations,
              ),
            ),
          if (onLogout != null)
            InkWell(
              onTap: () {
                onLogout!();
              },
              borderRadius: BorderRadius.circular(
                Dimens.dimens_10.r,
              ),
              child: UnconstrainedBox(
                child: Padding(
                  padding: EdgeInsets.all(
                    Dimens.dimens_10.w,
                  ),
                  child: const Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _inwardSearchWidget(
    AppLocalizations appLocalizations,
  ) {
    return UnconstrainedBox(
      child: Padding(
        padding: EdgeInsets.all(
          Dimens.dimens_10.w,
        ),
        child: SvgPicture.asset(
          Assets.icSearch,
          width: Dimens.dimens_25.w,
          height: Dimens.dimens_25.w,
        ),
      ),
    );
  }
}
