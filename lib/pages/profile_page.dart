import 'package:flutter/material.dart';
import '../common/funny_colors.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_stats.dart';
import '../widgets/profile/profile_bio.dart';
import '../widgets/profile/profile_actions_grid.dart';
import '../widgets/profile/profile_tabs.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FunnyColors.white,
      body: SafeArea(
        child: Column(
          children: const [
            ProfileHeader(),
            ProfileStats(),
            ProfileBio(),
            ProfileActionsGrid(),
            Expanded(child: ProfileTabs()),
          ],
        ),
      ),
    );
  }
}
