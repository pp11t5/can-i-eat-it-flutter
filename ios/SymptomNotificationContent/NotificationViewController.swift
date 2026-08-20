import UIKit
import UserNotifications
import UserNotificationsUI

final class NotificationViewController: UIViewController, UNNotificationContentExtension {
  private var payload: SymptomPushPayload?
  private var selectedState = "normal"
  private var selectedTypes = Set<String>()
  private var canSave = false

  private let titleLabel = UILabel()
  private let stateLabel = UILabel()
  private let slider = UISlider()
  private let typesStack = UIStackView()
  private let saveButton = UIButton(type: .system)
  private let openButton = UIButton(type: .system)
  private let statusLabel = UILabel()
  private let typeCodes = ["throat_foreign_body", "acid_reflux", "cough", "chest_tightness"]
  private let typeTitles = ["목 이물감", "신물", "기침", "가슴 답답함"]

  override func viewDidLoad() {
    super.viewDidLoad()
    preferredContentSize = CGSize(width: 0, height: 420)
    view.backgroundColor = .secondarySystemBackground
    buildUI()
  }

  func didReceive(_ notification: UNNotification) {
    payload = SymptomPushPayload(userInfo: notification.request.content.userInfo)
    titleLabel.text = notification.request.content.title.isEmpty ? "지금 속은 어때요?" : notification.request.content.title
    guard let payload, let config = try? NativeNotificationConfig.load() else {
      disableSave("이 알림은 기록할 수 없어요."); return
    }
    let keychain = SharedAccessTokenStore(config: config)
    switch keychain.readResult() {
    case .session(let session) where session.subjectId == payload.subjectId:
      canSave = true; saveButton.isEnabled = true
    case .unavailableWhileLocked:
      // 잠금 상태에서는 native upload만 생략한다. Outbox 보관 후 앱 resume이 재전송한다.
      canSave = true; saveButton.isEnabled = true
    case .notFound, .session:
      disableSave("로그인 상태를 확인할 수 있어 앱에서 기록해 주세요.")
    case .error:
      canSave = true; saveButton.isEnabled = true
    }
  }

  private func buildUI() {
    let stack = UIStackView()
    stack.axis = .vertical; stack.spacing = 12; stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
      stack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -12)
    ])
    titleLabel.font = .preferredFont(forTextStyle: .headline); titleLabel.numberOfLines = 2
    stack.addArrangedSubview(titleLabel)
    stateLabel.font = .preferredFont(forTextStyle: .subheadline); stateLabel.textAlignment = .center
    stack.addArrangedSubview(stateLabel)
    slider.minimumValue = 0; slider.maximumValue = 4; slider.value = 2
    slider.isContinuous = true; slider.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
    stack.addArrangedSubview(slider)
    updateStateLabel()
    let symptomTitle = UILabel(); symptomTitle.text = "증상 종류 (복수 선택)"; symptomTitle.font = .preferredFont(forTextStyle: .subheadline)
    stack.addArrangedSubview(symptomTitle)
    typesStack.axis = .horizontal; typesStack.spacing = 6; typesStack.distribution = .fillEqually
    let none = typeButton(title: "없음", code: "none"); typesStack.addArrangedSubview(none)
    for (title, code) in zip(typeTitles, typeCodes) { typesStack.addArrangedSubview(typeButton(title: title, code: code)) }
    stack.addArrangedSubview(typesStack)
    saveButton.setTitle("기록 완료", for: .normal); saveButton.configuration = .filled()
    saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside); saveButton.isEnabled = false
    stack.addArrangedSubview(saveButton)
    openButton.setTitle("앱에서 자세히", for: .normal); openButton.configuration = .gray()
    openButton.addTarget(self, action: #selector(openApp), for: .touchUpInside)
    stack.addArrangedSubview(openButton)
    statusLabel.font = .preferredFont(forTextStyle: .footnote); statusLabel.textColor = .secondaryLabel; statusLabel.numberOfLines = 2
    stack.addArrangedSubview(statusLabel)
  }

  private func typeButton(title: String, code: String) -> UIButton {
    var config = UIButton.Configuration.tinted()
    config.title = title; config.baseForegroundColor = .label
    let button = UIButton(configuration: config)
    button.accessibilityIdentifier = code
    button.addTarget(self, action: #selector(typeTapped(_:)), for: .touchUpInside)
    return button
  }

  @objc private func stateChanged() {
    let index = Int(slider.value.rounded())
    slider.setValue(Float(index), animated: true)
    selectedState = ["comfortable", "good", "normal", "uncomfortable", "severe"][index]
    updateStateLabel()
  }

  private func updateStateLabel() {
    let title = ["편안함", "좋음", "보통", "불편함", "심함"][Int(slider.value.rounded())]
    stateLabel.text = "증상 강도: \(title)"
  }

  @objc private func typeTapped(_ sender: UIButton) {
    guard let code = sender.accessibilityIdentifier else { return }
    if code == "none" { selectedTypes.removeAll() } else {
      selectedTypes.remove("none")
      if selectedTypes.contains(code) { selectedTypes.remove(code) } else { selectedTypes.insert(code) }
    }
    for case let button as UIButton in typesStack.arrangedSubviews {
      let selected = button.accessibilityIdentifier == "none" ? selectedTypes.isEmpty : selectedTypes.contains(button.accessibilityIdentifier ?? "")
      button.configuration?.baseBackgroundColor = selected ? .systemIndigo : .clear
    }
  }

  @objc private func saveTapped() {
    guard canSave, let payload, let config = try? NativeNotificationConfig.load() else { return }
    saveButton.isEnabled = false
    let request = SymptomRequestBody(
      symptomState: selectedState, symptomTypes: Array(selectedTypes).sorted(),
      occurredAt: Self.iso8601KST.string(from: Date()), mealRecordId: payload.mealRecordId
    )
    do {
      let store = try SymptomOutboxStore(config: config)
      let id = try store.enqueue(payload: payload, request: request)
      if case .session(let session) = SharedAccessTokenStore(config: config).readResult(), session.subjectId == payload.subjectId {
        try? SymptomNativeUploader.makeIfNeeded().upload(clientRecordId: id)
      }
      extensionContext?.dismissNotificationContentExtension()
    } catch {
      saveButton.isEnabled = true
      statusLabel.text = "기록을 보관하지 못했어요. 앱에서 다시 시도해 주세요."
    }
  }

  @objc private func openApp() { extensionContext?.performNotificationDefaultAction() }
  private func disableSave(_ message: String) { canSave = false; saveButton.isEnabled = false; statusLabel.text = message }

  private static let iso8601KST: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
  }()
}
