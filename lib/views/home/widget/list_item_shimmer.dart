import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gitthub_proj/config/light_colors_config.dart';
import 'package:shimmer/shimmer.dart';

import '../../../const/dimens.dart';

class ListItemShimmer extends StatelessWidget {
  final int shimmerItemCount;

  const ListItemShimmer({
    Key? key,
    required this.shimmerItemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: shimmerItemCount,
      itemBuilder: (ctx, index) {
        return _itemWidget(context);
      },
    );
  }

  Widget _itemWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.dimens_20.w,
        vertical: Dimens.dimens_10.h,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!, // Dark gray base
        highlightColor: Colors.grey[600]!, // Light gray highlight
        child: Container(
          padding: EdgeInsets.all(
            Dimens.dimens_25.w,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: LightColorsConfig.lightBlackColor,
            ),
            borderRadius: BorderRadius.circular(
              Dimens.dimens_10.r,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name shimmer
              Container(
                height: Dimens.dimens_20.h,
                width: double.infinity,
                color: Colors.grey,
              ),
              SizedBox(
                height: Dimens.dimens_10.h,
              ),

              // Description shimmer
              Container(
                height: Dimens.dimens_14.h,
                width: double.infinity,
                color: Colors.grey,
              ),
              SizedBox(
                height: Dimens.dimens_10.h,
              ),

              // Stars and Forks Row shimmer
              Row(
                children: [
                  Container(
                    height: Dimens.dimens_14.h,
                    width: Dimens.dimens_80.w,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: Dimens.dimens_10.w,
                  ),
                  Container(
                    height: Dimens.dimens_14.h,
                    width: Dimens.dimens_80.w,
                    color: Colors.grey,
                  ),
                ],
              ),
              SizedBox(
                height: Dimens.dimens_10.h,
              ),

              // Last used date shimmer
              Container(
                height: Dimens.dimens_14.h,
                width: Dimens.dimens_150.w,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
