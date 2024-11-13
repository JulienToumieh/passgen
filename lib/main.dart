import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(400, 420),
    center: true,
    title: "PassGen",
  );

  await windowManager.setMinimumSize(const Size(400, 420));
  await windowManager.setMaximumSize(const Size(400, 420));

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PassGen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark, // Set dark theme as default
      home: const MyHomePage(title: 'PassGen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isCheckedUppercase = true;
  bool _isCheckedLowercase = true;
  bool _isCheckedNumbers = true;
  bool _isCheckedSpecials = true;

  String lowercase = "abcdefghijklmnopqrstuvwxyz";
  String uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  String numbers = "0123456789";
  String specials = "!@#\$%^&*()-_=+[]{};:'\",.<>?/|`~\\";

  int passwordLength = 12;

  String generatedPassword = "";

  void _generatePassword() {
    String genPass = "";
    String chars = "";

    if (_isCheckedLowercase) chars += lowercase;
    if (_isCheckedUppercase) chars += uppercase;
    if (_isCheckedNumbers) chars += numbers;
    if (_isCheckedSpecials) chars += specials;

    if (chars.isEmpty) {
      setState(() {
        generatedPassword = "Please select at least one character set!";
      });
      return;
    }

    List<String> charList = chars.split('');
    charList.shuffle(Random());

    for (int i = 0; i < passwordLength; i++) {
      genPass += charList[Random().nextInt(charList.length)];
    }

    setState(() {
      generatedPassword = genPass;
    });
  }

  void _copyToClipboard() {
    if (generatedPassword.isNotEmpty &&
        generatedPassword != "Please select at least one character set!") {
      Clipboard.setData(ClipboardData(text: generatedPassword));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password copied to clipboard!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No password to copy!')),
      );
    }
  }

  void _onCheckboxChangedUppercase(bool? value) {
    setState(() {
      _isCheckedUppercase = value ?? false;
    });
  }

  void _onCheckboxChangedLowercase(bool? value) {
    setState(() {
      _isCheckedLowercase = value ?? false;
    });
  }

  void _onCheckboxChangedNumbers(bool? value) {
    setState(() {
      _isCheckedNumbers = value ?? false;
    });
  }

  void _onCheckboxChangedSpecials(bool? value) {
    setState(() {
      _isCheckedSpecials = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "PassGen",
              style: TextStyle(
                fontSize: 28, // Set the font size here
              ),
            ),
            const SizedBox(height: 4),
            Container(
              margin: EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColorLight,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                generatedPassword,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20, // Set the font size here
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _copyToClipboard,
                    child: const Text('Copy Password'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _generatePassword,
                    child: const Text('Generate Password'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Text(
                  'Password Length: $passwordLength',
                  style: const TextStyle(fontSize: 18),
                ),
                Slider(
                  value: passwordLength.toDouble(),
                  min: 4,
                  max: 32, // Number of steps between the min and max
                  label: passwordLength.toString(),
                  onChanged: (double newValue) {
                    setState(() {
                      passwordLength = newValue.toInt();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize:
                  MainAxisSize.min, // Ensure Row takes up only the space needed
              children: [
                Column(
                  mainAxisSize: MainAxisSize
                      .min, // Ensure Column takes up only the space needed
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align children to the left
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: _isCheckedLowercase,
                          onChanged: _onCheckboxChangedLowercase,
                        ),
                        const Text("Lowercase"),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: _isCheckedNumbers,
                          onChanged: _onCheckboxChangedNumbers,
                        ),
                        const Text("Numbers"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 40),
                Column(
                  mainAxisSize: MainAxisSize
                      .min, // Ensure Column takes up only the space needed
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align children to the left
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: _isCheckedUppercase,
                          onChanged: _onCheckboxChangedUppercase,
                        ),
                        const Text("Uppercase"),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: _isCheckedSpecials,
                          onChanged: _onCheckboxChangedSpecials,
                        ),
                        const Text("Special Characters"),
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
