//
//  BookListViewController.swift
//  MyBook
//
//  Created by 김희진 on 2022/05/05.
//

import UIKit
import Foundation
import SnapKit
import Realm
import RealmSwift

final class BookListViewController: UIViewController {
    
    let realm = try! Realm()
    var savedBook: [Book2] = []

    let mainView = MainView()
    lazy var bookTableView = mainView.makeTableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNaviBar()
        
        realmRead()
        if savedBook.count == 0 {
            realmCreate()
        }
        
        bookTableView.delegate = self
        bookTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubview(bookTableView)
        bookTableView.frame = view.bounds
    }

    
    @objc func didTouchGotoMypage(){
        let vc = MyPageViewController()
        
        let likeBookList = savedBook.filter { $0.isChecked2 == true }
        print(likeBookList)
        vc.likeBookList = likeBookList
        
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func didTouchLikeButton(sender: UIButton){
        
        let point = sender.convert(CGPoint.zero, to: bookTableView)
        guard let indexpath = bookTableView.indexPathForRow(at: point) else { return }
        
        let cell = bookTableView.cellForRow(at: indexpath) as? BookTableViewCell
        let data = savedBook[indexpath.row]
        
        if data.isChecked2 {
            cell?.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }else{
            cell?.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        realmUpdate(at: indexpath.row)
    }
    
    private func setupNaviBar(){
        navigationItem.title = "My BookApp"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(didTouchGotoMypage))
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNaviBar()
        realmRead()
    }
    
    func getThumbnailImage(_ index: Int) -> UIImage {
        let data = savedBook[index]
        
        guard let imageUrl = URL(string: data.bookImage2) else { return UIImage(systemName: "stop")! }
        let imageData = try! Data(contentsOf: imageUrl)

        return UIImage(data: imageData) ?? UIImage(systemName: "stop")!
    }


}

extension BookListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedBook.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }

        let data = savedBook[indexPath.row]
        cell.bookTitle.text = data.title2
        cell.bookDiscription.text = data.description2
        cell.bookImage.image = self.getThumbnailImage(indexPath.row)
        

        if data.isChecked2 {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else {
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        cell.likeButton.addTarget(self, action:  #selector(didTouchLikeButton), for: .touchUpInside)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension BookListViewController {
    
    func realmCreate(){
        let book = Book2()
        book.title2 = "데이터 중심 애플리케이션 설계"
        book.description2 = "신뢰할 수 있고 확장 가능하며 유지보수 하기 쉬운 시스템을 지탱하는 핵심 아이디어"
        book.bookImage2 = "http://swiftapi.rubypaper.co.kr:2029/thumbnail/REP_GL0000193505_1_1.jpg"
        book.isChecked2 = false

        let book2 = Book2()
        book2.title2 = "몽고DB The Definitive Guide"
        book2.description2 = "실전 예제로 배우는 NoSQL 데이터베이스 기초부터 활용까지"
        book2.bookImage2 = "http://swiftapi.rubypaper.co.kr:2029/thumbnail/REP_GL0000193505_1_1.jpg"
        book2.isChecked2 = false
        
        let book3 = Book2()
        book3.title2 = "부자 되는 법을 가르쳐 드립니다"
        book3.description2 = "미국에서 10년 가까이 검증받은 최고의 재태크 서적. 실용적이고 구체적이며 무엇보다 쉽다!"
        book3.bookImage2 = "http://swiftapi.rubypaper.co.kr:2029/thumbnail/REP_GL0000096285_1_1.jpg"
        book3.isChecked2 = false
        
        let book4 = Book2()
        book4.title2 = "성공을 위한 10가지 경로"
        book4.description2 = "당신의 비즈니스를 성공으로 이끌어줄 10가지 경로. 맥락, 결합, 순서의 멋진 하모니"
        book4.bookImage2 = ""
        book4.isChecked2 = false
        
        let book5 = Book2()
        book5.title2 = "인생의 마지막 순간에서"
        book5.description2 = "죽음에 대해 이보다 더 심오한 책이 있을까? 죽음과 죽어감에 관한 실질적 조언"
        book5.bookImage2 = "http://swiftapi.rubypaper.co.kr:2029/thumbnail/REP_00000042749_1_1_0215.jpg"
        book5.isChecked2 = false
        
        let book6 = Book2()
        book6.title2 = "모기"
        book6.description2 = "모기는 인류의 역사를 어떻게 바꾸었나? 최악의 살인자가 펼처내는 역사의 파노라마"
        book6.bookImage2 = ""
        book6.isChecked2 = false
        
        let book7 = Book2()
        book7.title2 = "당신의 뇌를 고칠 수 있다."
        book7.description2 = "작은 생활습관 변화로 당신의 뇌는 더 건강하고 효율적으로 변할 수 있다. 일찍 시작할수록 더좋다."
        book7.bookImage2 = "http://swiftapi.rubypaper.co.kr:2029/thumbnail/REP_GL0000185556_1_1.jpg"
        book7.isChecked2 = false

        let book8 = Book2()
        book8.title2 = "탁월한 인생을 사는 법"
        book8.description2 = "학습된 무기력에서 벗어나 인생 목표를 달성할 수 있도록 도와주는 책. 2020년 목표는 이 책으로 해결!"
        book8.bookImage2 = "http://swiftapi.rubypaper.co.kr:2029/thumbnail/REP_00000042890_1_1_0906.jpg"
        book8.isChecked2 = false
        
        let book9 = Book2()
        book9.title2 = "베스트 셀프"
        book9.description2 = "당신이 생각하는 최고의 자아로 썽장하고 싶다면 이 책에 나온 내용을 그대로 따라 하라. 자상한 코치처럼 당신의 성장을 부드럽게 이끌어 주는 책"
        book9.bookImage2 = ""
        book9.isChecked2 = false
        
        let book10 = Book2()
        book10.title2 = "몽고DB The Definitive Guide"
        book10.description2 = "실전 예제로 배우는 NoSQL 데이터베이스 기초부터 활용까지"
        book10.bookImage2 = "http://swiftapi.rubypaper.co.kr:2029/thumbnail/REP_GL0000158468_1_1.jpg"
        book10.isChecked2 = false
        
        try! realm.write{
            realm.add(book)
            realm.add(book2)
            realm.add(book3)
            realm.add(book4)
            realm.add(book5)
            realm.add(book6)
            realm.add(book7)
            realm.add(book8)
            realm.add(book9)
            realm.add(book10)
        }
    }
    
    func realmRead(){
        savedBook = Array(realm.objects(Book2.self))
        bookTableView.reloadData()
        //savedBook = a.filter("title2 == '타이틀'")
    }
    
    func realmUpdate(at item: Int){
        let taskToUpdate = savedBook[item]

        try! realm.write {
           taskToUpdate.isChecked2 = !taskToUpdate.isChecked2
        }
        DispatchQueue.main.async {
            self.realmRead()
        }
    }
    
    func realmDeleteSchema(){
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
                realmURL,
                realmURL.appendingPathExtension("lock"),
                realmURL.appendingPathExtension("note"),
                realmURL.appendingPathExtension("management")
            ]
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {}
        }
    }
    
    func realmDelateAt(at item: Int){
        let taskToDelete = realm.objects(Book2.self)[item]
        try! realm.write{
           realm.delete(taskToDelete)
        }
    }
    
    func realmDelateAll() {
        try! realm.write{
           realm.deleteAll()
        }
    }
}
