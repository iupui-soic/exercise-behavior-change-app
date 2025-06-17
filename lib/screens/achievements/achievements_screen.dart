import 'package:flutter/material.dart';
import '../../models/achievement_model.dart';
import '../../services/achievement_service.dart';

class AchievementsScreen extends StatefulWidget {
  AchievementsScreen({Key? key}) : super(key: key);

  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final AchievementService _achievementService = AchievementService();
  late Future<List<Achievement>> _achievementsFuture;

  @override
  void initState() {
    super.initState();
    _achievementsFuture = _achievementService.getAchievements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: FutureBuilder<List<Achievement>>(
        future: _achievementsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No achievements yet.'));
          }

          final achievements = snapshot.data!;
          return ListView.builder(
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return ListTile(
                leading: Icon(
                  achievement.icon,
                  size: 40,
                  color: achievement.isUnlocked ? Colors.amber : Colors.grey,
                ),
                title: Text(achievement.title),
                subtitle: Text(achievement.description),
                trailing: achievement.isUnlocked
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : Text(
                        '${achievement.points} pts',
                        style: const TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
              );
            },
          );
        },
      ),
    );
  }
} 