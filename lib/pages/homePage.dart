import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workoutapp/components/habitTile.dart';
import 'package:workoutapp/components/month_summary.dart';
import 'package:workoutapp/data/workouts_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WorkoutsDatabase db = WorkoutsDatabase();
  final _myBox = Hive.box("Workouts_Database");
  @override
  void initState() {
    if (_myBox.get("CURRENT_WORKOUT_LIST") == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }

    db.updateDatabase();

    super.initState();
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysWorkoutList[index][1] = value;
    });
    db.updateDatabase();
  }

  void addNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          content: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter New Habit',
              hintStyle:
                  TextStyle(color: Colors.grey), // Change the text color here
            ),
            onSubmitted: (newHabitName) {
              setState(() {
                db.todaysWorkoutList.add([newHabitName, false]);
              });
              db.updateDatabase();
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          content: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: db.todaysWorkoutList[index][0],
              hintStyle:
                  TextStyle(color: Colors.grey), // Change the text color here
            ),
            onSubmitted: (newHabitName) {
              setState(() {
                db.todaysWorkoutList[index][0] = newHabitName;
              });
              db.updateDatabase();
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysWorkoutList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        onPressed: () => addNewHabit(),
        child: Icon(Icons.add),
      ),
      body: ListView(
        children: [
          MonthlySummary(datasets: db.heatMapDataSet, startDate: _myBox.get("START_DATE")),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todaysWorkoutList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                habitName: db.todaysWorkoutList[index][0],
                habitCompleted: db.todaysWorkoutList[index][1],
                onChanged: (value) => checkBoxTapped(value, index),
                settingsTapped: (context) => openHabitSettings(index),
                deleteTapped: (context) => deleteHabit(index),
              );
            },
          ),
        ],
      ),
    );
  }
}
