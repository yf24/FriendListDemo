import UIKit

class HeaderView: UIView {
    // nav button
    @IBOutlet weak var atmButton: UIButton!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    // user info
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kokoIdLabel: UILabel!
    @IBOutlet weak var avatarButton: UIButton!
    // control panel
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNibToSelf()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNibToSelf()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 預設 UI 設定

//        nameLabel.text = "紫琳"
//        kokoIdLabel.text = "KOKO ID：olylinhuang"
    }
} 
