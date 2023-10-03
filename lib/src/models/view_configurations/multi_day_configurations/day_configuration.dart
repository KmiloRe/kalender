import 'package:flutter/material.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/view_configurations/view_configuration_export.dart';

/// The [DayConfiguration] class contains the configuration for the [SingleDayView].
///
/// This class contains the functions required to calculate the [DateTimeRange]s and indexes of a [SingleDayView].
/// It also contains some configuration values that are used to calculate the layout of the [SingleDayView].
class DayConfiguration extends MultiDayViewConfiguration {
  const DayConfiguration({
    this.timelineWidth = 56,
    this.hourLineTimelineOverlap = 8,
    this.multiDayTileHeight = 24,
    this.eventSnapping = false,
    this.timeIndicatorSnapping = false,
    this.createEvents = true,
    this.createMultiDayEvents = true,
    this.verticalStepDuration = const Duration(minutes: 15),
    this.verticalSnapRange = const Duration(minutes: 15),
    this.newEventDuration = const Duration(minutes: 15),
  });

  @override
  final double timelineWidth;

  @override
  final double hourLineTimelineOverlap;

  @override
  final double multiDayTileHeight;

  @override
  final Duration verticalStepDuration;

  @override
  final Duration verticalSnapRange;

  @override
  final bool eventSnapping;

  @override
  final bool timeIndicatorSnapping;

  @override
  final bool createEvents;

  @override
  final bool createMultiDayEvents;

  @override
  final Duration newEventDuration;

  @override
  int get firstDayOfWeek => 1;

  @override
  final Duration horizontalStepDuration = const Duration(days: 1);

  @override
  int get numberOfDays => 1;

  @override
  bool get paintWeekNumber => false;

  @override
  final String name = 'Day';

  @override
  DateTimeRange calculateVisibleDateTimeRange(
    DateTime date,
  ) {
    return date.dayRange;
  }

  @override
  DateTimeRange calculateAdjustedDateTimeRange({
    required DateTimeRange dateTimeRange,
    required DateTime visibleStart,
    int? firstDayOfWeek,
  }) {
    return DateTimeRange(
      start: dateTimeRange.start.startOfDay,
      end: dateTimeRange.end.endOfDay,
    );
  }

  @override
  int calculateDateIndex(
    DateTime date,
    DateTime startDate,
  ) {
    return date.difference(startDate).inDays;
  }

  @override
  int calculateNumberOfPages(
    DateTimeRange calendarDateTimeRange,
  ) {
    return calendarDateTimeRange.dayDifference;
  }

  @override
  DateTimeRange calculateVisibleDateRangeForIndex({
    required int index,
    required DateTime calendarStart,
    int? firstDayOfWeek,
  }) {
    return calendarStart.add(Duration(days: index)).dayRange;
  }

  @override
  MultiDayViewConfiguration copyWith({
    int? numberOfDays,
    double? timelineWidth,
    double? hourLineTimelineOverlap,
    double? multiDayTileHeight,
    Duration? verticalStepDuration,
    Duration? verticalSnapRange,
    Duration? newEventDuration,
    bool? paintWeekNumber,
    bool? eventSnapping,
    bool? timeIndicatorSnapping,
    int? firstDayOfWeek,
    bool? createEvents,
    bool? createMultiDayEvents,
  }) {
    return DayConfiguration(
      timelineWidth: timelineWidth ?? this.timelineWidth,
      hourLineTimelineOverlap:
          hourLineTimelineOverlap ?? this.hourLineTimelineOverlap,
      multiDayTileHeight: multiDayTileHeight ?? this.multiDayTileHeight,
      newEventDuration: newEventDuration ?? this.newEventDuration,
      eventSnapping: eventSnapping ?? this.eventSnapping,
      timeIndicatorSnapping:
          timeIndicatorSnapping ?? this.timeIndicatorSnapping,
      createEvents: createEvents ?? this.createEvents,
      createMultiDayEvents: createMultiDayEvents ?? this.createMultiDayEvents,
      verticalStepDuration: verticalStepDuration ?? this.verticalStepDuration,
      verticalSnapRange: verticalSnapRange ?? this.verticalSnapRange,
    );
  }

  // @override
  // DayConfiguration copyWith({
  //   int? numberOfDays,
  //   double? timelineWidth,
  //   double? hourLineTimelineOverlap,
  //   double? multiDayTileHeight,
  //   Duration? newEventDuration,
  //   bool? eventSnapping,
  //   bool? timeIndicatorSnapping,
  //   bool? createNewEvents,
  //   Duration? verticalStepDuration,
  //   Duration? verticalSnapRange,
  // }) {
  //   return DayConfiguration(
  //     timelineWidth: timelineWidth ?? this.timelineWidth,
  //     hourLineTimelineOverlap:
  //         hourLineTimelineOverlap ?? this.hourLineTimelineOverlap,
  //     multiDayTileHeight: multiDayTileHeight ?? this.multiDayTileHeight,
  //     newEventDuration: newEventDuration ?? this.newEventDuration,
  //     eventSnapping: eventSnapping ?? this.eventSnapping,
  //     timeIndicatorSnapping:
  //         timeIndicatorSnapping ?? this.timeIndicatorSnapping,
  //     createNewEvents: createNewEvents ?? this.createNewEvents,
  //     verticalStepDuration: verticalStepDuration ?? this.verticalStepDuration,
  //     verticalSnapRange: verticalSnapRange ?? this.verticalSnapRange,
  //   );
  // }
}