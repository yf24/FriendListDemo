import UIKit

class BadgeView: UILabel {
    private let horizontalPadding: CGFloat = 3.5
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + horizontalPadding * 2, height: size.height)
    }

    // MARK: - Init
    init(bgColor: UIColor, textColor: UIColor = .white, font: UIFont = .boldSystemFont(ofSize: 14)) {
        super.init(frame: .zero)
        self.backgroundColor = bgColor
        self.textColor = textColor
        self.font = font
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
        super.drawText(in: rect.inset(by: insets))
    }
    
    private func setup() {
        text = "99+"
        textAlignment = .center
        clipsToBounds = true
        heightAnchor.constraint(equalToConstant: 18).isActive = true
       widthAnchor.constraint(greaterThanOrEqualToConstant: 18).isActive = true
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
    }
} 
