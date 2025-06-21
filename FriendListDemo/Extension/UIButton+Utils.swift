import UIKit

extension UIButton {
    /// 設定圖片在右側的標準樣式（iOS 15+ configuration 版本）
    func setRightImageStyle(
        font: UIFont = .systemFont(ofSize: 15),
        title: String,
        image: UIImage?,
        imagePadding: CGFloat = 0,
        contentInsets: NSDirectionalEdgeInsets = .zero
    ) {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = image
        config.imagePlacement = .trailing
        config.imagePadding = imagePadding
        config.contentInsets = contentInsets
        config.background.backgroundColor = .clear
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = font
            return outgoing
        }
        self.configuration = config
    }
} 