import 'package:dima_project/tablet_find_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tablet find page ...', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: TabletFindPage(),
    ));
  });
}
