import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordlegame/pages/settings.dart';
import 'package:wordlegame/providers/controller.dart';
import 'package:wordlegame/utils/quick_box.dart';
import '../components/grid.dart';
import '../components/keyboard_row.dart';
import '../components/stats_box.dart';
import '../constants/words.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _word;

  @override
  void initState() {
    final r = Random().nextInt(words.length);
    _word = words[r];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<Controller>(context, listen: false)
          .setCorrectWord(word: _word);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle Game'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Consumer<Controller>(
            builder: (_, notifier, __) {
              if (notifier.notEnoughLetters) {
                runQuickBox(context: context, message: 'Not Enough Letters');
              }
              if (notifier.gameCompleted) {
                if (notifier.gameWon) {
                  if (notifier.currentRow == 6) {
                    runQuickBox(context: context, message: 'Phew!');
                  } else {
                    runQuickBox(context: context, message: 'Splendid!');
                  }
                } else {
                  runQuickBox(context: context, message: notifier.correctWord);
                }
                Future.delayed(
                  const Duration(milliseconds: 4000),
                  () {
                    if (mounted) {
                      showDialog(
                          context: context, builder: (_) => const StatsBox());
                    }
                  },
                );
              }
              return IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context, builder: (_) => const StatsBox());
                  },
                  icon: const Icon(Icons.bar_chart_outlined));
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Settings()));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: const Column(
        children: [
          Divider(
            height: 2,
            thickness: 2,
          ),
          Expanded(flex: 12, child: Grid()),
          Expanded(
              flex: 4,
              child: Column(
                children: [
                  KeyboardRow(
                    min: 1,
                    max: 10,
                  ),
                  KeyboardRow(
                    min: 11,
                    max: 19,
                  ),
                  KeyboardRow(
                    min: 20,
                    max: 29,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

// by using KMP algo

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:wordlegame/pages/settings.dart';
// import 'package:wordlegame/providers/controller.dart';
// import 'package:wordlegame/utils/quick_box.dart';
// import '../components/grid.dart';
// import '../components/keyboard_row.dart';
// import '../components/stats_box.dart';
// import '../constants/words.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late String _word;
//   late List<int> _patternOccurrences;

//   @override
//   void initState() {
//     final r = Random().nextInt(words.length);
//     _word = words[r];
//     _patternOccurrences =
//         kmpSearch(_word, _word); // Find occurrences of the word itself

//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       Provider.of<Controller>(context, listen: false)
//           .setCorrectWord(word: _word);
//     });
//     super.initState();
//   }

//   List<int> kmpSearch(String text, String pattern) {
//     final int n = text.length;
//     final int m = pattern.length;
//     final List<int> lps = List<int>.filled(m, 0);

//     int j = 0;
//     for (int i = 1; i < m; i++) {
//       while (j > 0 && pattern[i] != pattern[j]) {
//         j = lps[j - 1];
//       }
//       if (pattern[i] == pattern[j]) {
//         j++;
//       }
//       lps[i] = j;
//     }

//     final List<int> occurrences = [];
//     j = 0;
//     for (int i = 0; i < n; i++) {
//       while (j > 0 && text[i] != pattern[j]) {
//         j = lps[j - 1];
//       }
//       if (text[i] == pattern[j]) {
//         j++;
//       }
//       if (j == m) {
//         occurrences.add(i - m + 1);
//         j = lps[j - 1];
//       }
//     }

//     return occurrences;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Wordle Game'),
//         centerTitle: true,
//         elevation: 0,
//         actions: [
//           Consumer<Controller>(
//             builder: (_, notifier, __) {
//               if (notifier.notEnoughLetters) {
//                 runQuickBox(context: context, message: 'Not Enough Letters');
//               }
//               if (notifier.gameCompleted) {
//                 if (_patternOccurrences.isNotEmpty) {
//                   runQuickBox(context: context, message: 'Correct Guess!');
//                   // Handle game won logic here
//                 } else {
//                   runQuickBox(context: context, message: 'Incorrect Guess');
//                   // Handle game lost logic here
//                 }
//                 Future.delayed(
//                   const Duration(milliseconds: 4000),
//                   () {
//                     if (mounted) {
//                       showDialog(
//                           context: context, builder: (_) => const StatsBox());
//                     }
//                   },
//                 );
//               }
//               return IconButton(
//                 onPressed: () async {
//                   showDialog(
//                     context: context,
//                     builder: (_) => const StatsBox(),
//                   );
//                 },
//                 icon: const Icon(Icons.bar_chart_outlined),
//               );
//             },
//           ),
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(builder: (context) => const Settings()),
//               );
//             },
//             icon: const Icon(Icons.settings),
//           ),
//         ],
//       ),
//       body: const Column(
//         children: [
//           Divider(
//             height: 2,
//             thickness: 2,
//           ),
//           Expanded(flex: 12, child: Grid()),
//           Expanded(
//             flex: 4,
//             child: Column(
//               children: [
//                 KeyboardRow(
//                   min: 1,
//                   max: 10,
//                 ),
//                 KeyboardRow(
//                   min: 11,
//                   max: 19,
//                 ),
//                 KeyboardRow(
//                   min: 20,
//                   max: 29,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
