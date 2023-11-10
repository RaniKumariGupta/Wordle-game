import 'package:flutter/material.dart';
import 'package:wordlegame/utils/calculate_stats.dart';
import 'package:wordlegame/components/stats_tile.dart';
import 'package:wordlegame/constants/answer_stages.dart';
import 'package:wordlegame/data/keys_map.dart';
import 'package:wordlegame/main.dart';

class StatsBox extends StatelessWidget {
  const StatsBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
              alignment: Alignment.centerRight,
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: const Icon(Icons.clear)),
          const Expanded(
              child: Text(
            'STATISTICS',
            textAlign: TextAlign.center,
          )),
          Expanded(
            child: FutureBuilder(
              future: getStats(),
              builder: (context, snapshot) {
                List<String> results = ['0', '0', '0', '0', '0'];
                if (snapshot.hasData) {
                  results = snapshot.data as List<String>;
                }
                return Row(
                  children: [
                    StatsTile(heading: 'Played', value: int.parse(results[0])),
                    StatsTile(heading: 'Win %', value: int.parse(results[2])),
                    StatsTile(
                        heading: 'Current\nStreak',
                        value: int.parse(results[3])),
                    StatsTile(
                        heading: 'Max\nStreak', value: int.parse(results[4])),
                  ],
                );
              },
            ),
          ),
          Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: () {
                    keysMap.updateAll(
                        (key, value) => value = AnswerStage.notAnswered);

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                        (route) => false);
                  },
                  child: const Text(
                    'Replay',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  )))
        ],
      ),
    );
  }
}
