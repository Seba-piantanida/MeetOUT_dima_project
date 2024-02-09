import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/events_manager.dart';
import 'package:dima_project/my_profile_page.dart';
import 'package:dima_project/user_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('MyProfilePage Widget Test', () {
    setUpAll(() async {
      // Initialize Firebase before running tests
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
    });
    testWidgets('Renders MyProfilePage correctly', (WidgetTester tester) async {
      when(fetchMyUser()).thenReturn({
        'user-id': '1',
        'username': 'seba',
        'bio': 'bio test',
        'profile-pic': null,
        'my-events': ['eventsid'],
        'events': ['event'],
        'contacts': ['contactid']
      } as Future<Map<String, dynamic>>);
      when(getUserById('12')).thenReturn({
        'user-id': '12',
        'username': 'seba',
        'bio': 'bio test',
        'profile-pic': null,
        'my-events': ['eventsid'],
        'events': ['event'],
        'contacts': ['contactid']
      } as Future<Map<String, dynamic>>);
      when(getEventById('13')).thenReturn({
        'id': '13',
        'name': 'eventName',
        'description': 'test description',
        'icon': 'assets/events_icons/tropical-drink_1f379.png',
        'all-day': false,
        'date-time': Timestamp(10000, 10000),
        'images': [],
        'location': {'lat': 45.48008292982935, 'lng': 9.173457585275173},
        'owner': "asdfghjk"
      } as Future<Map<String, dynamic>>);

      // Build dell'app e attesa del caricamento

      await tester.pumpWidget(MaterialApp(
        home: MyProfilePage(),
      ));

      // Aspetta il caricamento dei dati
      await tester.pumpAndSettle();

      // Configura il mock per le funzioni globali o metodi di libreria

      // Expect per verificare la presenza dei dati sulla pagina
      expect(find.text("seba"), findsOneWidget);
      expect(find.text("bio test"), findsOneWidget);

      // Aggiungi ulteriori aspettative in base alla struttura del tuo widget
    });
  });
}
