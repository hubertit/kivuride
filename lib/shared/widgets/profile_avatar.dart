import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String? subtitle;
  final double size;
  final bool showEditButton;
  final VoidCallback? onEditPressed;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.subtitle,
    this.size = 80,
    this.showEditButton = false,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryColor,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: size / 2,
                backgroundColor: AppTheme.surfaceColor,
                backgroundImage: imageUrl != null 
                    ? NetworkImage(imageUrl!) 
                    : null,
                child: imageUrl == null
                    ? Text(
                        _getInitials(name),
                        style: AppTheme.titleLarge.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
            ),
            if (showEditButton)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditPressed,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.backgroundColor,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: AppTheme.backgroundColor,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppTheme.spacing8),
          Text(
            subtitle!,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }
}
