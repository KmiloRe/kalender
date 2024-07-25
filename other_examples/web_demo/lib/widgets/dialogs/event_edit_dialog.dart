import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/dialogs/date_time_range_editor.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

//todo k: I think this is unnecessary, maybe just use the enum from Event
//? duda jose: should I use the enum from Event?
List<Consultorio> consultorios = [
  Consultorio.consultorio_1,
  Consultorio.consultorio_2,
  Consultorio.consultorio_3,
  Consultorio.consultorio_4,
  Consultorio.consultorio_5,
  Consultorio.consultorio_6,
  Consultorio.consultorio_7,
  Consultorio.consultorio_8,
  Consultorio.consultorio_9,
  Consultorio.consultorio_10,
  Consultorio.consultorio_11,
  Consultorio.consultorio_12,
  Consultorio.ninguno,
  Consultorio.administracion
];

class EventEditDialog extends StatefulWidget {
  const EventEditDialog({
    super.key,
    required this.dialogTitle,
    required this.event,
    required this.deleteEvent,
    required this.cancelEdit,
  });

  final String dialogTitle;
  final CalendarEvent<Event> event;
  final void Function(CalendarEvent<Event> event) deleteEvent;
  //? duda jose: this is a void callback, how does this work?
  final VoidCallback cancelEdit;

  @override
  State<EventEditDialog> createState() => _EventEditDialogState();
}

class _EventEditDialogState extends State<EventEditDialog> {
  late DateTimeRange dateTimeRange = widget.event.dateTimeRange;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.dialogTitle),
          //! critical: esto es de cuidado, deberia pedir confirmación?
          //* O quiza deberia ser solo para punto y admin
          IconButton.filledTonal(
            tooltip: 'Borrar evento',
            onPressed: () {
              widget.deleteEvent(widget.event);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: DateTimeRangeEditor(
            dateTimeRange: widget.event.dateTimeRange,
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
            // DropdownMenu<Color>(
            //   label: const Text('Color'),
            //   initialSelection: widget.event.eventData?.color ?? Colors.blue,
            //   dropdownMenuEntries: const [
            //     DropdownMenuEntry(value: Colors.blue, label: 'azul'),
            //     DropdownMenuEntry(value: Colors.green, label: 'verde'),
            //     DropdownMenuEntry(value: Colors.red, label: 'rojo'),
            //     DropdownMenuEntry(value: Colors.orange, label: 'naranja'),
            //   ],
            //   onSelected: (value) {
            //     if (value == null) return;
            //     widget.event.eventData =
            //         widget.event.eventData?.copyWith(color: value);
            //   },
            // )
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
                widget.cancelEdit();
                Navigator.of(context).pop(false);
              },
              icon: const Icon(Icons.cancel),
              label: const Text('Cancelar'),
            ),
            TextButton.icon(
              onPressed: () {
                //? duda jose: this might break the other app
                Navigator.of(context).pop(true);
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
