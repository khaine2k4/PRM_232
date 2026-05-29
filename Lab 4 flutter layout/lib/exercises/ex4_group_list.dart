import 'package:flutter/material.dart';

class TeamMember {
  final String name;
  final String initials;
  final Color avatarColor;

  TeamMember({
    required this.name,
    required this.initials,
    required this.avatarColor,
  });
}

class TeamGroup {
  final String teamName;
  final List<TeamMember> members;

  TeamGroup({
    required this.teamName,
    required this.members,
  });
}

class Ex4GroupListScreen extends StatelessWidget {
  Ex4GroupListScreen({super.key});

  final List<TeamGroup> _groups = [
    TeamGroup(
      teamName: 'Team A',
      members: [
        TeamMember(
          name: 'Klay Lewis',
          initials: 'KL',
          avatarColor: const Color(0xFFF06292), // Pink
        ),
        TeamMember(
          name: 'Ehsan Woodard',
          initials: 'EW',
          avatarColor: const Color(0xFFBA68C8), // Purple
        ),
        TeamMember(
          name: 'River Bains',
          initials: 'RB',
          avatarColor: const Color(0xFF90A4AE), // Blue Grey
        ),
      ],
    ),
    TeamGroup(
      teamName: 'Team B',
      members: [
        TeamMember(
          name: 'Toyah Downs',
          initials: 'TD',
          avatarColor: const Color(0xFFE57373), // Coral / Red
        ),
        TeamMember(
          name: 'Tyla Kane',
          initials: 'TK',
          avatarColor: const Color(0xFF4DB6AC), // Teal
        ),
      ],
    ),
    TeamGroup(
      teamName: 'Team C',
      members: [
        TeamMember(
          name: 'Marcus Romero',
          initials: 'MR',
          avatarColor: const Color(0xFFFFB74D), // Orange
        ),
        TeamMember(
          name: 'Farrah Parkes',
          initials: 'FP',
          avatarColor: const Color(0xFF9575CD), // Lavender / Purple
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light background matching mockup
      appBar: AppBar(
        title: const Text('Group List View Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Settings action
          },
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          itemCount: _groups.length,
          itemBuilder: (context, groupIndex) {
            final group = _groups[groupIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group Header
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 4.0),
                  child: Text(
                    group.teamName,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                
                // Group Members List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: group.members.length,
                  itemBuilder: (context, memberIndex) {
                    final member = group.members[memberIndex];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        leading: CircleAvatar(
                          radius: 24.0,
                          backgroundColor: member.avatarColor,
                          child: Text(
                            member.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          member.name,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                          size: 28.0,
                        ),
                        onTap: () {
                          // Handle member tap
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
