import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// アプリ内レビューリクエストを管理するサービス
class ReviewService {
  static const String _hasRequestedReviewKey = 'has_requested_review';

  final InAppReview _inAppReview = InAppReview.instance;

  /// 初回プレイ時のみレビューリクエストを表示
  /// すでにリクエスト済みの場合は何もしない
  Future<void> requestReviewIfFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hasRequested = prefs.getBool(_hasRequestedReviewKey) ?? false;

    if (hasRequested) {
      return;
    }

    // レビューが利用可能か確認
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    }

    // リクエスト済みフラグを保存（成功/失敗に関わらず）
    await prefs.setBool(_hasRequestedReviewKey, true);
  }
}
