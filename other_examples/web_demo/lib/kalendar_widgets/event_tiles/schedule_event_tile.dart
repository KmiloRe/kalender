part of '../kalender_widgets.dart';

class ScheduleTile extends StatelessWidget {
  const ScheduleTile({
    super.key,
    required this.event,
    required this.date,
  });
  final CalendarEvent<Event> event;
  final DateTime date;

//todo k: change this to just use consultorio

  @override
  Widget build(BuildContext context) {
    return Card(
      color: event.eventData?.consultorio!.color ?? Colors.blue,
      child: ListTile(
        title: Text(event.eventData?.title ?? ''),
        subtitle: Text(
          //event.eventData?.description ?? '',
          event.eventData?.consultorio!.title ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        mouseCursor: SystemMouseCursors.click,
        dense: true,
      ),
    );
  }
}
