import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:myopinionrocks_app/providers/user_provider.dart';
import 'package:myopinionrocks_app/screens/welcome_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'data/rest_client.dart';
import 'data/storage.dart';
import 'flavors.dart';
import 'globals.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // App
  await Env.init();
  packageInfo = await PackageInfo.fromPlatform();
  await MyStorage().init();

  runApp(EasyLocalization(
      useOnlyLangCode: true,
      supportedLocales:
          supportedLanguages.map((e) => Locale(e.languageCode)).toList(),
      fallbackLocale: Locale(supportedLanguages.first.languageCode),
      assetLoader: JsonAssetLoader(),
      path: 'assets/translations',
      child: MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ], child: const MyOpinionRocksApp())));
}

class MyOpinionRocksApp extends StatefulWidget {
  const MyOpinionRocksApp({super.key});

  @override
  State<MyOpinionRocksApp> createState() => _MyOpinionRocksAppState();
}

class _MyOpinionRocksAppState extends State<MyOpinionRocksApp> {
  @override
  void initState() {
    super.initState();
    RestClient().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyOpinionRocks',
      theme: theme,
      home: const WelcomeScreen(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}
