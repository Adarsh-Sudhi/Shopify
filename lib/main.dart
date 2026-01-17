import 'package:avodha_interview_test/auth.dart';
import 'package:avodha_interview_test/view/authPages/login_page.dart';
import 'package:avodha_interview_test/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:avodha_interview_test/viewmodel/cart_bloc/cart_bloc.dart';
import 'package:avodha_interview_test/viewmodel/order_bloc/order_bloc.dart';
import 'package:avodha_interview_test/viewmodel/product_home_bloc/product_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> initHiveWithPath() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox('userBox');
  await Hive.openBox('sessionBox');
  await Hive.openBox('cart');
  await Hive.openBox("orders");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveWithPath();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => ProductHomeBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => OrderBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: AuthGate(),
      ),
    );
  }
}
