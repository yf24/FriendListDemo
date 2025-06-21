import UIKit

extension UIView {
    /// 自動從與 class 同名的 xib 載入 view 並加到 self，避免無限遞迴
    func loadFromNibToSelf() {
        let className = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        // 避免無限遞迴：如果 nib 載入的主 view 就是 self，則不再重複加載
        if bundle.path(forResource: className, ofType: "nib") != nil,
           subviews.isEmpty {
            guard let view = bundle.loadNibNamed(className, owner: self, options: nil)?.first as? UIView,
                  view !== self else { return }
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(view)
        }
    }

    // MARK: - Indicator View
    private static let indicatorTag = 9999

    /// 在底部顯示一條指示線
    func showIndicator(
        color: UIColor, 
        weight: CGFloat = 20, 
        height: CGFloat = 4, 
        cornerRadius: CGFloat = 2
    ) {
        removeIndicator()
        let indicator = UIView()
        indicator.backgroundColor = color
        indicator.layer.cornerRadius = cornerRadius
        indicator.tag = UIView.indicatorTag
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.heightAnchor.constraint(equalToConstant: height),
            indicator.widthAnchor.constraint(equalToConstant: weight),
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }

    /// 移除底部指示線
    func removeIndicator() {
        subviews.first(where: { $0.tag == UIView.indicatorTag })?.removeFromSuperview()
    }
} 
