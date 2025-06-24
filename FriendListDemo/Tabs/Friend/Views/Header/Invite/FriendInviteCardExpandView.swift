import UIKit

class FriendInviteCardExpandView: UIView {
    // MARK: - Properties
    private var isExpanded: Bool = false
    private var cardViews: [FriendInviteCardView] = []
    private let shrink: CGFloat = 10
    private let yOffset: CGFloat = 8
    private let maxStack = 2 // 收合時最多顯示兩層

    // MARK: - Public Callback
    var onAgreeTapped: ((Friend) -> Void)?
    var onDeclineTapped: ((Friend) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupGesture()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupGesture()
    }

    // MARK: - Public Method
    func updateInvitations(_ invitations: [Friend]) {
        cardViews.forEach { $0.removeFromSuperview() }
        cardViews.removeAll()
        for invite in invitations {
            let card = FriendInviteCardView()
            card.configure(with: invite)
            card.onAgreeTapped = { [weak self] friend in
                self?.onAgreeTapped?(friend)
            }
            card.onDeclineTapped = { [weak self] friend in
                self?.onDeclineTapped?(friend)
            }
            addSubview(card)
            cardViews.append(card)
        }
        layoutCards(animated: false)
        self.invalidateIntrinsicContentSize()
    }

    func setExpanded(_ expanded: Bool, animated: Bool = true) {
        isExpanded = expanded
        layoutCards(animated: animated)
        self.invalidateIntrinsicContentSize()
    }

    func expand() { setExpanded(true, animated: true) }
    func collapse() { setExpanded(false, animated: true) }

    // MARK: - Layout
    private func layoutCards(animated: Bool) {
        let shouldDisableButtons = !isExpanded && cardViews.count >= 2
        for (index, card) in cardViews.enumerated() {
            card.layer.zPosition = CGFloat(100 - index)
            card.isHidden = false
            let targetFrame: CGRect
            let targetTransform: CGAffineTransform
            if isExpanded {
                // 展開：全部正常排列
                let cardHeight = card.intrinsicContentSize.height > 0 ? card.intrinsicContentSize.height : 80
                targetFrame = CGRect(x: 0, y: CGFloat(index) * (cardHeight + 12), width: bounds.width, height: cardHeight)
                targetTransform = .identity
            } else {
                if index == 0 {
                    // 第一張正常
                    let cardHeight = card.intrinsicContentSize.height > 0 ? card.intrinsicContentSize.height : 80
                    targetFrame = CGRect(x: 0, y: 0, width: bounds.width, height: cardHeight)
                    targetTransform = .identity
                } else if index < maxStack {
                    // 第二張縮小、偏移、疊在第一張下方
                    let scale: CGFloat = 0.96
                    let xInset = shrink
                    let yTrans = yOffset
                    let cardHeight = card.intrinsicContentSize.height > 0 ? card.intrinsicContentSize.height : 80
                    targetFrame = CGRect(x: xInset, y: yTrans, width: bounds.width - 2 * xInset, height: cardHeight)
                    targetTransform = CGAffineTransform(scaleX: scale, y: scale)
                } else {
                    card.isHidden = true
                    continue
                }
            }
            if animated {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                    card.frame = targetFrame
                    card.transform = targetTransform
                    card.alpha = 1
                }, completion: nil)
            } else {
                card.frame = targetFrame
                card.transform = targetTransform
                card.alpha = 1
            }
            // 設定按鈕互動
            card.agreeButton.isUserInteractionEnabled = !shouldDisableButtons
            card.declineButton.isUserInteractionEnabled = !shouldDisableButtons
        }
        self.invalidateIntrinsicContentSize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCards(animated: false)
    }

    override var intrinsicContentSize: CGSize {
        if cardViews.isEmpty {
            return CGSize(width: UIView.noIntrinsicMetric, height: 0)
        }
        let cardHeight: CGFloat = cardViews.first?.intrinsicContentSize.height ?? 80
        let spacing: CGFloat = 12
        if isExpanded {
            // 展開：全部卡片高度 + 間距
            let totalHeight = CGFloat(cardViews.count) * cardHeight + CGFloat(max(cardViews.count - 1, 0)) * spacing
            let size = CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
            return size
        } else {
            // 收合：第一張正常，第二張如果有要算縮小後的高度和偏移
            if cardViews.count == 1 {
                return CGSize(width: UIView.noIntrinsicMetric, height: cardHeight)
            } else {
                // 第二張縮小、偏移
                let scale: CGFloat = 0.96
                let yOffset: CGFloat = 8
                let secondCardHeight = cardHeight * scale + yOffset
                let totalHeight = max(cardHeight, secondCardHeight)
                return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
            }
        }
    }

    // MARK: - Private Methods
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }

    // MARK: - Actions
    @objc private func handleTap() {
        // 防呆：只有多於一張卡片時才允許展開/收合
        guard cardViews.count > 1 else { return }
        if isExpanded {
            collapse()
        } else {
            expand()
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension FriendInviteCardExpandView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 如果點到 UIButton（或其子 view），就不處理 tap
        var view = touch.view
        while let v = view {
            if v is UIButton {
                return false
            }
            view = v.superview
        }
        return true
    }
} 
