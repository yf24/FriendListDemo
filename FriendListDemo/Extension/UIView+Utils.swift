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
} 