import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/platform.dart';
import 'package:kalender/src/widgets/components/resize_detector.dart';

class MultiDayEventTile<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> controller;

  final CalendarEvent<T> event;
  final CalendarCallbacks<T>? callbacks;
  final TileComponents<T> tileComponents;
  final double dayWidth;
  final bool allowResizing;

  /// Creates a new [MultiDayEventTile].
  const MultiDayEventTile({
    super.key,
    required this.eventsController,
    required this.controller,
    required this.event,
    required this.tileComponents,
    required this.dayWidth,
    required this.allowResizing,
    required this.callbacks,
  });

  @override
  State<MultiDayEventTile<T>> createState() => _MultiDayEventTileState<T>();
}

enum ResizeDirection {
  left,
  right,
  none,
}

class _MultiDayEventTileState<T extends Object?> extends State<MultiDayEventTile<T>> {
  EventsController<T> get eventsController => widget.eventsController;
  CalendarController<T> get controller => widget.controller;
  ViewController<T> get viewController => controller.viewController!;

  CalendarEvent<T> get event => widget.event;
  CalendarCallbacks<T>? get callbacks => widget.callbacks;
  TileComponents<T> get tileComponents => widget.tileComponents;
  double get dayWidth => widget.dayWidth;
  bool get allowResizing => widget.allowResizing;

  ValueNotifier<CalendarEvent<T>?> get eventBeingDragged {
    return widget.controller.eventBeingDragged;
  }

  ValueNotifier<Size> get feedbackWidgetSize {
    return eventsController.feedbackWidgetSize;
  }

  ValueNotifier<ResizeDirection> resizingDirection = ValueNotifier(ResizeDirection.none);

  @override
  Widget build(BuildContext context) {
    final onTap = callbacks?.onEventTapped;
    late final tileComponent = tileComponents.tileBuilder.call(widget.event);
    late final dragComponent = tileComponents.tileWhenDraggingBuilder?.call(widget.event);
    late final dragAnchorStrategy = tileComponents.dragAnchorStrategy;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder(
          valueListenable: resizingDirection,
          builder: (context, direction, child) {
            late final resizeWidth = min(constraints.maxWidth * 0.25, 12.0);
            late final resizeType =
                isMobileDevice ? ResizeDetectorType.horizontal : ResizeDetectorType.pan;

            // TODO: Check if the event continues before
            late final leftResize = ResizeDetectorWidget(
              type: resizeType,
              onUpdate: (_) => _onPanUpdate(_, ResizeDirection.left),
              onEnd: (_) => _onPanEnd(_, ResizeDirection.left),
              child: direction != ResizeDirection.none
                  ? null
                  : tileComponents.horizontalResizeHandle ?? const SizedBox(),
            );

            // TODO: Check if the event continues after
            late final rightResize = ResizeDetectorWidget(
              type: resizeType,
              onUpdate: (_) => _onPanUpdate(_, ResizeDirection.right),
              onEnd: (_) => _onPanEnd(_, ResizeDirection.right),
              child: direction != ResizeDirection.none
                  ? null
                  : tileComponents.horizontalResizeHandle ?? const SizedBox(),
            );

            late final feedback = ValueListenableBuilder(
              valueListenable: feedbackWidgetSize,
              builder: (context, value, child) {
                final feedbackTile = tileComponents.feedbackTileBuilder?.call(
                  widget.event,
                  value,
                );
                return feedbackTile ?? const SizedBox();
              },
            );

            final isDragging = controller.draggingEventId == event.id;
            late final draggableTile = Draggable<CalendarEvent<T>>(
              data: widget.event,
              feedback: feedback,
              childWhenDragging: dragComponent,
              dragAnchorStrategy: dragAnchorStrategy ?? childDragAnchorStrategy,
              child: isDragging && dragComponent != null ? dragComponent : tileComponent,
            );

            final tileWidget = GestureDetector(
              onTap: onTap != null
                  ? () {
                      // Find the global position and size of the tile.
                      final renderObject = context.findRenderObject()! as RenderBox;
                      onTap.call(widget.event, renderObject);
                    }
                  : null,
              child: draggableTile,
            );

            return Stack(
              children: [
                tileWidget,
                if (allowResizing && event.canModify)
                  if (!isMobileDevice)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      width: resizeWidth,
                      child: leftResize,
                    ),
                if (allowResizing && event.canModify)
                  if (!isMobileDevice)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      width: resizeWidth,
                      child: rightResize,
                    ),
              ],
            );
          },
        );
      },
    );
  }

  /// Called when the user is resizing the event.
  void _onPanUpdate(Offset delta, ResizeDirection direction) {
    resizingDirection.value = direction;
    final updatedEvent = _updateEvent(delta, direction);
    if (updatedEvent == null) return;
    eventBeingDragged.value = updatedEvent;
  }

  /// Called when the user has finished resizing the event.
  void _onPanEnd(Offset delta, ResizeDirection direction) {
    final updatedEvent = _updateEvent(delta, direction);
    if (updatedEvent == null) return;
    eventsController.updateEvent(
      event: widget.event,
      updatedEvent: updatedEvent,
    );

    callbacks?.onEventChanged?.call(event, updatedEvent);

    eventBeingDragged.value = null;
    resizingDirection.value = ResizeDirection.none;
  }

  /// Updates the [CalendarEvent] based on the [Offset] delta and [ResizeDirection].
  CalendarEvent<T>? _updateEvent(
    Offset delta,
    ResizeDirection direction,
  ) {
    final dateTimeRange = switch (direction) {
      ResizeDirection.left => _calculateDateTimeRangeLeft(delta),
      ResizeDirection.right => _calculateDateTimeRangeRight(delta),
      ResizeDirection.none => null,
    };

    return eventBeingDragged.value = event.copyWith(
      dateTimeRange: dateTimeRange,
    );
  }

  /// Calculates the number of days the event should be resized by.
  int _calculateDeltaDays(Offset delta) {
    final dayOffset = delta.dx / dayWidth;
    return dayOffset.isNegative ? dayOffset.ceil() : dayOffset.floor();
  }

  /// Calculates the [DateTimeRange] when resizing from the left.
  DateTimeRange? _calculateDateTimeRangeLeft(Offset delta) {
    final deltaDays = _calculateDeltaDays(delta);
    final start = event.start.addDays(deltaDays);

    if (start.isSameDay(event.end)) {
      return DateTimeRange(
        start: start.startOfDay,
        end: event.end.endOfDay,
      );
    } else if (start.isAfter(event.end)) {
      return DateTimeRange(
        start: event.end.startOfDay,
        end: start.endOfDay,
      );
    } else {
      return DateTimeRange(
        start: start,
        end: event.end,
      );
    }
  }

  /// Calculates the [DateTimeRange] when resizing from the right.
  DateTimeRange? _calculateDateTimeRangeRight(Offset offset) {
    final deltaDays = _calculateDeltaDays(offset);
    final end = event.end.addDays(deltaDays);

    if (end.isSameDay(event.start)) {
      return DateTimeRange(
        start: event.start.startOfDay,
        end: end.endOfDay,
      );
    } else if (end.isBefore(event.start)) {
      return DateTimeRange(
        start: end.startOfDay,
        end: event.start.startOfDay,
      );
    } else {
      return DateTimeRange(
        start: event.start,
        end: end,
      );
    }
  }
}
