import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nets/core/themes/colors.dart';
import 'package:nets/core/utils/app_icons.dart';
import 'package:nets/core/utils/app_images.dart';

enum EmptyImages {
  emptyCartIc,
  noDonationsHistoryIc,
  noDonationsIc,
  noInternetConnection,
  actionBlocked,
  emptyWallet,
  newUpdates,
  noSearchResults,
  noMessagesInbox,
  noNotificationYet,
  appLogo,
  changePassword,
}

class EmptyWidget extends StatelessWidget {
  final String? data;
  final String? subData;
  final EmptyImages? emptyImage; // Make this nullable

  const EmptyWidget({super.key, this.data, this.emptyImage, this.subData});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  switch (emptyImage ?? EmptyImages.emptyCartIc) {
                    // Fallback to noOrders if null
                    EmptyImages.emptyCartIc => SvgPicture.asset(AppIcons.appLogo),
                    EmptyImages.noDonationsHistoryIc => SvgPicture.asset(AppIcons.appLogo),
                    EmptyImages.noDonationsIc => SvgPicture.asset(AppIcons.appLogo),
                    EmptyImages.noInternetConnection => Image.asset(AppImages.noInternetConnection),
                    EmptyImages.actionBlocked => Image.asset(AppImages.actionBlocked),
                    EmptyImages.emptyWallet => Image.asset(AppImages.emptyWallet),
                    EmptyImages.newUpdates => Image.asset(AppImages.newUpdates),
                    EmptyImages.noSearchResults => Image.asset(AppImages.noResult, width: 120, height: 120, fit: BoxFit.cover),
                    EmptyImages.noMessagesInbox => Image.asset(AppImages.noMessagesInbox),
                    EmptyImages.noNotificationYet => Image.asset(AppImages.noNotificationYet),
                    EmptyImages.appLogo => Image.asset(AppImages.logoApp),
                    EmptyImages.changePassword => Image.asset(AppImages.changePasswordPn),
                  },
                  const SizedBox(height: 20),
                  Text(
                    (data ?? 'no_Data,_sorry').tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  if (subData != null) const SizedBox(height: 8),
                  if (subData != null)
                    Text(
                      subData!.tr(),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.cP50.withAlpha((.5 * 255).toInt())),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
