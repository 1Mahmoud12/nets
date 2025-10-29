import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/network/local/cache.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/app_icons.dart';
import '../contacts_view.dart';

Widget buildContactCard(Map<String, String> contact, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: darkModeValue ? AppColors.darkModeColor : Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: darkModeValue ? Colors.grey[700]! : Colors.grey[200]!,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(darkModeValue ? 0.2 : 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        // onTap: () => showContactDetails(contact, context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar with status indicator
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryColor,
                    child: Text(
                      contact['name']!.split(' ').map((e) => e[0]).join(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 3,
                    right: 1,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: getStatusColor(contact['status']!),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: darkModeValue ? AppColors.white : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Contact info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact['name']!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color:
                            darkModeValue ? AppColors.white : AppColors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.call,

                          color:
                              darkModeValue
                                  ? Colors.grey[800]
                                  : Colors.grey[600],
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            contact['phone']!,
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(
                              color:
                                  darkModeValue
                                      ? Colors.white
                                      : Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.email,

                          color:
                              darkModeValue
                                  ? Colors.grey[800]
                                  : Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            contact['email']!,
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(
                              color:
                                  darkModeValue
                                      ? Colors.white
                                      : Colors.grey[600],
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          darkModeValue
                              ? AppColors.green.withOpacity(.2)
                              : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 10,
                      onPressed: () {
                        //  makeCall(contact['phone']!, context);
                      },
                      icon: SvgPicture.asset(
                        AppIcons.call,
                        colorFilter: ColorFilter.mode(
                          AppColors.greenWarm,
                          BlendMode.srcIn,
                        ),
                      ),
                      tooltip: 'Call',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // sendMessage(contact, context);
                      },
                      icon: SvgPicture.asset(
                        AppIcons.message,
                        color: AppColors.primaryColor,
                      ),
                      tooltip: 'Message',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
