part of '../kalender_widgets.dart';

class CalendarCustomize extends StatefulWidget {
  const CalendarCustomize({
    super.key,
    required this.currentConfiguration,
    required this.onStyleChange,
    required this.layoutDelegates,
    required this.style,
    required this.onCalendarLayoutChange,
  });

  final ViewConfiguration currentConfiguration;
  final CalendarStyle style;
  final CalendarLayoutDelegates layoutDelegates;
  final Function(CalendarStyle newStyle) onStyleChange;
  final Function(CalendarLayoutDelegates<Event> newLayout)
      onCalendarLayoutChange;

  @override
  State<CalendarCustomize> createState() => _CalendarCustomizeState();
}

class _CalendarCustomizeState extends State<CalendarCustomize> {
  final Color highlightColor = Colors.red;

  bool customLayoutController = false;

  // bool highlightCalendarHeader = false;
  // bool highlightDaySeparator = false;
  // bool highlightHourLine = false;
  // bool highlightDayHeader = false;

  // bool highlightTimeIndicator = false;
  // bool highlightTimeline = false;
  // bool highlightWeekNumber = false;
  // bool highlightMonthGrid = false;
  // bool highlightMonthCellHeaders = false;
  // bool highlightMonthHeader = false;

  // bool scheduleMonthHeader = false;
  // bool scheduleTilePaddingVertical = false;
  // bool scheduleTilePaddingHorizontal = false;

  @override
  Widget build(BuildContext context) {
    //todo k: comment but NOT delete the customization options
    return SingleChildScrollView(
      child: Column(
        children: [
          const ThemeTile(),
          if (widget.currentConfiguration is MultiDayViewConfiguration)
            SwitchListTile.adaptive(
              title: const Text('Tipo de distribución'),
              value: customLayoutController,
              onChanged: (value) {
                customLayoutController = value;
                //? duda jose: I don´t get how this changes the layout (I can see the change in the UI but I don´t get how it works)
                //todo k: maybe only allow custom layout for multi day view
                //todo k: move this to a provider
                if (value) {
                  widget.onCalendarLayoutChange(
                    CalendarLayoutDelegates<Event>(
                      tileLayoutDelegate: ({
                        required events,
                        required heightPerMinute,
                        required date,
                        required startHour,
                        required endHour,
                      }) =>
                          EventGroupBasicLayoutDelegate(
                        events: events,
                        date: date,
                        heightPerMinute: heightPerMinute,
                        startHour: startHour,
                        endHour: endHour,
                      ),
                    ),
                  );
                } else {
                  widget.onCalendarLayoutChange(
                    CalendarLayoutDelegates<Event>(),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
