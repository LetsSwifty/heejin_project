//
//  ViewController.swift
//  MyBook
//
//  Created by 김희진 on 2022/05/05.
//

import UIKit
import Foundation
import SnapKit

struct Book {
    let title: String
    let description: String
    var isChecked: Bool
}

final class ViewController: UIViewController {
    
    private lazy var bookTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.identifier)
        return tableView
    }()

    private lazy var bookList: [Book] = [
        Book(title : "sd1", description : "책설명dhjfg sjdhgfhsadgf jshgfdjh a   gdsfjka ghsdfkga dkjhga sdkfjghaskdjhfgkjhg", isChecked : false ),
        Book(title : "sd2", description : "책설명dhjfg sjdhgfhsadgf jshgfdjh a   gdsfjka ghsdfkga dkjhga sdkfjghaskdjhfgkjhg", isChecked : true ),
        Book(title : "sd3", description : "책설명dhjfg sjdhgfhsadgf jshgfdjh a   gdsfjka ghsdfkga dkjhga sdkfjghaskdjhfgkjhg", isChecked : false ),
        Book(title : "sd4", description : "책설명dhjfg sjdhgfhsadgf jshgfdjh a   gdsfjka ghsdfkga dkjhga sdkfjghaskdjhfgkjhg", isChecked : true ),
        Book(title : "sd5", description : "책설명dhjfg sjdhgfhsadgf jshgfdjh a   gdsfjka ghsdfkga dkjhga sdkfjghaskdjhfgkjhg", isChecked : true )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubview(bookTableView)
        bookTableView.frame = view.bounds
    }

    
    @objc func didTouchGotoMypage(){
        navigationController?.pushViewController(MyPageViewController(), animated: false)
    }
    
    @objc func didTouchLikeButton(sender: UIButton){
        
        let point = sender.convert(CGPoint.zero, to: bookTableView)
        guard let indexpath = bookTableView.indexPathForRow(at: point) else { return }
        
        let cell = bookTableView.cellForRow(at: indexpath) as? BookTableViewCell
 
        let data = bookList[indexpath.row]
        
        if data.isChecked {
            cell?.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }else{
            cell?.likeButton.setImage(UIImage(systemName: "note"), for: .normal)
        }
        
        
        // 서버 통신 코드
        bookList[indexpath.row].isChecked = !bookList[indexpath.row].isChecked

        bookTableView.reloadData()
    }
    
    private func setupNaviBar(){
        navigationItem.title = "My BookApp"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(didTouchGotoMypage))
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNaviBar()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }
             
        let data = bookList[indexPath.row]
        cell.bookTitle.text = data.title
        cell.bookDiscription.text = data.description
        
        if data.isChecked {
            cell.likeButton.setImage(UIImage(systemName: "note"), for: .normal)
        }else{
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        cell.likeButton.addTarget(self, action:  #selector(didTouchLikeButton), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
