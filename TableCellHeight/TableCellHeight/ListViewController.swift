//
//  ListViewController.swift
//  TableCellHeight
//
//  Created by 김희진 on 2022/04/28.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    
    var list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func add(_ sender: UIButton){
        
        let alert = UIAlertController(title: "목록 입력", message: "추가될 글을 작성해주세여", preferredStyle: .alert)
        
        alert.addTextField(){ tf in
            // 입력폼에 대한 이러저러한 설정을 한다.
            tf.placeholder = "내용을 입룍하세요"
        }
        
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            if let title = alert.textFields?[0].text {
                self.list.append(title)
                self.tableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
        
}
