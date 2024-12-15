import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gitthub_proj/config/app_config.dart';
import 'package:gitthub_proj/config/light_colors_config.dart';
import 'package:gitthub_proj/const/dimens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class RepoListItem extends StatelessWidget {
  final String? name;
  final String description;
  final int stars;
  final int forks;
  final String? lastUsed;

  const RepoListItem({
    Key? key,
    required this.name,
    required this.description,
    required this.stars,
    required this.forks,
    required this.lastUsed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final lastUpdated = lastUsed != null
        ? DateFormat(AppConfig.repoUpdatedDateFormat).format(DateTime.parse(lastUsed!))
        : appLocalizations.notAvailable;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.dimens_20.w,
        vertical: Dimens.dimens_10.h,
      ),
      child: Container(
        padding: EdgeInsets.all(
          Dimens.dimens_16.r,
        ),
        decoration: BoxDecoration(
          color: LightColorsConfig.lightBlackColor, // Dark card background
          borderRadius: BorderRadius.circular(
            Dimens.dimens_10.r,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Repository Name
            Text(
              name ?? appLocalizations.unknown,
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimens.dimens_20.sp,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: Dimens.dimens_10.h,
            ),

            // Repository Description
            Text(
              description.isNotEmpty
                  ? description
                  : appLocalizations.noDescription,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: Dimens.dimens_15.sp,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: Dimens.dimens_10.h,
            ),

            // Stars and Forks Row
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: Dimens.dimens_17.w,
                    ),
                    SizedBox(
                      width: Dimens.dimens_4.w,
                    ),
                    Text(
                      stars.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimens.dimens_15.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: Dimens.dimens_20.w,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.fork_right,
                      color: Colors.grey,
                      size: Dimens.dimens_17.w,
                    ),
                    SizedBox(
                      width: Dimens.dimens_4.w,
                    ),
                    Text(
                      forks.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimens.dimens_15.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: Dimens.dimens_10.h,
            ),

            // Last Used Date
            Text(
              appLocalizations.lastUpdated(
                lastUpdated,
              ),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: Dimens.dimens_13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
