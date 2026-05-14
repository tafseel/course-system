import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:course_system/app.dart';
import 'package:course_system/providers/auth_provider.dart';
import 'package:course_system/providers/school_provider.dart';
import 'package:course_system/providers/test_provider.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProvider<SchoolProvider>(create: (_) => SchoolProvider()),
          ChangeNotifierProvider<TestProvider>(create: (_) => TestProvider()),
        ],
        child: const App(),
      ),
    );
    await tester.pump();
    expect(find.byType(App), findsOneWidget);
  });
}
