//
//  ListViewController.swift
//  Chapter03-Alert
//
//  Created by 김희진 on 2022/09/10.
//

import UIKit

protocol ListProtocol {
    func didSelectRowAt(indexPath: IndexPath)
    func test()
}

class ListViewController: UITableViewController {
    
    var delegate: ListProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize.height = 220
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)번째"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 11)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectRowAt(indexPath: indexPath)
        self.delegate?.test()
    }
}
