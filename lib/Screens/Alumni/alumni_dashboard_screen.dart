import 'package:flutter/material.dart';
import 'package:tcs_app/Model/Alumni/alumni_user_model.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Services/Alumni/alumni_login_service.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class AlumniDashboardScreen extends StatefulWidget {
  const AlumniDashboardScreen({super.key});

  @override
  State<AlumniDashboardScreen> createState() => _AlumniDashboardScreenState();
}

class _AlumniDashboardScreenState extends State<AlumniDashboardScreen> {
  AlumniUserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await AlumniLoginService.getStoredAlumniUser();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout Alumni'),
        content: const Text('Are you sure you want to logout from TCS Alumni?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AlumniLoginService.logoutAlumni();
      AppNavigation.pushReplacementTo(AppNavRoutes.authWrapperRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'TCS ALUMNI PORTAL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryTitleColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryTitleColor, AppColors.primaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryTitleColor.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.white,
                          backgroundImage: (_user?.image != null && _user!.image!.isNotEmpty)
                              ? NetworkImage(_user!.image!)
                              : null,
                          child: (_user?.image == null || _user!.image!.isEmpty)
                              ? const Icon(
                                  Icons.school,
                                  size: 34,
                                  color: AppColors.primaryTitleColor,
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _user?.fullName ?? 'Welcome Alumni',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _user?.email ?? '',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _user?.branchName != null && _user!.branchName!.isNotEmpty
                                      ? _user!.branchName!
                                      : 'The City School Alumni',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Section Title
                  const Text(
                    'Alumni Features',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Grid of features
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.25,
                    children: [
                      _buildFeatureTile(
                        icon: Icons.people_alt_rounded,
                        title: 'Alumni Directory',
                        subtitle: 'Connect with peers',
                        color: const Color(0xFF4F5FEB),
                      ),
                      _buildFeatureTile(
                        icon: Icons.event_available_rounded,
                        title: 'Events & Reunions',
                        subtitle: 'Upcoming gatherings',
                        color: const Color(0xFF07CDA5),
                      ),
                      _buildFeatureTile(
                        icon: Icons.work_rounded,
                        title: 'Jobs & Mentorship',
                        subtitle: 'Career opportunities',
                        color: const Color(0xFFFBA95D),
                      ),
                      _buildFeatureTile(
                        icon: Icons.newspaper_rounded,
                        title: 'News & Stories',
                        subtitle: 'Campus highlights',
                        color: const Color(0xFFE04D83),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Info Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.paleYellow,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.secondaryColor.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.primaryTitleColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Logged in as Verified TCS Alumni: ${_user?.fullName ?? ""}',
                            style: const TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.errorRed,
                        side: const BorderSide(color: AppColors.errorRed),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Switch Account / Logout',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _handleLogout,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

