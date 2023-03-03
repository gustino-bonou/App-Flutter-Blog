import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_firebase/config/global.parents.dart';
import 'package:user_firebase/screens/add_article.dart';
import 'package:user_firebase/screens/authentification/login_by_email.dart';
import 'package:user_firebase/screens/carticles.dart';
import 'package:user_firebase/screens/mes_favoris.dart';

import 'package:user_firebase/screens/mes_article.dart';
import 'package:provider/provider.dart';
import 'package:user_firebase/screens/rechercer_article.dart';
import 'package:user_firebase/screens/sport.dart';
import 'package:user_firebase/services/auth_methode.dart';
import 'package:user_firebase/services/authentification.dart';
import 'package:user_firebase/wrapper.dart';
import 'screens/authentification/login_by_google.dart';

final d_green =   Color(0xFFFFFFF0);

//const d_green = Color(0xFFE97170);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   // options:
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
        StreamProvider.value(
            value: AuthService().user,
            initialData: null
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[250],
        textTheme: textTheme(),
        // iconTheme: IconThemeData(
        //   color: Colors.red,
        // ),
      ),

      routes: {
    "/": (context) => const Wrapper(),
    "/home": (context) => HomePage(),
    "/addArticle": (context) => AddArticlePage(user: user!),
    "/inscrire": (context) => const Login(),
    "/controlPage": (context) => SportArticle(),
    "/mesarticles": (context) => MesArticles(),
    "/favorite": (context) => MesFavoris(),
    "/rechercher": (context) => RechercheArticle(""),
    "/write": (context) => AddArticlePage(user: user!),
    "/emaillogin": (context) => EmailLogin(),
    },
      initialRoute: "/",
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return HomePage();
    }
    return const Login();
  }
}
