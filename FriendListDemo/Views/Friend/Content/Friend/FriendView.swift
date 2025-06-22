//
//  ContentView.swift
//  FriendListDemo
//
//  Created by Ming on 2025/6/21.
//

import UIKit
import Combine

class FriendView: UIView {
    // MARK: - Event Enum
    enum Event {
        case addFriend
        case setKokoId
        case transfer(Friend)
        case invite(Friend)
        case more(Friend)
    }
    // MARK: - Publisher
    let eventPublisher = PassthroughSubject<Event, Never>()

    // MARK: - Properties
    let tableView = UITableView()
    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Data
    private var friends: [Friend] = []

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        showEmptyState()
        setupBindings()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    private func setupBindings() {
        emptyStateView.onAddButtonTapped = { [weak self] in
            self?.eventPublisher.send(.addFriend)
        }
        emptyStateView.onSetKokoIdLabelTapped = { [weak self] in
            self?.eventPublisher.send(.setKokoId)
        }
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
        cell.onTransferTapped = { [weak self] in self?.eventPublisher.send(.transfer(friend)) }
        cell.onInviteTapped = { [weak self] in self?.eventPublisher.send(.invite(friend)) }
        cell.onMoreTapped = { [weak self] in self?.eventPublisher.send(.more(friend)) }
        return cell
    }
}

