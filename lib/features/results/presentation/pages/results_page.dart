import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/providers/app_providers.dart';
import '../models/report_models.dart';
import '../providers/results_providers.dart';
import 'report_view_page.dart';

class ResultsPage extends ConsumerWidget {
  const ResultsPage({super.key});

  static const routeName = 'results';
  static const routePath = '/results';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reports = ref.watch(resultsReportsProvider);
    final formatter = DateFormat.yMMMMd(l10n.locale.languageCode);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.resultsTitle)),
      body: reports.isEmpty
          ? Center(child: Text(l10n.resultsEmptyState))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final report = reports[index];
                final statusLabel = _statusLabel(l10n, report.status);
                final chipColor = _statusColor(context, report.status);
                final createdText = '${l10n.resultsCreatedAt} ${formatter.format(report.createdAt)}';
                final updatedText = report.updatedAt == null
                    ? null
                    : '${l10n.resultsUpdatedAt} ${formatter.format(report.updatedAt!)}';
                return Card(
                  elevation: 1,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      final analytics = ref.read(firebaseAnalyticsProvider);
                      analytics?.logEvent(
                        name: 'report_requested',
                        parameters: {
                          'report_id': report.id,
                          'status': report.status.apiValue,
                        },
                      );
                      context.pushNamed(
                        ReportViewPage.routeName,
                        pathParameters: {'reportId': report.id},
                        extra: report,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  report.title,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Chip(
                                label: Text(statusLabel),
                                backgroundColor: chipColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            report.subtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            createdText,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (updatedText != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              updatedText,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: reports.length,
            ),
    );
  }

  String _statusLabel(AppLocalizations l10n, ReportStatus status) {
    switch (status) {
      case ReportStatus.inReview:
        return l10n.resultsStatusInReview;
      case ReportStatus.ready:
        return l10n.resultsStatusReady;
    }
  }

  Color _statusColor(BuildContext context, ReportStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case ReportStatus.inReview:
        return colorScheme.secondaryContainer;
      case ReportStatus.ready:
        return colorScheme.primaryContainer;
    }
  }
}
