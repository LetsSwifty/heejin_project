//
//  MainView.swift
//  MyBook
//
//  Created by 김희진 on 2022/05/06.
//

import Foundation
import UIKit

class MainView {

    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.identifier)
        return tableView
    }
    
}
