import 'package:flutter/material.dart';

class Selector extends StatefulWidget {
  const Selector({
    Key? key,
    required this.label,
    required this.items,
    required this.labelKey,
    required this.onSelect,
    this.itemWidget,
  }) : super(key: key);
  final String label;
  final List<dynamic> items;
  final String labelKey;
  final Function onSelect;
  final Function? itemWidget; 
  @override
  _SelectorState createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  TextEditingController textController = TextEditingController();

  void handleTap() {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
      context: context,
      builder: (context) => Dialog(
        items: widget.items,
        label: widget.label,
        labelKey: widget.labelKey,
        itemWidget: widget.itemWidget,
        onSelect: (item) {
          handleItemSelected(item);
        },
      ),
    );
  }

  handleItemSelected(item) {
    textController.text = item[widget.labelKey];
    widget.onSelect(item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        label: Text(widget.label),
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 2),
        ),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      onTap: () {
        handleTap();
      },
    );
  }
}

class Dialog extends StatefulWidget {
  const Dialog({
    Key? key,
    required this.items,
    required this.label,
    required this.labelKey,
    required this.onSelect,
    this.itemWidget
    
  }) : super(key: key);
  final List<dynamic> items;
  final String label;
  final String labelKey;
  final Function onSelect;
  final Function? itemWidget; 
  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
  List<dynamic> filteredItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      filteredItems = widget.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Pilih ${widget.label}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 13,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Cari ${widget.label}",
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
              ),
              onChanged: (keyword) {
                setState(() {
                  filteredItems = widget.items
                      .where(
                        (item) => item[widget.labelKey]
                            .toString()
                            .toLowerCase()
                            .contains(
                              keyword.toLowerCase(),
                            ),
                      )
                      .toList();
                });
              },
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: filteredItems
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          widget.onSelect(e);
                        },
                        child: widget.itemWidget != null ? widget.itemWidget!(e) : Column(
                          children: [
                            ListTile(
                              title: Text(e[widget.labelKey]),
                            ),
                            const Divider(
                              height: 2,
                            )
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
