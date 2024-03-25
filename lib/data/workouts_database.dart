import 'package:hive_flutter/hive_flutter.dart';
import 'package:workoutapp/datetime/date_time.dart';

final _myBox = Hive.box("Workouts_Database");

class WorkoutsDatabase {
  List todaysWorkoutList = [];
  Map<DateTime, int> heatMapDataSet = {};

  void createDefaultData() {
    todaysWorkoutList = [
      ["Push", false],
      ["Pull", false],
      ["Legs", false],
      ["Cardio", false],
      ["Core", false]
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  void loadData() {
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysWorkoutList = _myBox.get("CURRENT_WORKOUT_LIST");
      for (int i = 0; i < todaysWorkoutList.length; i++) {
        todaysWorkoutList[i][1] = false;
      }
    } else {
      todaysWorkoutList = _myBox.get(todaysDateFormatted());
    }
  }

  void updateDatabase() {
    _myBox.put(todaysDateFormatted(), todaysWorkoutList);

    _myBox.put("CURRENT_WORKOUT_LIST", todaysWorkoutList);

    calculatePercentages();

    loadHeatMap();
  }

  void calculatePercentages() {
    int completed = 0;
    for (int i = 0; i < todaysWorkoutList.length; i++) {
      if (todaysWorkoutList[i][1] == true) {
        completed++;
      }
    }

    String percent = todaysWorkoutList.isEmpty
        ? '0.0'
        : (completed / todaysWorkoutList.length).toStringAsFixed(1);

    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
