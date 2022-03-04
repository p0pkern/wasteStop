import 'package:flutter/material.dart';
import './screens/detailed_view.dart';
import './screens/entry_lists.dart';
import './screens/add_entry.dart';

class App extends StatelessWidget {

  App({Key? key}) : super(key: key);

  final routes = {
    EntryLists.routeName : (context) => const EntryLists(),
    DetailedView.routeName : (context) => const DetailedView(),
    AddEntry.routeName : (context) => const AddEntry(),
  };

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: MaterialApp(
          title: 'wasteStop',
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
          routes: routes,
          initialRoute: EntryLists.routeName,
      ),
    );
  }
}

/* Citation:
 * Date: 3/4/22
 * Function: DismissKeyboard Stateless Widget
 * Description: I needed a way to dismiss the keyboard when clicking away from 
 * a TextFieldEntry. This worked really well.
 * Link: https://www.kindacode.com/article/flutter-dismiss-keyboard-when-tap-outside-text-field/
 */
class DismissKeyboard extends StatelessWidget {
  final Widget child;

  const DismissKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus &&
           currentFocus.focusedChild != null) {
             FocusManager.instance.primaryFocus?.unfocus();
           }
         },
      child: child
    );
  }

}