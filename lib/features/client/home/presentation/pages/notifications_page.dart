import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text.dart';
import '../widgets/home_app_bar.dart';

/// Notifications screen with two tabs: messages (Xabarlar) and news (Yangiliklar).
@RoutePage()
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _tab = 0;

  // Mock data — replaced by the API layer later.
  static const _messages = [
    (title: 'Profilingiz bloklandi', time: '16:18', date: '07.05.2025'),
    (title: 'Balansingiz yetarli emas', time: '16:18', date: '07.05.2025'),
    (title: 'Haydovchi harakatni boshladi', time: '16:18', date: '07.05.2025'),
  ];

  static const _news = [
    (
      time: '16:18',
      date: '07.05.2025',
      text:
          'Biz Yangi yonalishlarga start berdik! Endi Toshkent - Andijon yonalishlarda.'
    ),
    (
      time: '16:18',
      date: '07.05.2025',
      text:
          'Biz Yangi yonalishlarga start berdik! Endi Toshkent - Andijon yonalishlarda.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: SafeArea(
        child: Column(
          children: [
            HomeAppBar(
              leadingIcon: Icons.arrow_back_ios_new,
              onLeadingTap: () => context.router.maybePop(),
              onBellTap: () {},
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
              child: _SegmentedTabs(
                left: 'notifications.messages'.tr(),
                right: 'notifications.news'.tr(),
                index: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
            ),
            Expanded(
              child: _tab == 0 ? _buildMessages() : _buildNews(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
      itemCount: _messages.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (_, i) => _MessageTile(
        title: _messages[i].title,
        time: _messages[i].time,
        date: _messages[i].date,
      ),
    );
  }

  Widget _buildNews() {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
      itemCount: _news.length,
      separatorBuilder: (_, _) => SizedBox(height: 20.h),
      itemBuilder: (_, i) => _NewsCard(
        time: _news[i].time,
        date: _news[i].date,
        text: _news[i].text,
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final String left;
  final String right;
  final int index;
  final ValueChanged<int> onChanged;

  const _SegmentedTabs({
    required this.left,
    required this.right,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _segment(left, 0),
          _segment(right, 1),
        ],
      ),
    );
  }

  Widget _segment(String label, int i) {
    final selected = index == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 44.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            label,
            style: AppText.button.copyWith(
              color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  final String title;
  final String time;
  final String date;

  const _MessageTile({
    required this.title,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: const BoxDecoration(
              color: AppColors.fieldFill,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppText.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 4.h),
                Text('notifications.sub_information'.tr(),
                    style: AppText.subtitle
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time,
                  style: AppText.subtitle
                      .copyWith(color: AppColors.textPrimary)),
              SizedBox(height: 4.h),
              Text(date,
                  style: AppText.label
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String time;
  final String date;
  final String text;

  const _NewsCard({
    required this.time,
    required this.date,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.fieldFill,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(Icons.image_outlined,
              size: 64.sp, color: AppColors.textSecondary),
        ),
        SizedBox(height: 10.h),
        Text('$time $date',
            style: AppText.label.copyWith(color: AppColors.textSecondary)),
        SizedBox(height: 6.h),
        Text(text,
            style: AppText.bodyMedium.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
