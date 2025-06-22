//
//  ContentView.swift
//  FriendListDemo
//
//  Created by Ming on 2025/6/21.
//

import UIKit

class FriendView: UIView {
    // MARK: - Properties
    let tableView = UITableView()
    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Action
    // Friend - Empty State View
    var onAddFriendTapped: (() -> Void)? {
        didSet { emptyStateView.onAddButtonTapped = onAddFriendTapped }
    }
    var onSetKokoIdLabelTapped: (() -> Void)? {
        didSet { emptyStateView.onSetKokoIdLabelTapped = onSetKokoIdLabelTapped }
    }
    // Friend - Table View Cell
    var onTransferTapped: ((Friend) -> Void)?
    var onInviteTapped: ((Friend) -> Void)?
    var onMoreTapped: ((Friend) -> Void)?

    // MARK: - Data
    private var friends: [Friend] = []

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        showEmptyState()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
        showEmptyState()
    }

    // MARK: - Private Method
    private func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        tableView.register(UINib(nibName: FriendListCell.identifier, bundle: nil), forCellReuseIdentifier: FriendListCell.identifier)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
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

    public func update(with friends: [Friend]) {
        self.friends = friends
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate & DataSource
extension FriendView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendListCell.identifier, for: indexPath) as? FriendListCell else {
            return UITableViewCell()
        }
        let friend = friends[indexPath.row]
        cell.configure(with: friend)
        cell.onTransferTapped = { [weak self] in self?.onTransferTapped?(friend) }
        cell.onInviteTapped = { [weak self] in self?.onInviteTapped?(friend) }
        cell.onMoreTapped = { [weak self] in self?.onMoreTapped?(friend) }
        return cell
    }
}

