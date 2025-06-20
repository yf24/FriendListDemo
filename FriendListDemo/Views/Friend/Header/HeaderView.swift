import UIKit

class HeaderView: UIView {
    @IBOutlet weak var atmButton: UIButton!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kokoIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 預設 UI 設定
//        avatarImageView.layer.cornerRadius = 28
//        avatarImageView.clipsToBounds = true
//        nameLabel.text = "紫琳"
//        kokoIdLabel.text = "KOKO ID：olylinhuang"
    }
} 
