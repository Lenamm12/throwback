import 'package:flutter/material.dart';
import '../models/element_model.dart';

class ElementSelectionScreen extends StatelessWidget {
  const ElementSelectionScreen({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Select Element Type',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ...ElementItemType.values.map((type) {
          return ListTile(
            title: Text(type.toString().split('.').last),
            onTap: () {
              Navigator.pop(context, type);
            },
          );
        }),
      ],
    );
  }
}
