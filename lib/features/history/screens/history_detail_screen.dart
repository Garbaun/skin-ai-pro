import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/analysis_models.dart';
import '../logic/history_bloc.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final analysisResult = ModalRoute.of(context)!.settings.arguments as AnalysisResult;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analysisDetails),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _showDeleteConfirmation(context, analysisResult.id, l10n);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Analysis Date and Score
            _buildAnalysisHeader(context, analysisResult, l10n),
            const SizedBox(height: 24),
            
            // Overall Score
            _buildOverallScore(context, analysisResult, l10n),
            const SizedBox(height: 24),
            
            // Analysis Details
            _buildAnalysisDetails(context, analysisResult, l10n),
            const SizedBox(height: 24),
            
            // Recommendations
            _buildRecommendations(context, analysisResult, l10n),
            const SizedBox(height: 24),
            
            // Product Recommendations
            _buildProductRecommendations(context, analysisResult, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisHeader(BuildContext context, AnalysisResult result, AppLocalizations l10n) {
    final formattedDate = _formatDate(result.createdAt, l10n);
    final scoreColor = _getScoreColor(result.overallScore);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: scoreColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                result.overallScore.toString(),
                style: AppTextStyles.headlineSmall.copyWith(
                  color: scoreColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.skinAnalysis,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallScore(BuildContext context, AnalysisResult result, AppLocalizations l10n) {
    final score = result.overallScore;
    final scoreColor = _getScoreColor(score);
    final scoreText = _getScoreText(score, l10n);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scoreColor.withOpacity(0.8), scoreColor],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        children: [
          Text(
            l10n.overallScore,
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Column(
                children: [
                  Text(
                    score.toString(),
                    style: AppTextStyles.displayLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '/100',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            scoreText,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisDetails(BuildContext context, AnalysisResult result, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.analysisDetails,
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: 16),
        _buildDetailCard(
          context,
          icon: Icons.opacity_outlined,
          title: l10n.moistureLevel,
          value: '${result.moistureLevel}%',
          description: result.moistureLevel > 70 
              ? l10n.moistureGood 
              : result.moistureLevel > 40 
                  ? l10n.moistureNormal 
                  : l10n.moistureLow,
          color: AppColors.info,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          context,
          icon: Icons.spa_outlined,
          title: l10n.oilLevel,
          value: '${result.oilLevel}%',
          description: result.oilLevel > 60 
              ? l10n.oilySkin 
              : result.oilLevel > 30 
                  ? l10n.normalSkin 
                  : l10n.drySkin,
          color: AppColors.warning,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          context,
          icon: Icons.grain_outlined,
          title: l10n.poreSize,
          value: result.poreSize,
          description: _getPoreDescription(result.poreSize, l10n),
          color: AppColors.success,
        ),
        const SizedBox(height: 12),
        _buildDetailCard(
          context,
          icon: Icons.brightness_2_outlined,
          title: l10n.pigmentation,
          value: result.pigmentation,
          description: _getPigmentationDescription(result.pigmentation, l10n),
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      value,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(BuildContext context, AnalysisResult result, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recommendations,
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: 16),
        ...result.recommendations.map((recommendation) => 
          _buildRecommendationItem(context, recommendation, l10n)
        ).toList(),
      ],
    );
  }

  Widget _buildRecommendationItem(BuildContext context, String recommendation, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: AppColors.success,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              recommendation,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRecommendations(BuildContext context, AnalysisResult result, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recommendedProducts,
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: 16),
        if (result.recommendedProducts.isEmpty)
          Text(
            l10n.noProductRecommendations,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          )
        else
          ...result.recommendedProducts.map((product) => 
            _buildProductItem(context, product, l10n)
          ).toList(),
      ],
    );
  }

  Widget _buildProductItem(BuildContext context, Product product, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.warning,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₺${product.price.toStringAsFixed(2)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to product detail or purchase
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(l10n.viewProduct),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String analysisId, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.deleteAnalysis),
          content: Text(l10n.deleteAnalysisConfirm),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<HistoryBloc>().add(DeleteAnalysis(analysisId));
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  String _getScoreText(int score, AppLocalizations l10n) {
    if (score >= 80) return l10n.excellent;
    if (score >= 60) return l10n.good;
    if (score >= 40) return l10n.fair;
    return l10n.needsImprovement;
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return l10n.today;
    } else if (difference.inDays == 1) {
      return l10n.yesterday;
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${l10n.daysAgo}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _getPoreDescription(String poreSize, AppLocalizations l10n) {
    switch (poreSize.toLowerCase()) {
      case 'small':
        return l10n.smallPoresDesc;
      case 'medium':
        return l10n.mediumPoresDesc;
      case 'large':
        return l10n.largePoresDesc;
      default:
        return l10n.normalPoresDesc;
    }
  }

  String _getPigmentationDescription(String pigmentation, AppLocalizations l10n) {
    switch (pigmentation.toLowerCase()) {
      case 'minimal':
        return l10n.minimalPigmentationDesc;
      case 'moderate':
        return l10n.moderatePigmentationDesc;
      case 'significant':
        return l10n.significantPigmentationDesc;
      default:
        return l10n.normalPigmentationDesc;
    }
  }
}