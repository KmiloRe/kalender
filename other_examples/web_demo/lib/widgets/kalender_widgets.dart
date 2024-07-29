library kalender_widgets;

import 'dart:io';

import 'package:web_demo/models/event.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

import 'package:flutter/gestures.dart';

import 'package:flutter/services.dart';

import 'dart:ui';

import 'package:intl/intl.dart';

import 'package:web_demo/main.dart';
// external libraries
import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

//import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:go_router/go_router.dart';
//import 'package:multi_select_flutter/multi_select_flutter.dart';

// internal libraries
// import 'package:poinsa_test/common/common.dart';
// import 'package:poinsa_test/common/technical_report_helper.dart';
// import 'package:poinsa_test/model/model.dart';
// import 'package:poinsa_test/providers/providers.dart';
// import 'package:poinsa_test/utils/util.dart';

//parts
part 'event_tiles/event_tile.dart';
part 'event_tiles/multi_day_event_tile.dart';
part 'event_tiles/schedule_event_tile.dart';

part 'calendar/calendar_header.dart';
part 'calendar/calendar_widget.dart';
part 'calendar/calendar_zoom.dart';

part 'customize/calendar_customize.dart';
part 'customize/view_customize.dart';
part 'customize/theme_tile.dart';

part 'dialogs/date_time_range_editor.dart';
part 'dialogs/event_edit_dialog.dart';
part 'dialogs/new_event_dialog.dart';
//part 'dialogs/event_viewer.dart';

