import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  const FormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              maxLength: 50,
              decoration: InputDecoration(
                label: Text("Name"),
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                label: Text("Add"),
                icon: Icon(Icons.add),
              ),
            )
          ],
        ),
      ),
    );
  }
}
