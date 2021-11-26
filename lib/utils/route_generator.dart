import 'package:flutter/material.dart';
import '../views/home.dart';
import '../views/add_order_page.dart';
import '../views/history.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    //final args = settings.arguments;

    switch (settings.name) {
      case MyHomePage.id:
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case AddOrderPage.id:
        return MaterialPageRoute(builder: (_) => AddOrderPage());
      case History.id:
        return MaterialPageRoute(builder: (_) => const History());
      // Validation of correct data type
      /*       if (args is String) {
          return MaterialPageRoute(
            builder: (_) => SecondPage(
              data: args,
            ),
          );
        }*/
      // If args is not of the correct type, return an error page.
      // You can also throw an exception while in development.
      // return _errorRoute();
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
