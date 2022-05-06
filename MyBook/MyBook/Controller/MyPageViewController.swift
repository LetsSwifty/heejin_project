//
//  MyPageViewController.swift
//  MyBook
//
//  Created by 김희진 on 2022/05/05.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import SnapKit

class MyPageViewController: UIViewController {
    
    var likeBookList: [Book2] = []
    let realm = try! Realm()

    
    private lazy var likeBookTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(LikeBookTableViewCell.self, forCellReuseIdentifier: LikeBookTableViewCell.identifier)
        return tableView
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "도서 목록이 없습니당"
        label.font = .boldSystemFont(ofSize: 20)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [emptyLabel, likeBookTableView].forEach{ view.addSubview($0) }
    
        likeBookTableView.frame = view.bounds
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    
        if likeBookList.isEmpty {
            likeBookTableView.isHidden = true
            emptyLabel.isHidden = false
        }else {
            likeBookTableView.isHidden = false
            emptyLabel.isHidden = true
        }
    }
    
    func getThumbnailImage(_ index: Int) -> UIImage {
        let data = likeBookList[index]
        
        guard let imageUrl = URL(string: data.bookImage2) else { return UIImage(systemName: "stop")! }
        let imageData = try! Data(contentsOf: imageUrl)

        return UIImage(data: imageData) ?? UIImage(systemName: "stop")!
    }
    
    @objc func didTouchDeleteButton(sender: UIButton){
        let point = sender.convert(CGPoint.zero, to: likeBookTableView)
        guard let indexpath = likeBookTableView.indexPathForRow(at: point) else { return }


        let alert = UIAlertController(title: "", message: "삭제 하시겠습니까?", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "확인", style: .destructive) {_ in
            
            let taskToUpdate = self.likeBookList[indexpath.row]
            try! self.realm.write {
               taskToUpdate.isChecked2 = !taskToUpdate.isChecked2
            }

            let temp = Array(self.realm.objects(Book2.self))
            self.likeBookList = temp.filter { $0.isChecked2 == true }

            self.likeBookTableView.reloadData()

            if self.likeBookList.isEmpty {
                self.likeBookTableView.isHidden = true
                self.emptyLabel.isHidden = false
            }

        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likeBookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeBookTableViewCell.identifier, for: indexPath) as? LikeBookTableViewCell else {
            return UITableViewCell()
        }
        
        let data = likeBookList[indexPath.row]
        cell.bookTitle.text = data.title2
        cell.bookDiscription.text = data.description2
        cell.bookImage.image = self.getThumbnailImage(indexPath.row)
        

        cell.deleteButton.addTarget(self, action:  #selector(didTouchDeleteButton), for: .touchUpInside)

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
