import 'dart:math';

import 'package:build_link/data/model/event_model.dart';
import 'package:build_link/data/styles/colors.dart';
import 'package:build_link/data/styles/fonts.dart';
import 'package:build_link/data/styles/styles.dart';
import 'package:build_link/ui/widgets/event_card.dart';
import 'package:build_link/ui/widgets/heatmap_calendar/heatmap_calendar.dart';
import 'package:build_link/ui/widgets/space.dart';
import 'package:flutter/material.dart';

import '../../data/model/heatmap_color_mode.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeatMapCalendarExample();
}

class _HeatMapCalendarExample extends State<CalendarPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController heatLevelController = TextEditingController();

  bool isOpacityMode = true;

  Map<DateTime, int> heatMapDatasets = {};

  final eventList = [
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
    Event(
      "test",
      DateTime.now(),
      DateTime.now().add(const Duration(minutes: 90)),
    ),
  ];

  @override
  void initState() {
    Random r = Random();
    DateTime now = DateTime.now();
    heatMapDatasets = {
      for (int i = 0; i < 100; i++)
        DateTime(
          now.year,
          now.month,
          now.day,
        ).add(
          Duration(days: i),
        ): r.nextInt(15)
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: Column(
        children: [
          title,
          const Space(space: 16),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: double.infinity),
              child: Row(
                children: [
                  calendar,
                  const Space(
                    space: 16,
                    orientation: Axis.horizontal,
                  ),
                  eventsList,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get title {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Text(
            "Календарь",
            style: AppTextStyles.title.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const Spacer(),
          TextButton(
            style: AppButtonStyle.cardButton,
            onPressed: () {},
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                border: Border.all(color: AppColors.divider, width: 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              height: 48,
              child: Text(
                "Добавить событие",
                style: AppTextStyles.label.copyWith(
                  color: AppColors.accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget get calendar {
    return Container(
      alignment: Alignment.topCenter,
      child: HeatMapCalendar(
        size: 48,
        monthFontSize: 16,
        fontSize: 16,
        weekFontSize: 16,
        colorMode: ColorMode.opacity,
        weekTextColor: AppColors.accent,
        selectedColor: AppColors.accent,
        borderRadius: 8,
        selectedTextColor: AppColors.background,
        textColor: AppColors.text,
        defaultColor: AppColors.background,
        colorsets: {
          0: AppColors.accent,
        },
        onClick: (_) {
          //action
        },
      ),
    );
  }

  Widget get eventsList {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(minWidth: double.infinity),
        color: AppColors.background,
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  Text(
                    "События на ",
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.text,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Сегодня ",
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.accent,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: eventList.length,
                itemBuilder: (context, index) {
                  return EventCard(event: eventList[index]);
                },
                separatorBuilder: (context, index) {
                  return const Space(space: 8);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
