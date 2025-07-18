import 'package:financas_pessoais/firebase_options.dart';
import 'package:financas_pessoais/repository/cartao.dart';
import 'package:financas_pessoais/repository/contas.dart';
import 'package:financas_pessoais/repository/fatura.dart';
import 'package:financas_pessoais/repository/gastos.dart';
import 'package:financas_pessoais/repository/lancamentos.dart';
import 'package:financas_pessoais/repository/perfil.dart';
import 'package:financas_pessoais/routes/routes.dart';
import 'package:financas_pessoais/services/auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AuthService()),
      ChangeNotifierProvider<RepositoryContas>(create: (context) => RepositoryContas(auth: context.read<AuthService>())),
      ChangeNotifierProvider<RepositoryCartao>(create: (context) => RepositoryCartao(auth: context.read<AuthService>())),
      ChangeNotifierProvider<RepositoryLancamentos>(create: (context) => RepositoryLancamentos(auth: context.read<AuthService>())),
      ChangeNotifierProvider<RepositoryFatura>(create: (context) => RepositoryFatura(auth: context.read<AuthService>())),
      ChangeNotifierProvider<RepositoryGastos>(create: (context) => RepositoryGastos(auth: context.read<AuthService>())),
      ChangeNotifierProvider<RepositoryPerfil>(create: (context) => RepositoryPerfil(auth: context.read<AuthService>())),
    ], child: MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: Routes.list,
      initialRoute: Routes.initial,
      navigatorKey: Routes.navigatorKey,
    );
  }
}
