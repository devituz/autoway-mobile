import 'package:autoway/features/client/auth/register/presentation/cubit/register_cubit.dart';
import 'package:autoway/features/client/auth/register/presentation/pages/language_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('LanguagePage renders the 3 language chips + continue button',
      (tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('uz'), Locale('ru'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('uz'),
        child: BlocProvider(
          create: (_) => RegisterCubit(),
          child: const MaterialApp(home: LanguagePage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('O‘zbek'), findsOneWidget);
    expect(find.text('Русский'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
  });
}
