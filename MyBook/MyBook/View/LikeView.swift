//
//  LikeView.swift
//  MyBook
//
//  Created by 김희진 on 2022/05/07.
//

import Foundation
import UIKit

class LikeView {

    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.register(LikeBookTableViewCell.self, forCellReuseIdentifier: LikeBookTableViewCell.identifier)
        return tableView
    }
    
}
