/// 마이페이지 「의학 정보 출처」 정적 카탈로그.
class MedicalSourceItem {
  const MedicalSourceItem({
    required this.title,
    required this.subtitle,
    this.url,
    this.pageTitle,
  });

  final String title;
  final String subtitle;

  /// 원문 URL. 없으면 행만 표시하고 이동하지 않는다.
  final String? url;

  /// 웹뷰 앱바 제목. 없으면 [title]을 쓴다.
  final String? pageTitle;

  String get webTitle => pageTitle ?? title;
}

class MedicalSourceSection {
  const MedicalSourceSection({
    required this.label,
    required this.items,
  });

  final String label;
  final List<MedicalSourceItem> items;
}

/// 화면 카피·출처 URL의 단일 목록.
abstract final class MedicalSourcesCatalog {
  static const String intro = '이 앱의 신호등 판정과 안내는 아래 자료를 근거로 합니다. '
      '개인 기록만으로 판단한 항목은 따로 표시했어요.';

  static const String citation =
      'Katz PO, Dunbar KB, Schnoll-Sussman FH, et al. ACG Clinical '
      'Guideline for the Diagnosis and Management of Gastroesophageal '
      'Reflux Disease. Am J Gastroenterol. 2022;117(1):27–56.';

  static const String lastReviewed = '최종 검토 2026-08-13';

  static const String acg2022PageTitle = 'ACG 2022';
  static const String allergenPageTitle = '식품안전나라 「알레르기 유발 식품 표시」';
  static const String gerdPageTitle = '질병관리청 국가건강정보포털 「위식도역류질환」';
  static const String foodCompositionPageTitle = '식약처 식품영양성분';

  /// ACG 2022 원문은 페이월(HTTP 402). 앱 링크는 PubMed 초록.
  static const String acg2022Url = 'https://pubmed.ncbi.nlm.nih.gov/34807007/';

  static const String allergenLabelingUrl =
      'https://www.foodsafetykorea.go.kr/portal/board/boardDetail.do?'
      'menu_no=3120&menu_grp=MENU_NEW01&bbs_no=bbs001&ntctxt_no=1091412';

  static const String gerdPortalUrl =
      'https://health.kdca.go.kr/healthinfo/biz/health/gnrlzHealthInfo/'
      'gnrlzHealthInfo/gnrlzHealthInfoView.do?cntnts_sn=2057';

  static const String foodCompositionUrl =
      'https://various.foodsafetykorea.go.kr/nutrient/';

  static const List<MedicalSourceSection> sections = [
    MedicalSourceSection(
      label: '트리거 음식',
      items: [
        MedicalSourceItem(
          title: '탄산음료',
          subtitle: 'ACG 2022 · 근거 보통',
          url: acg2022Url,
          pageTitle: acg2022PageTitle,
        ),
        MedicalSourceItem(
          title: '커피·카페인',
          subtitle: 'ACG 2022 · 근거 약함',
          url: acg2022Url,
          pageTitle: acg2022PageTitle,
        ),
        MedicalSourceItem(
          title: '감귤류',
          subtitle: 'ACG 2022 · 증상을 유발하는 경우에만',
          url: acg2022Url,
          pageTitle: acg2022PageTitle,
        ),
        MedicalSourceItem(
          title: '양파·마늘 · 정제 밀가루',
          subtitle: '내 기록 기반 · 연구 근거 없음',
        ),
      ],
    ),
    MedicalSourceSection(
      label: '알레르기',
      items: [
        MedicalSourceItem(
          title: '알레르기 유발물질 표시 기준',
          subtitle: '식품의약품안전처 「식품등의 표시기준」',
          url: allergenLabelingUrl,
          pageTitle: allergenPageTitle,
        ),
      ],
    ),
    MedicalSourceSection(
      label: '질환 정보',
      items: [
        MedicalSourceItem(
          title: '위식도역류질환이란',
          subtitle: '질병관리청 국가건강정보포털',
          url: gerdPortalUrl,
          pageTitle: gerdPageTitle,
        ),
      ],
    ),
    MedicalSourceSection(
      label: '음식 데이터',
      items: [
        MedicalSourceItem(
          title: '음식 성분·분류 데이터',
          subtitle: '식품의약품안전처',
          url: foodCompositionUrl,
          pageTitle: foodCompositionPageTitle,
        ),
      ],
    ),
  ];
}
