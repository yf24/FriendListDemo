import UIKit

class ContainerView: UIView {
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var contentView: FriendView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNibToSelf()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNibToSelf()
    }
} 
