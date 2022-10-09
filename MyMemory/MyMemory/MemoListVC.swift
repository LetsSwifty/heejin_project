//
//  MemoListVC.swift
//  MyMemory
//
//  Created by 김희진 on 2022/08/07.
//

import Foundation
import UIKit
import CoreData

class MemoListVC: UITableViewController, UISearchBarDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var dao = MemoDAO()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // 검색 바의 키보드에서 리턴 키가 항상 활성화되어 있도록 처리
        searchBar.enablesReturnKeyAutomatically = false
        
        if let revealVC = self.revealViewController() { // SWRevealViewController라이브러리의 revealViewController 객체를 읽어온다.
            let btn = UIBarButtonItem() // 객체가 있으면 바버튼을 설정해준다.
            btn.image = UIImage(named: "sidemenu.png")
            btn.target = revealVC
            btn.action = #selector(revealVC.revealToggle(_:))
            
            self.navigationItem.leftBarButtonItem = btn
            // 뷰에 revealVC의 제스쳐 객체를 등록한다.
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }
 
    // MemoListVC는 가장 처음 보이게 되는 VC이다. 따라서 UserInfoKey.tutorial 값을 찾아서 이 값이 없다면 튜토리얼 화면을 띄워준다. 
    override func viewWillAppear(_ animated: Bool) {
        let ud = UserDefaults.standard
        if ud.bool(forKey: UserInfoKey.tutorial) == false {
            let vc = self.instanceTutorialVC(name: "MasterVC")
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: false)
            return
        }

        // 코어 데이터에 저장된 데이터를 가져온다
        self.appDelegate.memoList = self.dao.fetch()
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let count = self.appDelegate.memoList.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = self.appDelegate.memoList[indexPath.row]
        let cellId = row.image == nil ? "memoCell" : "memoCellWIthImage"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MeMoTableViewCell
        
        cell?.subject?.text = row.title
        cell?.contents?.text = row.contents
        cell?.img?.image = row.image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell?.regdate?.text = formatter.string(from: row.redate!)
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = self.appDelegate.memoList[indexPath.row]
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? MemoReadVC else { return }
        
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.appDelegate.memoList[indexPath.row]

        // UI를 그리는 memoList에서 indexPath를 이용해 데이터를 가져와서 그 데이터를 코어데이터에서 삭제한다.
        if dao.delete(data.objectID!) {
            // 코어데이터에서 삭제한 후 memoList에서 삭제한다.
            self.appDelegate.memoList.remove(at: indexPath.row)
            // 테이블뷰에서 지운다.
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        
        self.appDelegate.memoList = self.dao.fetch(keyword: keyword)
        self.tableView.reloadData()
    }
}
