import SwiftUI
import WidgetKit

private enum HomeWidgetStorage {
  static let snapshotKey = "home_widget_snapshot"
  static let syncedAtKey = "home_widget_synced_at"

  static func load() -> HomeWidgetSnapshot {
    guard let appGroupID = Bundle.main.object(forInfoDictionaryKey: "HomeWidgetAppGroupID") as? String,
          !appGroupID.isEmpty,
          !appGroupID.contains("$("),
          let defaults = UserDefaults(suiteName: appGroupID),
          let syncedAt = defaults.object(forKey: syncedAtKey) as? Date,
          isTodayInKST(syncedAt),
          let data = defaults.data(forKey: snapshotKey),
          let snapshot = try? JSONDecoder().decode(HomeWidgetSnapshot.self, from: data) else {
      return .recordMeal
    }
    return snapshot
  }

  private static func isTodayInKST(_ date: Date) -> Bool {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
    return calendar.isDate(date, inSameDayAs: Date())
  }
}

private enum HomeWidgetKind: String, Codable {
  case loggedOut
  case recordMeal
  case promptSymptom
  case allRecordedComfortable
  case allRecordedUncomfortable
}

private enum HomeWidgetTurtle: String, Codable {
  case none
  case happy
  case curious
  case frown

  var assetName: String? {
    switch self {
    case .none: nil
    case .happy: "TurtleHappy"
    case .curious: "TurtleCurious"
    case .frown: "TurtleFrown"
    }
  }
}

private struct HomeWidgetSnapshot: Codable {
  let kind: HomeWidgetKind
  let recommendCount: Int
  let cautionCount: Int
  let riskCount: Int
  let headline: String
  let subtitle: String
  let ctaLabel: String
  let turtle: HomeWidgetTurtle
  let uri: String

  enum CodingKeys: String, CodingKey {
    case kind
    case recommendCount
    case cautionCount
    case riskCount
    case headline
    case subtitle
    case ctaLabel
    case turtle
    case uri
  }

  init(
    kind: HomeWidgetKind,
    recommendCount: Int,
    cautionCount: Int,
    riskCount: Int,
    headline: String,
    subtitle: String,
    ctaLabel: String,
    turtle: HomeWidgetTurtle,
    uri: String
  ) {
    self.kind = kind
    self.recommendCount = recommendCount
    self.cautionCount = cautionCount
    self.riskCount = riskCount
    self.headline = headline
    self.subtitle = subtitle
    self.ctaLabel = ctaLabel
    self.turtle = turtle
    self.uri = uri
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    kind = HomeWidgetKind(rawValue: values.decodeString(forKey: .kind)) ?? .recordMeal
    recommendCount = values.decodeInt(forKey: .recommendCount)
    cautionCount = values.decodeInt(forKey: .cautionCount)
    riskCount = values.decodeInt(forKey: .riskCount)
    headline = values.decodeString(forKey: .headline)
    subtitle = values.decodeString(forKey: .subtitle)
    ctaLabel = values.decodeString(forKey: .ctaLabel)
    turtle = HomeWidgetTurtle(rawValue: values.decodeString(forKey: .turtle)) ?? .none
    uri = values.decodeString(forKey: .uri)
  }

  static let recordMeal = HomeWidgetSnapshot(
    kind: .recordMeal,
    recommendCount: 0,
    cautionCount: 0,
    riskCount: 0,
    headline: "오늘 음식을\n기록해보세요",
    subtitle: "",
    ctaLabel: "음식 기록하기 +",
    turtle: .none,
    uri: "canieatit://widget/meal-record"
  )

  var destinationURL: URL {
    URL(string: uri) ?? URL(string: "canieatit://widget/home")!
  }

  var smallDestinationURL: URL {
    URL(string: "canieatit://widget/meal-record")!
  }

  var displayHeadline: String {
    headline.isEmpty ? "오늘 음식을\n기록해보세요" : headline
  }

  var displayCTA: String {
    ctaLabel.replacingOccurrences(of: " +", with: "")
  }

  var showsHistoryArrow: Bool {
    kind == .allRecordedComfortable || kind == .allRecordedUncomfortable
  }
}

private extension KeyedDecodingContainer {
  func decodeString(forKey key: Key) -> String {
    if let value = try? decode(String.self, forKey: key) { return value }
    if let value = try? decode(Int.self, forKey: key) { return String(value) }
    return ""
  }

  func decodeInt(forKey key: Key) -> Int {
    if let value = try? decode(Int.self, forKey: key) { return value }
    return Int(decodeString(forKey: key)) ?? 0
  }
}

private struct TodayMealEntry: TimelineEntry {
  let date: Date
  let snapshot: HomeWidgetSnapshot
}

private struct TodayMealProvider: TimelineProvider {
  func placeholder(in context: Context) -> TodayMealEntry {
    TodayMealEntry(date: Date(), snapshot: .recordMeal)
  }

  func getSnapshot(in context: Context, completion: @escaping (TodayMealEntry) -> Void) {
    completion(TodayMealEntry(date: Date(), snapshot: HomeWidgetStorage.load()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<TodayMealEntry>) -> Void) {
    let entry = TodayMealEntry(date: Date(), snapshot: HomeWidgetStorage.load())
    completion(Timeline(entries: [entry], policy: .after(nextKstMidnight())))
  }

  private func nextKstMidnight() -> Date {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
    let startOfToday = calendar.startOfDay(for: Date())
    return calendar.date(byAdding: .day, value: 1, to: startOfToday) ?? Date().addingTimeInterval(24 * 60 * 60)
  }
}

struct TodayMealWidget: Widget {
  static let kind = "TodayMealWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: Self.kind, provider: TodayMealProvider()) { entry in
      TodayMealWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("오늘 먹은 음식")
    .description("오늘 기록한 음식과 증상 기록 상태를 확인해요.")
    .supportedFamilies([.systemSmall, .systemMedium])
    .contentMarginsDisabled()
  }
}

private struct TodayMealWidgetEntryView: View {
  @Environment(\.widgetFamily) private var family
  let entry: TodayMealEntry

  var body: some View {
    Group {
      switch family {
      case .systemMedium:
        MediumWidget(snapshot: entry.snapshot)
      default:
        SmallWidget(snapshot: entry.snapshot)
      }
    }
    .widgetSurface()
    .widgetURL(family == .systemSmall ? entry.snapshot.smallDestinationURL : entry.snapshot.destinationURL)
  }
}

private struct SmallWidget: View {
  let snapshot: HomeWidgetSnapshot

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("오늘 먹은 음식")
        .font(.system(size: 14, weight: .bold))
        .foregroundStyle(WidgetPalette.primary)

      Spacer(minLength: 0)

      HStack(spacing: 7) {
        CountTile(title: "권장", value: snapshot.recommendCount, style: .recommend)
        CountTile(title: "주의", value: snapshot.cautionCount, style: .caution)
        CountTile(title: "위험", value: snapshot.riskCount, style: .risk)
      }

      Spacer(minLength: 0)
      CTA(label: "음식 기록하기", arrow: false)
    }
    .padding(.horizontal, 16)
    .padding(.top, 23)
    .padding(.bottom, 23)
  }
}

private struct MediumWidget: View {
  let snapshot: HomeWidgetSnapshot

  var body: some View {
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 10) {
        Text("오늘 먹은 음식")
          .font(.system(size: 13, weight: .bold))
          .foregroundStyle(WidgetPalette.secondary)
          .lineLimit(1)
          .padding(.leading, 4)
        VerticalCount(title: "권장", value: snapshot.recommendCount, style: .recommend)
        VerticalCount(title: "주의", value: snapshot.cautionCount, style: .caution)
        VerticalCount(title: "위험", value: snapshot.riskCount, style: .risk)
      }
      .frame(width: 88)
      .offset(y: 2)

      Rectangle()
        .fill(WidgetPalette.divider)
        .frame(width: 1)
        .padding(.vertical, 5)

      ZStack(alignment: .bottomTrailing) {
        VStack(alignment: .leading, spacing: 3) {
          Text(snapshot.displayHeadline)
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(WidgetPalette.primary)
            .lineLimit(snapshot.kind == .promptSymptom ? 1 : 2)
            .minimumScaleFactor(0.75)

          if !snapshot.subtitle.isEmpty {
            Text(snapshot.subtitle)
              .font(.system(size: 10, weight: .regular))
              .foregroundStyle(WidgetPalette.secondary)
              .lineLimit(1)
          }

          Spacer(minLength: 0)

          Link(destination: snapshot.destinationURL) {
            MediumCTA(label: snapshot.displayCTA, arrow: snapshot.showsHistoryArrow)
          }
          .buttonStyle(.plain)
          .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.top, 18)
        .padding(.bottom, 18)
        // The design places the text and CTA slightly farther from the
        // divider while the character remains anchored to the corner.
        .padding(.leading, 3)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

        if let assetName = snapshot.turtle.assetName {
          Image(assetName)
            .resizable()
            .scaledToFit()
            .frame(width: 104, height: 128)
            // The medium widget's content padding would otherwise leave a
            // visible white gap around the character. Extend it to the
            // widget's clipped trailing/bottom edges instead.
            .offset(x: 20, y: 20)
            .accessibilityHidden(true)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    .padding(.horizontal, 19)
    .padding(.vertical, 14)
  }
}

private struct CountTile: View {
  let title: String
  let value: Int
  let style: CountStyle

  var body: some View {
    VStack(spacing: 3) {
      Text("\(value)")
        .font(.system(size: 22, weight: .bold))
        .foregroundStyle(style.foreground)
      Text(title)
        .font(.system(size: 11, weight: .medium))
        .foregroundStyle(WidgetPalette.secondary)
    }
    .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
    .background(style.background, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
  }
}

private struct VerticalCount: View {
  let title: String
  let value: Int
  let style: CountStyle

  var body: some View {
    HStack(alignment: .center, spacing: 8) {
      Text(title)
        .font(.system(size: 11, weight: .medium))
        .foregroundStyle(WidgetPalette.secondary)
        .frame(width: 24, alignment: .center)
      Text("\(value)")
        .font(.system(size: 18, weight: .bold))
        .foregroundStyle(style.foreground)
        .frame(width: 20, alignment: .center)
    }
    .frame(width: 82, height: 27)
    .background(style.background, in: RoundedRectangle(cornerRadius: 13, style: .continuous))
  }
}

private struct MediumCTA: View {
  let label: String
  let arrow: Bool

  var body: some View {
    HStack(spacing: 4) {
      Text(label)
        .font(.system(size: 11, weight: .bold))
        .lineLimit(1)
        .minimumScaleFactor(0.8)
      Image(systemName: arrow ? "chevron.right" : "plus")
        .font(.system(size: 8, weight: .heavy))
        .foregroundStyle(WidgetPalette.cta)
        .frame(width: 16, height: 16)
        .background(Color.white, in: Circle())
    }
    .foregroundStyle(Color.white)
    .padding(.leading, 12)
    .padding(.trailing, 8)
    .frame(height: 28)
    .background(WidgetPalette.cta, in: Capsule())
  }
}

private struct CTA: View {
  let label: String
  let arrow: Bool

  var body: some View {
    HStack(spacing: 6) {
      Text(label)
        .font(.system(size: 11, weight: .bold))
        .lineLimit(1)
      Image(systemName: arrow ? "chevron.right" : "plus")
        .font(.system(size: 8, weight: .heavy))
        .foregroundStyle(WidgetPalette.cta)
        .frame(width: 16, height: 16)
        .background(Color.white, in: Circle())
    }
    .foregroundStyle(Color.white)
    .padding(.horizontal, 10)
    .frame(maxWidth: .infinity)
    .frame(height: 26)
    .background(WidgetPalette.cta, in: Capsule())
  }
}

private enum CountStyle {
  case recommend
  case caution
  case risk

  var background: Color {
    switch self {
    case .recommend: WidgetPalette.recommendBackground
    case .caution: WidgetPalette.cautionBackground
    case .risk: WidgetPalette.riskBackground
    }
  }

  var foreground: Color {
    switch self {
    case .recommend: WidgetPalette.recommend
    case .caution: WidgetPalette.caution
    case .risk: WidgetPalette.risk
    }
  }
}

private enum WidgetPalette {
  static let primary = Color(red: 0.13, green: 0.13, blue: 0.14)
  static let secondary = Color(red: 0.48, green: 0.50, blue: 0.55)
  static let divider = Color(red: 0.89, green: 0.89, blue: 0.90)
  static let cta = Color(red: 0.13, green: 0.13, blue: 0.14)
  static let recommend = Color(red: 0.00, green: 0.76, blue: 0.48)
  static let caution = Color(red: 1.00, green: 0.55, blue: 0.18)
  static let risk = Color(red: 1.00, green: 0.25, blue: 0.31)
  static let recommendBackground = Color(red: 0.92, green: 0.99, blue: 0.95)
  static let cautionBackground = Color(red: 1.00, green: 0.95, blue: 0.89)
  static let riskBackground = Color(red: 1.00, green: 0.92, blue: 0.93)
}

private extension View {
  @ViewBuilder
  func widgetSurface() -> some View {
    if #available(iOS 17.0, *) {
      containerBackground(for: .widget) { Color.white }
    } else {
      background(Color.white)
    }
  }
}

struct TodayMealWidget_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TodayMealWidgetEntryView(
        entry: TodayMealEntry(
          date: Date(),
          snapshot: HomeWidgetSnapshot(
            kind: .promptSymptom,
            recommendCount: 2,
            cautionCount: 1,
            riskCount: 0,
            headline: "속이 불편한지 궁금해요..",
            subtitle: "비빔밥 먹은지 4시간",
            ctaLabel: "증상 기록하기 +",
            turtle: .curious,
            uri: "canieatit://widget/symptom-record?mealRecordId=meal-1"
          )
        )
      )
      .previewContext(WidgetPreviewContext(family: .systemMedium))

      TodayMealWidgetEntryView(entry: TodayMealEntry(date: Date(), snapshot: .recordMeal))
        .previewContext(WidgetPreviewContext(family: .systemMedium))

      TodayMealWidgetEntryView(entry: TodayMealEntry(date: Date(), snapshot: .recordMeal))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
  }
}

@main
struct TodayMealWidgetBundle: WidgetBundle {
  var body: some Widget {
    TodayMealWidget()
  }
}
