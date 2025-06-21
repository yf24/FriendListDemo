import UIKit

public class GradientButton: UIButton {
    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()
    public var gradientColors: [UIColor] {
        didSet {
            updateGradientColors()
            setNeedsLayout()
        }
    }
    public var customCornerRadius: CGFloat?
    private var rightImageView: UIImageView?
    private var rightIconTrailingSpacing: CGFloat = 16
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        self.gradientColors = [.red, .blue]
        super.init(frame: frame)
        // clipsToBounds = true
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        self.gradientColors = [.red, .blue]
        super.init(coder: coder)
        // clipsToBounds = true
        setupGradient()
    }
    
    // MARK: - Gradient
    private func setupGradient() {
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    private func updateGradientColors() {
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.setNeedsDisplay()
    }
    
    // MARK: - Layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.removeFromSuperlayer()
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = bounds
        let radius = customCornerRadius ?? (bounds.height / 2)
        layer.cornerRadius = radius
        gradientLayer.cornerRadius = radius
        updateGradientColors()
        // layout rightImageView
        if let rightImageView = rightImageView, !rightImageView.isHidden, let titleLabel = titleLabel {
            let imageSize = rightImageView.intrinsicContentSize
            let buttonHeight = bounds.height
            let buttonWidth = bounds.width
            let imageY = (buttonHeight - imageSize.height) / 2
            let imageX = buttonWidth - imageSize.width - rightIconTrailingSpacing
            rightImageView.frame = CGRect(x: imageX, y: imageY, width: imageSize.width, height: imageSize.height)
            // 調整 titleLabel 置中（不受 image 影響）
            let titleWidth = titleLabel.intrinsicContentSize.width
            titleLabel.frame = CGRect(
                x: (buttonWidth - titleWidth) / 2,
                y: titleLabel.frame.origin.y,
                width: titleWidth,
                height: titleLabel.frame.height
            )
        }
        setShadow()
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        setupGradient() // 確保 nib instantiate 後 gradientLayer 一定有加進來
    }
    
    // MARK: - Public API
    /// 設定標題、字型、顏色
    public func set(title: String, font: UIFont = .systemFont(ofSize: 20, weight: .medium)) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = font
    }
    
    /// 設定右側 icon
    public func setRightIcon(image: UIImage?, trailingSpacing: CGFloat = 16) {
        if let image = image {
            if rightImageView == nil {
                let iv = UIImageView()
                iv.contentMode = .center
                iv.isUserInteractionEnabled = false
                addSubview(iv)
                rightImageView = iv
            }
            rightImageView?.image = image
            rightImageView?.isHidden = false
            rightIconTrailingSpacing = trailingSpacing
            setNeedsLayout()
        } else {
            rightImageView?.isHidden = true
        }
    }
    
    // MARK: - Shadow
    public func setShadow(
        color: UIColor? = nil,
        opacity: Float = 0.4,
        offset: CGSize = CGSize(width: 0, height: 4),
        blur: CGFloat = 8,
        spread: CGFloat = 0
    ) {
        let shadowColor = color ?? UIColor(resource: .appleGreen40)
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = blur / 2.0
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius).cgPath
        }
        layer.masksToBounds = false
    }
} 
