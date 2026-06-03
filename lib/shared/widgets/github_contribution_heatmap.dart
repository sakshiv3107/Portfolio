import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../features/home/domain/models/github_heatmap.dart';

/// GitHub-style contribution graph: month labels + green level scale.
class GitHubContributionHeatmap extends StatelessWidget {
  final List<List<ContributionDay>> weeks;
  final int totalContributions;
  final String username;

  const GitHubContributionHeatmap({
    super.key,
    required this.weeks,
    required this.totalContributions,
    required this.username,
  });

  static const double _cellSize = 11;
  static const double _cellGap = 3;
  static const List<String> _monthLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// GitHub dark-theme contribution greens (empty → brightest).
  static const List<Color> contributionColors = [
    Color(0xFF161B22),
    Color(0xFF0E4429),
    Color(0xFF006D32),
    Color(0xFF26A641),
    Color(0xFF39D353),
  ];

  static Color colorForDay(ContributionDay day) {
    switch (day.level) {
      case 'NONE':
        return contributionColors[0];
      case 'FIRST_QUARTILE':
        return contributionColors[1];
      case 'SECOND_QUARTILE':
        return contributionColors[2];
      case 'THIRD_QUARTILE':
        return contributionColors[3];
      case 'FOURTH_QUARTILE':
        return contributionColors[4];
      default:
        if (day.count <= 0) return contributionColors[0];
        if (day.count <= 3) return contributionColors[1];
        if (day.count <= 6) return contributionColors[2];
        if (day.count <= 9) return contributionColors[3];
        return contributionColors[4];
    }
  }

  @override
  Widget build(BuildContext context) {
    final columnWidth = _cellSize + _cellGap;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMonthRow(columnWidth),
              const SizedBox(height: 6),
              _buildGrid(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildFooter(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const FaIcon(
          FontAwesomeIcons.github,
          size: 20,
          color: AppColors.textPrimary,
        ),
        const SizedBox(width: 10),
        Text(
          'GitHub Activity',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        _UsernameLink(username: username),
      ],
    );
  }

  Widget _buildMonthRow(double columnWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(weeks.length, (col) {
        final label = _monthLabelForColumn(col);
        return SizedBox(
          width: columnWidth,
          child: label != null
              ? Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : const SizedBox.shrink(),
        );
      }),
    );
  }

  Widget _buildGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(weeks.length, (col) {
        final days = weeks[col];
        return Padding(
          padding: EdgeInsets.only(right: col < weeks.length - 1 ? _cellGap : 0),
          child: Column(
            children: List.generate(days.length, (row) {
              final day = days[row];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: row < days.length - 1 ? _cellGap : 0,
                ),
                child: _ContributionCell(
                  size: _cellSize,
                  color: colorForDay(day),
                  date: day.date,
                  count: day.count,
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Text(
          '$totalContributions contributions',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          'Less',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
        const SizedBox(width: 6),
        for (var i = 0; i < contributionColors.length; i++) ...[
          if (i > 0) const SizedBox(width: 3),
          _LegendCell(color: contributionColors[i]),
        ],
        const SizedBox(width: 6),
        Text(
          'More',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  String? _monthLabelForColumn(int columnIndex) {
    final month = _primaryMonthForWeek(weeks[columnIndex]);
    if (month == null) return null;

    if (columnIndex == 0) return _monthLabels[month - 1];

    final prevMonth = _primaryMonthForWeek(weeks[columnIndex - 1]);
    if (prevMonth != month) return _monthLabels[month - 1];

    return null;
  }

  int? _primaryMonthForWeek(List<ContributionDay> week) {
    for (final day in week) {
      final date = _parseDate(day.date);
      if (date != null) return date.month;
    }
    return null;
  }

  DateTime? _parseDate(String raw) {
    if (raw.isEmpty) return null;
    try {
      return DateTime.parse(raw);
    } catch (_) {
      return null;
    }
  }
}

class _ContributionCell extends StatelessWidget {
  final double size;
  final Color color;
  final String date;
  final int count;

  const _ContributionCell({
    required this.size,
    required this.color,
    required this.date,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: date.isEmpty ? '' : '$count contributions on $date',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2.5),
        ),
      ),
    );
  }
}

class _LegendCell extends StatelessWidget {
  final Color color;

  const _LegendCell({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }
}

class _UsernameLink extends StatefulWidget {
  final String username;

  const _UsernameLink({required this.username});

  @override
  State<_UsernameLink> createState() => _UsernameLinkState();
}

class _UsernameLinkState extends State<_UsernameLink> {
  bool _hovered = false;

  Future<void> _openProfile() async {
    final uri = Uri.parse('https://github.com/${widget.username}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _openProfile,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '@${widget.username}',
              style: AppTypography.bodySmall.copyWith(
                color: _hovered
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.open_in_new_rounded,
              size: 14,
              color: _hovered
                  ? AppColors.textPrimary
                  : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
