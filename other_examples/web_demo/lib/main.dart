import 'dart:math';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/find_locale.dart';
import 'package:intl/intl.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/functions/generate_calendar_events.dart';
import 'package:web_demo/widgets/calendar/calendar_header.dart';
import 'package:web_demo/widgets/calendar/calendar_widget.dart';
import 'package:web_demo/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/widgets/calendar/calendar_zoom.dart';
import 'package:web_demo/widgets/customize/calendar_customize.dart';
import 'package:web_demo/widgets/customize/view_customize.dart';

void main() async {
  //? duda jose: do I need this?
  //final locale = await findSystemLocale();

  //? Could this cause a problem with data from firebase to pcs with diferent DateFormatting?

  final locale = 'es_US';
  Intl.defaultLocale = locale;
  await initializeDateFormatting(locale);
  print('\n\n\n\nlocale: $locale' + '\n\n\n\n');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  //todo k: move this to a provider
  ThemeMode themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender Example',
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      home: const MyHomePage(),
    );
  }

  void toggleTheme() {
    setState(() {
      themeMode =
          themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CalendarEventsController<Event> eventsController =
      CalendarEventsController<Event>();

  final CalendarController<Event> calendarController =
      CalendarController<Event>();

  late CalendarComponents calendarComponents;
  late CalendarStyle calendarStyle;
  late CalendarLayoutDelegates<Event> calendarLayoutDelegates;
  //note: 0 = vista dia, 1 = vista 2 dias, 2 = vista semana, 3 = vista semana laboral, 4 = vista mes, 5 = vista agenda, 6 = vista multi semana
  int currentConfiguration = 0;
  List<ViewConfiguration> viewConfigurations = [
    CustomMultiDayConfiguration(
      name: 'Día',
      numberOfDays: 1,
    ),
    CustomMultiDayConfiguration(
      name: '2 días',
      numberOfDays: 2,
    ),
    WeekConfiguration(),
    WorkWeekConfiguration(),
    MonthConfiguration(),
    ScheduleConfiguration(),
    MultiWeekConfiguration(),
  ];

  @override
  void initState() {
    super.initState();
    eventsController.addEvents(generateCalendarEvents());
    calendarComponents = CalendarComponents(
      calendarHeaderBuilder: _calendarHeaderBuilder,
      calendarZoomDetector: _calendarZoomDetectorBuilder,
    );
    calendarStyle = CalendarStyle(monthHeaderStyle: MonthHeaderStyle(
      stringBuilder: (date) {
        return DateFormat.EEEE(Intl.defaultLocale).format(date);
      },
    ), dayHeaderStyle: DayHeaderStyle(
      stringBuilder: (date) {
        return DateFormat('EEE', Intl.defaultLocale).format(date);
      },
    ), scheduleMonthHeaderStyle: ScheduleMonthHeaderStyle(
      stringBuilder: (date) {
        return DateFormat('yyyy - MMMM', Intl.defaultLocale).format(date);
      },
    ));
    calendarLayoutDelegates = CalendarLayoutDelegates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final calendarWidget = CalendarWidget(
              eventsController: eventsController,
              calendarController: calendarController,
              calendarComponents: calendarComponents,
              calendarStyle: calendarStyle,
              currentConfiguration: viewConfigurations[currentConfiguration],
              calendarLayoutDelegates: calendarLayoutDelegates,
              onDateTapped: () {
                setState(() {
                  currentConfiguration = 0;
                });
              },
            );

            final calendarCustomize = CalendarCustomize(
              currentConfiguration: viewConfigurations[currentConfiguration],
              style: calendarStyle,
              layoutDelegates: calendarLayoutDelegates,
              onStyleChange: (newStyle) {
                setState(() {
                  calendarStyle = newStyle;
                });
              },
              onCalendarLayoutChange: (newLayout) {
                setState(() {
                  calendarLayoutDelegates = newLayout;
                });
              },
            );

            // final viewConfigurationCustomize = ViewConfigurationCustomize(
            //   currentConfiguration: viewConfigurations[currentConfiguration],
            // );

            if (constraints.maxWidth < 500) {
              return calendarWidget;
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //util: el uso de Flexible facilita el hacer responsive el diseño
                  Flexible(
                    flex: 3,
                    child: calendarWidget,
                  ),
                  Flexible(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          calendarCustomize,
                          //todo D & K: check if this level of customization is needed
                          //viewConfigurationCustomize,
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _calendarHeaderBuilder(DateTimeRange visibleDateTimeRange) {
    return CalendarHeader(
      calendarController: calendarController,
      viewConfigurations: viewConfigurations,
      currentConfiguration: currentConfiguration,
      onViewConfigurationChanged: (viewConfiguration) {
        setState(() {
          currentConfiguration = viewConfiguration;
        });
      },
      visibleDateTimeRange: visibleDateTimeRange,
    );
  }

  Widget _calendarZoomDetectorBuilder(
      CalendarController controller, Widget child) {
    return CalendarZoomDetector(
      controller: controller,
      child: child,
    );
  }
}
