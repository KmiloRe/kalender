part of '../kalender_widgets.dart';

//todo k: I think this is unnecessary, maybe just use the enum from Event
//? duda jose: should I use the enum from Event?

class NewEventDialog extends StatefulWidget {
  const NewEventDialog({
    super.key,
    required this.dialogTitle,
    required this.event,
  });

  final String dialogTitle;
  final CalendarEvent<Event> event;

  @override
  State<NewEventDialog> createState() => _NewEventDialogState();
}

class _NewEventDialogState extends State<NewEventDialog> {
  late DateTimeRange dateTimeRange = widget.event.dateTimeRange;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(widget.dialogTitle),
      children: [
        TextFormField(
          initialValue: widget.event.eventData?.title,
          decoration: const InputDecoration(
            labelText: 'Titulo',
            isDense: true,
          ),
          onChanged: (value) {
            widget.event.eventData =
                widget.event.eventData?.copyWith(title: value);
          },
        ),
        TextFormField(
          initialValue: widget.event.eventData?.description,
          decoration: const InputDecoration(
            labelText: 'Descripcion',
            isDense: true,
          ),
          onChanged: (value) {
            widget.event.eventData =
                widget.event.eventData?.copyWith(description: value);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: DateTimeRangeEditor(
            dateTimeRange: dateTimeRange,
            onStartChanged: (dateTime) {
              if (dateTime.isAfter(dateTimeRange.end)) return;
              setState(() {
                dateTimeRange = DateTimeRange(
                  start: dateTime,
                  end: dateTimeRange.end,
                );
                widget.event.dateTimeRange = dateTimeRange;
              });
            },
            onEndChanged: (dateTime) {
              if (dateTime.isBefore(dateTimeRange.start)) return;
              setState(() {
                dateTimeRange = DateTimeRange(
                  start: dateTimeRange.start,
                  end: dateTime,
                );
                widget.event.dateTimeRange = dateTimeRange;
              });
            },
          ),
        ),
        Row(
          children: [
            //? duda david: esto si tiene valor para ellos?
            // DropdownMenu<Consultorio>(
            //   label: const Text('Profesional'),
            //   initialSelection:
            //       widget.event.eventData?.consultorio ?? Consultorio.ninguno,
            //   //? duda jose: esto esta bien hecho asi?
            //   dropdownMenuEntries: consultorios.map((consultorio) {
            //     return DropdownMenuEntry(
            //         value: consultorio, label: consultorio.title.toString());
            //   }).toList(),

            //   onSelected: (value) {
            //     if (value == null) return;
            //     widget.event.eventData =
            //         widget.event.eventData?.copyWith(consultorio: value);
            //   },
            // ),
            const Spacer(),
            //change this to <Consultorio> and add the dropdown menu entries
            DropdownMenu<Consultorio>(
              label: const Text('Consultorio'),
              initialSelection:
                  widget.event.eventData?.consultorio ?? Consultorio.ninguno,
              //? duda jose: esto esta bien hecho asi?
              dropdownMenuEntries: consultorios.map((consultorio) {
                return DropdownMenuEntry(
                    value: consultorio, label: consultorio.title.toString());
              }).toList(),

              onSelected: (value) {
                if (value == null) return;
                widget.event.eventData =
                    widget.event.eventData?.copyWith(consultorio: value);
              },
            )
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel),
              label: const Text('Cancelar'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop(widget.event);
              },
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
            ),
          ],
        )
      ],
    );
  }
}
