import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CityzensIcons/cityzens_icons.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/citizen/Model/Diary/diary_response.dart';
import 'package:tcs_app/citizen/Provider/Diary/diary_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DiaryRecordComponent extends StatefulWidget {
  final double bottomPadding;

  const DiaryRecordComponent({
    super.key,
    this.bottomPadding = 24,
  });

  @override
  State<DiaryRecordComponent> createState() => _DiaryRecordComponentState();
}

class _DiaryRecordComponentState extends State<DiaryRecordComponent> {
  final Set<int> _expandedIndices = <int>{};
  bool _initializedExpansion = false;

  Future<void> _launchFile(String fileName) async {
    final Uri url = Uri.parse(
      '${AppConstants.baseUrl}/MobileAppAttachments/DailyDiary/$fileName',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Color _getSubjectColor(String? subject) {
    final s = (subject ?? '').trim().toLowerCase();
    if (s.isEmpty) return AppColors.blue;
    if (s.contains('eng')) return const Color(0xFF194F90);
    if (s.contains('math')) return const Color(0xFFE0A21A);
    if (s.contains('urdu') || s.contains('bio') || s.contains('isl')) {
      return const Color(0xFF0E8A5F);
    }
    if (s.contains('sci') || s.contains('phys')) return const Color(0xFFC42840);
    if (s.contains('chem') || s.contains('art')) return const Color(0xFFD9468C);
    if (s.contains('comp') || s.contains('ict')) return const Color(0xFF5B4BB7);
    if (s.contains('soc') ||
        s.contains('pak') ||
        s.contains('pst') ||
        s.contains('geo') ||
        s.contains('hist')) {
      return const Color(0xFFB5651D);
    }
    return AppColors.blue;
  }

  String _formatDateHeader(String rawDate) {
    final DateTime? parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    return DateFormat('EEE, d MMM yyyy').format(parsed);
  }

  String? _relativeDateTag(String rawDate) {
    final DateTime? parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return null;
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime target = DateTime(parsed.year, parsed.month, parsed.day);
    final int diff = target.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == -1) return 'Yesterday';
    return null;
  }

  List<_DiaryDateGroup> _groupRecords(List<DiaryRecords> records) {
    final Map<String, List<DiaryRecords>> grouped = {};
    for (final rec in records) {
      final String raw = rec.diaryDate ?? '';
      grouped.putIfAbsent(raw, () => <DiaryRecords>[]).add(rec);
    }

    final List<_DiaryDateGroup> groups = grouped.entries
        .map(
          (e) => _DiaryDateGroup(
            rawDate: e.key,
            parsedDate: DateTime.tryParse(e.key),
            records: e.value,
          ),
        )
        .toList();

    groups.sort((a, b) {
      if (a.parsedDate != null && b.parsedDate != null) {
        return b.parsedDate!.compareTo(a.parsedDate!);
      }
      return b.rawDate.compareTo(a.rawDate);
    });

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryProvider>(
      builder: (context, value, _) {
        final List<DiaryRecords> diaryRecords =
            value.diaryResponse?.diaryRecords ?? <DiaryRecords>[];

        if (diaryRecords.isEmpty) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
            child: Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        color: AppColors.blueTint,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const CityzensIcon(
                        type: CityzensIconType.homework,
                        size: 36,
                        primaryColor: AppColors.blue,
                        secondaryColor: AppColors.yellow,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'No recent homework uploaded',
                      textAlign: TextAlign.center,
                      style: AppThemes.sora(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Uploaded homework tasks and attachments will appear here.',
                      textAlign: TextAlign.center,
                      style: AppThemes.roboto(
                        fontSize: 13,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final List<_DiaryDateGroup> groups = _groupRecords(diaryRecords);

        if (!_initializedExpansion && groups.isNotEmpty) {
          _initializedExpansion = true;
          for (int i = 0; i < groups.first.records.length; i++) {
            _expandedIndices.add(i);
          }
        }

        int runningIndex = 0;
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(16, 14, 16, widget.bottomPadding),
          itemCount: groups.length,
          itemBuilder: (context, groupIndex) {
            final group = groups[groupIndex];
            final String? tag = _relativeDateTag(group.rawDate);
            final int startIndex = runningIndex;
            runningIndex += group.records.length;

            return Padding(
              padding: EdgeInsets.only(
                bottom: groupIndex == groups.length - 1 ? 0 : 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Group Section Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 2, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  _formatDateHeader(group.rawDate),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppThemes.sora(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                              if (tag != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: tag == 'Today'
                                        ? const Color(0xFFFFF8C4)
                                        : AppColors.blueTint,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    tag,
                                    style: AppThemes.sora(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: tag == 'Today'
                                          ? const Color(0xFF7A5D00)
                                          : AppColors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${group.records.length} ${group.records.length == 1 ? 'task' : 'tasks'}',
                          style: AppThemes.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Homework Cards under this Date
                  for (int idx = 0; idx < group.records.length; idx++) ...[
                    _buildDiaryCard(
                      record: group.records[idx],
                      itemIndex: startIndex + idx,
                    ),
                    if (idx < group.records.length - 1)
                      const SizedBox(height: 10),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDiaryCard({
    required DiaryRecords record,
    required int itemIndex,
  }) {
    final Color accentColor = _getSubjectColor(record.subject);
    final bool isExpanded = _expandedIndices.contains(itemIndex);
    final String fileName = (record.fileName ?? '').trim();
    final bool hasFile = fileName.isNotEmpty;
    final String ext =
        hasFile && fileName.contains('.') ? fileName.split('.').last.toUpperCase() : 'FILE';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(15, 52, 102, 0.06),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedIndices.remove(itemIndex);
                } else {
                  _expandedIndices.add(itemIndex);
                }
              });
            },
            borderRadius: isExpanded
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      record.subject ?? 'Subject',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppThemes.sora(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  if (hasFile) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blueTint,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.attach_file_rounded,
                            size: 12,
                            color: AppColors.blue,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            ext,
                            style: AppThemes.sora(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(width: 6),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: AppColors.muted,
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEF1F5)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (record.description ?? '').trim().isNotEmpty
                        ? record.description!
                        : 'No description provided.',
                    style: AppThemes.roboto(
                      fontSize: 13.5,
                      color: AppColors.ink,
                      height: 1.45,
                    ),
                  ),
                  if (hasFile) ...[
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _launchFile(fileName),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blueTint,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.blue.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text(
                                ext,
                                style: AppThemes.sora(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                fileName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppThemes.sora(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.download_rounded,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Open',
                                    style: AppThemes.sora(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DiaryDateGroup {
  final String rawDate;
  final DateTime? parsedDate;
  final List<DiaryRecords> records;

  const _DiaryDateGroup({
    required this.rawDate,
    required this.parsedDate,
    required this.records,
  });
}
