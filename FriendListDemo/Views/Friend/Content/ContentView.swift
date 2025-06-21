//
//  ContentView.swift
//  FriendListDemo
//
//  Created by Ming on 2025/6/21.
//

import UIKit

public class ContentView: UIView {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    public var onAddFriendTapped: (() -> Void)? {
        didSet { emptyStateView.onAddButtonTapped = onAddFriendTapped }
    }
    public var onSetKokoIdLabelTapped: (() -> Void)? {
        didSet { emptyStateView.onSetKokoIdLabelTapped = onSetKokoIdLabelTapped }
    }

    // MARK: - Empty State
    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNibToSelf()
        showEmptyState()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNibToSelf()
        showEmptyState()
    }
    
    // MARK: - Public Method
    public func showEmptyState() {
        addSubview(emptyStateView)
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        bringSubviewToFront(emptyStateView)
        emptyStateView.onAddButtonTapped = onAddFriendTapped
    }

    public func hideEmptyState() {
        emptyStateView.removeFromSuperview()
    }
}

