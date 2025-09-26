import 'package:riverpod/riverpod.dart';

import '../models/report_models.dart';

final resultsReportsProvider = Provider<List<Report>>((ref) {
  final now = DateTime.now();
  return [
    Report(
      id: 'report-2024-q1',
      title: 'Отчет по развитию команды',
      subtitle: 'Итоги I квартала 2024',
      status: ReportStatus.ready,
      summary: {
        'engagement': {
          'score': 78,
          'trend': '+5% за квартал',
          'insight': 'Команда активно вовлекается в инициативы наставников.'
        },
        'competencies': {
          'leadership': 'средний уровень',
          'communication': 'высокий уровень',
          'innovation': 'нужны дополнительные сессии'
        },
      },
      recommendations: const [
        ReportRecommendation(
          id: 'rec-1',
          title: 'Провести стратегическую сессию',
          description: 'Собрать участников в апреле для выработки плана на следующий квартал.',
        ),
        ReportRecommendation(
          id: 'rec-2',
          title: 'Усилить обмен опытом',
          description: 'Организовать внутренние митапы раз в две недели.',
        ),
      ],
      createdAt: now.subtract(const Duration(days: 15)),
      updatedAt: now.subtract(const Duration(days: 2)),
    ),
    Report(
      id: 'report-2024-q2',
      title: 'Промежуточный срез по наставникам',
      subtitle: 'Подготовка к публикации',
      status: ReportStatus.inReview,
      summary: {
        'engagement': {
          'score': 71,
          'trend': '+2% за месяц',
        },
        'risks': {
          'burnout': 'средний риск',
          'retention': 'стабильно',
        },
      },
      recommendations: const [
        ReportRecommendation(
          id: 'rec-3',
          title: 'Запланировать индивидуальные сессии',
          description: 'Наставникам стоит провести 1:1 с ключевыми участниками.',
        ),
      ],
      createdAt: now.subtract(const Duration(days: 7)),
    ),
  ];
});
