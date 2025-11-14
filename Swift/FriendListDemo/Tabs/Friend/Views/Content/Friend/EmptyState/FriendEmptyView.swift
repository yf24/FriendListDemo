import UIKit

class FriendEmptyView: UIView {
    // MARK: - Properties
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addFriendButton: GradientButton!
    @IBOutlet weak var setKokoIdLabel: UILabel! {
        didSet { setupKokoIdLabel() }
    }

    // MARK: - Callback
    var onAddButtonTapped: (() -> Void)?
    var onSetKokoIdLabelTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNibToSelf()
        setupBindings()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNibToSelf()
        setupBindings()
    }

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }

    // MARK: - UI
    private func setupUI() {
        titleLabel.text = "就從加好友開始吧：）".localized
        descriptionLabel.text = "與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包喔：）".localized
        addFriendButton.gradientColors = [.frogGreen, .b]
        addFriendButton.customCornerRadius = 20
        addFriendButton.set(title: "加好友".localized,
                      font: .systemFont(ofSize: 16, weight: .medium))
        addFriendButton.setRightIcon(image: .smileFace, trailingSpacing: 8)
        setupKokoIdLabel()
    }

    // MARK: - UI: KOKO ID Label
    private func setupKokoIdLabel() {
        let normalText = "幫助好友更快找到你？".localized
        let linkText = "設定 KOKO ID".localized
        let fullText = normalText + linkText
        let attributed = NSMutableAttributedString(string: fullText)
        attributed.addAttribute(
            .foregroundColor, 
            value: UIColor.lightGrey, 
            range: NSRange(location: 0, length: normalText.count))
        attributed.addAttribute(
            .foregroundColor, 
            value: UIColor(resource: .hotPink), 
            range: NSRange(location: normalText.count, 
            length: linkText.count))
        attributed.addAttribute(
            .underlineStyle, 
            value: NSUnderlineStyle.single.rawValue, 
            range: NSRange(location: normalText.count, 
            length: linkText.count))
        setKokoIdLabel.attributedText = attributed
        setKokoIdLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onKokoIdTapped))
        setKokoIdLabel.addGestureRecognizer(tap)
    }

    // MARK: - Binding
    @objc private func onKokoIdTapped() {
        onSetKokoIdLabelTapped?()
    }

    private func setupBindings() {
        addFriendButton.addAction(UIAction { [weak self] _ in
            self?.onAddButtonTapped?()
        }, for: .touchUpInside)
    }
}
