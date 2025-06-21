//
//  ContentView.swift
//  FriendListDemo
//
//  Created by Ming on 2025/6/21.
//

import UIKit

class ContentView: UIView {
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var emptyStateView: EmptyStateView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNibToSelf()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNibToSelf()
    }
}

