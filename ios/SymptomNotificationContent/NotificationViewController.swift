import UIKit
import UserNotifications
import UserNotificationsUI

final class NotificationViewController: UIViewController, UNNotificationContentExtension {
  private enum Metric {
    static let horizontalInset: CGFloat = 12
    static let verticalInset: CGFloat = 16
    static let stackSpacing: CGFloat = 10
    static let chipSpacing: CGFloat = 6
  }

  private enum Palette {
    static let card = UIColor(red: 47 / 255, green: 47 / 255, blue: 57 / 255, alpha: 1)
    static let purple = UIColor(red: 105 / 255, green: 85 / 255, blue: 1, alpha: 1)
    static let mutedText = UIColor(red: 174 / 255, green: 174 / 255, blue: 190 / 255, alpha: 1)
    static let track = UIColor(red: 75 / 255, green: 75 / 255, blue: 90 / 255, alpha: 1)
    static let chipBackground = UIColor(red: 61 / 255, green: 61 / 255, blue: 74 / 255, alpha: 1)
    static let chipBorder = UIColor(red: 102 / 255, green: 102 / 255, blue: 119 / 255, alpha: 1)
  }

  private var payload: SymptomPushPayload?
  private var ownerSubjectId: String?
  private var selectedState = "normal"
  private var selectedTypes = Set<String>()
  private var canSave = false

  private let notificationHeader = UIStackView()
  private let headerIconView = UIImageView()
  private let headerAppNameLabel = UILabel()
  private let headerReceivedAtLabel = UILabel()
  private let titleLabel = UILabel()
  private let mealContextLabel = UILabel()
  private let separator = UIView()
  private let strengthTitleLabel = UILabel()
  private let stateLabel = UILabel()
  private let slider = UISlider()
  private let sliderTicks = UIStackView()
  private let typesStack = UIStackView()
  private let saveButton = UIButton(type: .system)
  private let statusLabel = UILabel()
  private var typeButtons = [UIButton]()

  private let states = ["comfortable", "good", "normal", "uncomfortable", "severe"]
  private let stateTitles = ["편안함", "좋음", "보통", "불편함", "심함"]
  private let typeCodes = ["throat_foreign_body", "acid_reflux", "cough", "chest_tightness"]
  private let typeTitles = ["목 이물감", "역류", "기침", "가슴 답답함"]

  override func viewDidLoad() {
    super.viewDidLoad()
    preferredContentSize = CGSize(width: 0, height: 484)
    view.backgroundColor = Palette.card
    buildUI()
  }

  func didReceive(_ notification: UNNotification) {
    payload = SymptomPushPayload(
      userInfo: notification.request.content.userInfo,
      category: notification.request.content.categoryIdentifier
    )
    logPayload(notification, isValid: payload != nil)
    configureHeader(notification)

    guard payload != nil, let config = try? NativeNotificationConfig.load() else {
      disableSave("이 알림은 기록할 수 없어요.")
      return
    }

    let keychain = SharedAccessTokenStore(config: config)
    switch keychain.readResult() {
    case .session(let session):
      ownerSubjectId = session.subjectId
    case .unavailableWhileLocked, .notFound, .error:
      ownerSubjectId = nil
    }
    canSave = true
    saveButton.isEnabled = true
  }

  private func buildUI() {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = Metric.stackSpacing
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.horizontalInset),
      stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.horizontalInset),
      stack.topAnchor.constraint(equalTo: view.topAnchor, constant: Metric.verticalInset),
      stack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -Metric.verticalInset)
    ])

    notificationHeader.axis = .horizontal
    notificationHeader.alignment = .center
    notificationHeader.spacing = 8

    headerIconView.backgroundColor = Palette.purple
    headerIconView.clipsToBounds = true
    headerIconView.contentMode = .scaleAspectFill
    headerIconView.layer.cornerRadius = 6
    headerIconView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      headerIconView.widthAnchor.constraint(equalToConstant: 24),
      headerIconView.heightAnchor.constraint(equalToConstant: 24)
    ])
    notificationHeader.addArrangedSubview(headerIconView)

    headerAppNameLabel.font = .systemFont(ofSize: 14, weight: .semibold)
    headerAppNameLabel.textColor = .white
    headerAppNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    notificationHeader.addArrangedSubview(headerAppNameLabel)

    let headerSpacer = UIView()
    headerSpacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
    notificationHeader.addArrangedSubview(headerSpacer)

    headerReceivedAtLabel.font = .systemFont(ofSize: 12, weight: .regular)
    headerReceivedAtLabel.textColor = Palette.mutedText
    headerReceivedAtLabel.setContentHuggingPriority(.required, for: .horizontal)
    headerReceivedAtLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    notificationHeader.addArrangedSubview(headerReceivedAtLabel)

    stack.addArrangedSubview(notificationHeader)
    stack.setCustomSpacing(12, after: notificationHeader)

    titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
    titleLabel.textColor = .white
    titleLabel.numberOfLines = 2
    stack.addArrangedSubview(titleLabel)

    mealContextLabel.font = .systemFont(ofSize: 12, weight: .regular)
    mealContextLabel.textColor = Palette.mutedText
    mealContextLabel.numberOfLines = 2
    mealContextLabel.isHidden = true
    stack.addArrangedSubview(mealContextLabel)

    separator.backgroundColor = Palette.track
    separator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([separator.heightAnchor.constraint(equalToConstant: 1)])
    stack.setCustomSpacing(14, after: separator)
    stack.addArrangedSubview(separator)

    strengthTitleLabel.text = "증상 강도"
    strengthTitleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
    strengthTitleLabel.textColor = Palette.mutedText
    stack.addArrangedSubview(strengthTitleLabel)

    slider.minimumValue = 0
    slider.maximumValue = Float(states.count - 1)
    slider.value = 2
    slider.minimumTrackTintColor = Palette.purple
    slider.maximumTrackTintColor = Palette.track
    slider.thumbTintColor = Palette.purple
    slider.isContinuous = true
    slider.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
    stack.addArrangedSubview(slider)

    sliderTicks.axis = .horizontal
    sliderTicks.distribution = .fillEqually
    for number in 1...states.count {
      let tick = UILabel()
      tick.text = "\(number)"
      tick.font = .systemFont(ofSize: 11, weight: .medium)
      tick.textColor = Palette.mutedText
      tick.textAlignment = number == 1 ? .left : (number == states.count ? .right : .center)
      sliderTicks.addArrangedSubview(tick)
    }
    stack.setCustomSpacing(2, after: slider)
    stack.addArrangedSubview(sliderTicks)

    stateLabel.font = .systemFont(ofSize: 14, weight: .bold)
    stateLabel.textColor = Palette.purple
    stateLabel.textAlignment = .center
    stack.addArrangedSubview(stateLabel)
    updateStateLabel()

    let symptomTitle = UILabel()
    symptomTitle.text = "증상 종류 (선택)"
    symptomTitle.font = .systemFont(ofSize: 13, weight: .semibold)
    symptomTitle.textColor = Palette.mutedText
    stack.setCustomSpacing(14, after: stateLabel)
    stack.addArrangedSubview(symptomTitle)

    typesStack.axis = .horizontal
    typesStack.alignment = .fill
    typesStack.distribution = .fillEqually
    typesStack.spacing = Metric.chipSpacing
    let none = typeButton(title: "없음", code: "none")
    typesStack.addArrangedSubview(none)
    typeButtons.append(none)
    for (title, code) in zip(typeTitles, typeCodes) {
      let button = typeButton(title: title, code: code)
      typesStack.addArrangedSubview(button)
      typeButtons.append(button)
    }
    stack.addArrangedSubview(typesStack)
    NSLayoutConstraint.activate([typesStack.heightAnchor.constraint(equalToConstant: 34)])
    updateTypeSelectionStyles()

    var saveConfiguration = UIButton.Configuration.filled()
    saveConfiguration.title = "기록 완료"
    saveConfiguration.baseBackgroundColor = Palette.purple
    saveConfiguration.baseForegroundColor = .white
    saveConfiguration.background.cornerRadius = 22
    saveConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
      var attributes = attributes
      attributes.font = .systemFont(ofSize: 16, weight: .bold)
      return attributes
    }
    saveButton.configuration = saveConfiguration
    saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    saveButton.isEnabled = false
    stack.setCustomSpacing(16, after: typesStack)
    stack.addArrangedSubview(saveButton)
    NSLayoutConstraint.activate([saveButton.heightAnchor.constraint(equalToConstant: 44)])

    statusLabel.font = .systemFont(ofSize: 12, weight: .regular)
    statusLabel.textColor = Palette.mutedText
    statusLabel.textAlignment = .center
    statusLabel.numberOfLines = 2
    statusLabel.isHidden = true
    stack.addArrangedSubview(statusLabel)
  }

  private func configureHeader(_ notification: UNNotification) {
    let bundle = Bundle.main
    headerAppNameLabel.text = bundle.object(forInfoDictionaryKey: "SymptomHeaderAppName") as? String
      ?? bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
      ?? "먹어도돼?"
    headerReceivedAtLabel.text = Self.receivedAtText(for: notification.date)

    let iconName = bundle.object(forInfoDictionaryKey: "SymptomHeaderIconName") as? String
    headerIconView.image = iconName.flatMap { UIImage(named: $0) }
    if headerIconView.image == nil {
      #if DEBUG
      NSLog("[SymptomNotificationContent] Header icon could not be loaded: %@", iconName ?? "<missing setting>")
      #endif
    }

    configureContent(userInfo: notification.request.content.userInfo)
  }

  private func configureContent(userInfo: [AnyHashable: Any]) {
    let dataTitle = userInfo["title"] as? String
    let dataBody = userInfo["body"] as? String
    titleLabel.text = dataTitle?.isEmpty == false ? dataTitle : "지금 속은 어때요?"

    let mealOccurredAt = userInfo["mealOccurredAt"] as? String
    let hoursElapsed = userInfo["hoursElapsed"] as? String
    let foodNames = userInfo["foodNames"] as? String
    var parts = [String]()
    if let mealOccurredAt, !mealOccurredAt.isEmpty {
      if let hoursElapsed, !hoursElapsed.isEmpty {
        parts.append("\(mealOccurredAt) 식사 후 \(hoursElapsed)시간 경과")
      } else {
        parts.append("\(mealOccurredAt) 식사")
      }
    }
    if let foodNames, !foodNames.isEmpty { parts.append(foodNames) }

    mealContextLabel.text = parts.isEmpty ? dataBody : parts.joined(separator: " · ")
    mealContextLabel.isHidden = mealContextLabel.text?.isEmpty != false
  }

  private static func receivedAtText(for date: Date, now: Date = Date()) -> String {
    let elapsed = max(0, now.timeIntervalSince(date))
    if elapsed < 60 { return "방금" }
    if elapsed < 3_600 { return "\(Int(elapsed / 60))분 전" }
    if elapsed < 86_400 { return "\(Int(elapsed / 3_600))시간 전" }

    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "M월 d일"
    return formatter.string(from: date)
  }

  private func typeButton(title: String, code: String) -> UIButton {
    let button = UIButton(type: .system)
    button.accessibilityIdentifier = code
    button.titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
    button.titleLabel?.lineBreakMode = .byTruncatingTail
    button.addTarget(self, action: #selector(typeTapped(_:)), for: .touchUpInside)
    applyTypeStyle(to: button, title: title, selected: code == "none")
    return button
  }

  private func applyTypeStyle(to button: UIButton, title: String, selected: Bool) {
    var configuration = UIButton.Configuration.plain()
    configuration.title = title
    configuration.baseForegroundColor = selected ? Palette.purple : .white
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
    configuration.background.backgroundColor = selected ? Palette.purple.withAlphaComponent(0.18) : Palette.chipBackground
    configuration.background.strokeColor = selected ? Palette.purple : Palette.chipBorder
    configuration.background.strokeWidth = 1
    configuration.background.cornerRadius = 17
    configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
      var attributes = attributes
      attributes.font = .systemFont(ofSize: 11, weight: .semibold)
      return attributes
    }
    button.configuration = configuration
  }

  @objc private func stateChanged() {
    let index = Int(slider.value.rounded())
    slider.setValue(Float(index), animated: true)
    selectedState = states[index]
    updateStateLabel()
  }

  private func updateStateLabel() {
    let index = Int(slider.value.rounded())
    stateLabel.text = "\(stateTitles[index]) (강도 \(index + 1) / 5)"
  }

  @objc private func typeTapped(_ sender: UIButton) {
    guard let code = sender.accessibilityIdentifier else { return }
    if code == "none" {
      selectedTypes.removeAll()
    } else if selectedTypes.contains(code) {
      selectedTypes.remove(code)
    } else {
      selectedTypes.insert(code)
    }
    updateTypeSelectionStyles()
  }

  private func updateTypeSelectionStyles() {
    for button in typeButtons {
      guard let code = button.accessibilityIdentifier,
            let title = button.configuration?.title else { continue }
      let isSelected = code == "none" ? selectedTypes.isEmpty : selectedTypes.contains(code)
      applyTypeStyle(to: button, title: title, selected: isSelected)
    }
  }

  @objc private func saveTapped() {
    guard canSave, let payload, let config = try? NativeNotificationConfig.load() else { return }
    saveButton.isEnabled = false
    let request = SymptomRequestBody(
      symptomState: selectedState,
      symptomTypes: Array(selectedTypes).sorted(),
      occurredAt: Self.iso8601KST.string(from: Date()),
      mealRecordId: payload.mealRecordId
    )
    do {
      let store = try SymptomOutboxStore(config: config)
      let id = try store.enqueue(request: request, ownerSubjectId: ownerSubjectId)
      if case .session(let session) = SharedAccessTokenStore(config: config).readResult(),
         let ownerSubjectId, session.subjectId == ownerSubjectId {
        try? SymptomNativeUploader.makeIfNeeded().upload(clientRecordId: id)
      }
      extensionContext?.dismissNotificationContentExtension()
    } catch {
      saveButton.isEnabled = true
      statusLabel.text = "기록을 보관하지 못했어요. 앱에서 다시 시도해 주세요."
      statusLabel.isHidden = false
    }
  }

  private func disableSave(_ message: String) {
    canSave = false
    saveButton.isEnabled = false
    statusLabel.text = message
    statusLabel.isHidden = false
  }

  private func logPayload(_ notification: UNNotification, isValid: Bool) {
    #if DEBUG
    let userInfo = notification.request.content.userInfo
    let type = userInfo["type"] as? String ?? "-"
    let targetId = userInfo["targetId"] as? String ?? ""
    let targetPrefix = String(targetId.prefix(8))
    let keys = userInfo.keys.compactMap { $0 as? String }.sorted().joined(separator: ",")
    NSLog(
      "[SymptomPush] category=%@ type=%@ targetIdPrefix=%@ keys=%@ valid=%@",
      notification.request.content.categoryIdentifier,
      type,
      targetPrefix.isEmpty ? "-" : targetPrefix,
      keys,
      isValid ? "true" : "false"
    )
    #endif
  }

  private static let iso8601KST: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
  }()
}
