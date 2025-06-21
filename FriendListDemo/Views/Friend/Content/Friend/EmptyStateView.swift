import UIKit

class EmptyStateView: UIView {
    @IBOutlet weak var illustrationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var kokoIdButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 預設 UI 設定
//        titleLabel.text = "就從加好友開始吧 :)"
//        descriptionLabel.text = "與好友們一起用 KOKO 轉帳吧！還能互相收付款、記帳呢 :)"
//        addButton.setTitle("加好友", for: .normal)
//        kokoIdButton.setTitle("設定 KOKO ID", for: .normal)
    }
} 
