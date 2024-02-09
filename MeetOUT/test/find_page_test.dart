import 'package:dima_project/find_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('find page ...', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: FindPage(),
    ));

    expect(find.textContaining('Search'), findsOneWidget);
  });
}
