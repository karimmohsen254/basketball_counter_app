import 'package:flutter/material.dart';
import 'button_widget.dart';

/// Model representing a historical state for undo functionality.
class ScoreState {
  final int teamA;
  final int teamB;

  ScoreState(this.teamA, this.teamB);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int teamApoints = 0;
  int teamBpoints = 0;

  // History stack for undo functionality
  final List<ScoreState> _history = [];

  /// Updates score and records previous state for undo support.
  void _updateScore(int newA, int newB) {
    setState(() {
      _history.add(ScoreState(teamApoints, teamBpoints));
      teamApoints = newA;
      teamBpoints = newB;
    });
  }

  /// Reverts to the previous score state.
  void _undo() {
    if (_history.isNotEmpty) {
      setState(() {
        final lastState = _history.removeLast();
        teamApoints = lastState.teamA;
        teamBpoints = lastState.teamB;
      });
    }
  }

  /// Resets scores to zero and saves state to history.
  void _reset() {
    if (teamApoints > 0 || teamBpoints > 0) {
      setState(() {
        _history.add(ScoreState(teamApoints, teamBpoints));
        teamApoints = 0;
        teamBpoints = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Modern dark mode slate background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text(
          "Basketball Scoreboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Teams Cards Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team A Card
                  Expanded(
                    child: _buildTeamCard(
                      teamName: "TEAM A",
                      score: teamApoints,
                      accentColor: const Color(0xFFFF9F43), // Vibrant Orange
                      onAdd: (points) => _updateScore(teamApoints + points, teamBpoints),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Team B Card
                  Expanded(
                    child: _buildTeamCard(
                      teamName: "TEAM B",
                      score: teamBpoints,
                      accentColor: const Color(0xFF00D2D3), // Vibrant Cyan/Teal
                      onAdd: (points) => _updateScore(teamApoints, teamBpoints + points),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Action Buttons Row (Reset & Undo)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Reset Primary Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444), // Modern Red
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: const Text(
                      'Reset',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Undo Outline Button
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _history.isNotEmpty ? Colors.white : Colors.white38,
                      side: BorderSide(
                        color: _history.isNotEmpty ? Colors.white38 : Colors.white12,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _history.isNotEmpty ? _undo : null,
                    icon: const Icon(Icons.undo_rounded, size: 20),
                    label: const Text(
                      'Undo',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to build a modern card for each team.
  Widget _buildTeamCard({
    required String teamName,
    required int score,
    required Color accentColor,
    required ValueChanged<int> onAdd,
  }) {
    return Card(
      color: const Color(0xFF1E293B), // Sleek dark surface card
      elevation: 8,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: accentColor.withValues(alpha: 0.25), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Team Name Header
            Text(
              teamName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: accentColor,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            // Score Display Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$score',
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Horizontal Pill Buttons (+1, +2, +3)
            Row(
              children: [
                PointButton(
                  label: '+1',
                  backgroundColor: accentColor.withValues(alpha: 0.7),
                  onPressed: () => onAdd(1),
                ),
                const SizedBox(width: 6),
                PointButton(
                  label: '+2',
                  backgroundColor: accentColor.withValues(alpha: 0.85),
                  onPressed: () => onAdd(2),
                ),
                const SizedBox(width: 6),
                PointButton(
                  label: '+3',
                  backgroundColor: accentColor,
                  onPressed: () => onAdd(3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
