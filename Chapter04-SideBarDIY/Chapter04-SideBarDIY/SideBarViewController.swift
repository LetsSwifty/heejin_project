//
//  SideBarViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by 김희진 on 2022/09/12.
//

import UIKit

// 사이드 바로 열리는 화면
class SideBarViewController: UITableViewController {
    
    let titles = ["메뉴1", "메뉴2", "메뉴3", "메뉴4", "메뉴5"]
    let icons = [UIImage(named: "icon01.png"), UIImage(named: "icon02.png"), UIImage(named: "icon03.png"), UIImage(named: "icon04.png"), UIImage(named: "icon05.png")]

    override func viewDidLoad() {
        super.viewDidLoad()
        let accountLabel = UILabel()
        accountLabel.frame = CGRect(x: 10, y: 30, width: self.view.frame.width, height: 30)
        accountLabel.text = "heejin@naver.com"
        accountLabel.textColor = .white
        accountLabel.font = .boldSystemFont(ofSize: 15)
        
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70)
        v.backgroundColor = .brown
        v.addSubview(accountLabel)
                
        self.tableView.tableHeaderView = v
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "menuCell"

        /**
        var cell = tableView.dequeueReusableCell(withIdentifier: id)
        // menuCell 이 id인 셀이 없다면 새로 menuCell 이라는 아이덴티파이어가 있는 셀을 생성한다.
        if cell == nil {
            // 실제로 이 구문은 self.tableView.register(셀클래스.self, forCellReuseIdentifier: id) 이과정이랑 비슷하다고 보면된다.
            cell = UITableViewCell(style: .default, reuseIdentifier: id)
        }
        */
        
        // 위의 주석친 부분 전체와 동일!
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        
        
//        // 만약 셀이 몇개 없어서 화면 밖으로 스크롤되지 않아 reuse가 필요없다면,
//        let cell2 = UITableViewCell()
//        cell2.textLabel?.text = "이런식으로 해도 된다"
        
        return cell
    }
    
}



