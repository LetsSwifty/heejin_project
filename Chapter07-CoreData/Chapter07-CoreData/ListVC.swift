//
//  ListVC.swift
//  Chapter07-CoreData
//
//  Created by 김희진 on 2022/10/09.
//

import UIKit
import CoreData

class ListVC: UITableViewController {
    
    lazy var list: [NSManagedObject] = {
        return self.fetch()
    }()
    
    //코어데이터에서 데이터를 가져오는 메소드
    func fetch() -> [NSManagedObject] {
        
        // 관리 객체 컨텍스트 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // 앱 델리게이트 객체 참조
        let context = appDelegate.persistentContainer.viewContext // 컨텍스트 참조
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board") // 요청객체 생성. fetchRequest 는 Board엔터티 구조로 저장된 모든 데이터를 읽어들이는 요청이다.
        
        //정렬
        let sort = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let result = try! context.fetch(fetchRequest) // 요청. CRUD 작성 가능. 지금은 Read!
        return result
    }
    
    //코어데이터에 데이터를 저장하는 메소드
    func save(title: String, contents: String) -> Bool {
        // 관리 객체 컨텍스트 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // 앱 델리게이트 객체 참조
        let context = appDelegate.persistentContainer.viewContext // 컨텍스트 참조
        
        // 관리 객체 생성및 값 설정
        let object = NSEntityDescription.insertNewObject(forEntityName: "Board", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")
        
        
        // 로그 생성 로직
        let logObject = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        logObject.regdate = Date()
        logObject.type = LogType.create.rawValue
        // 게시글 객체의 logs 속성에 새로 생성된 로그 객체 추가 -> 이렇게 해야 1:M 관계로 참조되도록 할 수 있음!
        (object as! BoardMO).addToLogs(logObject)
//        logObject.board = (object as! BoardMO) -> 위와 동일. 게시글 하위에 로그 인스턴스를 추가하는 것이 아니라 로그 인스턴스가 게시글을 참조하도록 처리하는 방식이다. 서로 역참조 관계이기 때문에 어떻게 해도 상관 없다!

        do {
            try context.save()
            self.list.insert(object, at: 0)
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    //데이터 저장 버튼에 대한 액션 메소드
    @objc func add(_ sender: Any) {
        let alert = UIAlertController(title: "게시글 등록", message: nil, preferredStyle: .alert)
        
        alert.addTextField() { $0.placeholder = "제목"}
        alert.addTextField() { $0.placeholder = "내용"}
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let title = alert.textFields?.first?.text, let contents = alert.textFields?.last?.text else {
                return
            }
            
            if self.save(title: title, contents: contents) == true {
                self.tableView.reloadData()
            }
        })
        self.present(alert, animated: true)
    }
    
    //데이터를 삭제할 메소드
    func delete(object: NSManagedObject) -> Bool {
        // 관리 객체 컨텍스트 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // 앱 델리게이트 객체 참조
        let context = appDelegate.persistentContainer.viewContext // 컨텍스트 참조
        
        context.delete(object)
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    func edit(object: NSManagedObject, title: String, contents: String) -> Bool {
        // 관리 객체 컨텍스트 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // 앱 델리게이트 객체 참조
        let context = appDelegate.persistentContainer.viewContext // 컨텍스트 참조
        
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")
        
        // 로그 생성 로직
        let logObject = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        logObject.regdate = Date()
        logObject.type = LogType.edit.rawValue
        // 게시글 객체의 logs 속성에 새로 생성된 로그 객체 추가 -> 이렇게 해야 1:M 관계로 참조되도록 할 수 있음!
        (object as! BoardMO).addToLogs(logObject)
//        logObject.board = (object as! BoardMO) -> 위와 동일. 게시글 하위에 로그 인스턴스를 추가하는 것이 아니라 로그 인스턴스가 게시글을 참조하도록 처리하는 방식이다. 서로 역참조 관계이기 때문에 어떻게 해도 상관 없다!
        
        do {
            try context.save() //save 함수는 컨텍스트를 원격 저장소에 저장해 동기화 시키는 메서드다.
            self.list = self.fetch()
             return true
        } catch {
            context.rollback()
            return false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addBtn
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.list[indexPath.row]
        let title = object.value(forKey: "title") as? String
        let contents = object.value(forKey: "contents") as? String
        
        let alert = UIAlertController(title: "게시글 수정", message: nil, preferredStyle: .alert)
        alert.addTextField() { $0.placeholder = title}
        alert.addTextField() { $0.placeholder = contents}
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let title = alert.textFields?.first?.text, let contents = alert.textFields?.last?.text else {
                return
            }
            
            if self.edit(object: object, title: title, contents: contents) == true {
//                self.tableView.reloadData()
             
                // 수정된 셀을 맨 위로 올려버린다.
                let cell = self.tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = title
                cell?.detailTextLabel?.text = contents
                
                let firstIndexPath = IndexPath(item: 0, section: 0)
                self.tableView.moveRow(at: indexPath, to: firstIndexPath)
            }
        })
        self.present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let object = self.list[indexPath.row]
        
        if self.delete(object: object) {
            self.list.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = self.list[indexPath.row]
        // record 는 NSManagedObejct 타입이기 때문에, .value 를 통해서 데이터를 가져와야한다.
        let title = record.value(forKey: "title") as? String
        let contents = record.value(forKey: "contents") as? String

        let cell = tv.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = contents
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let object = self.list[indexPath.row]
        let uvc = self.storyboard?.instantiateViewController(withIdentifier: "LogVC") as! LogVC
        uvc.board = (object as! BoardMO)
        
        self.show(uvc, sender: self)
    }
}
