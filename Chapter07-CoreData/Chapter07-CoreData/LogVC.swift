//
//  LogVC.swift
//  Chapter07-CoreData
//
//  Created by 김희진 on 2022/10/09.
//

import UIKit
import CoreData

// 코어데이터 모델의 type속성의 타입이 Int16이므로 맞춰주었다.
public enum LogType: Int16 {
    case create = 0
    case edit = 1
    case delete = 2
}

extension Int16 {
    func toLogType() -> String {
        switch self {
        case 0: return "생성"
        case 1: return "수정"
        case 2: return "삭제"
        default: return ""
        }
    }
}

class LogVC: UITableViewController {
    // BoardMO(배열아님!) 하나를 이전 VC에서 전달받아서
    var board: BoardMO!
    
    // 전달받는 board의 릴레이션인 logs를 가져와서 쓴다. 얘 타입은 LogMO
    // 전달받는 board의 변수 내부에 로그 목록에 대한 참조 정보가 포함되어있어서 가능!
    lazy var list: [LogMO]! = {
        return self.board.logs?.array as! [LogMO]
    }()

    // list와 완전히 동일한 값을 가져온다
    lazy var list2: [LogMO] = {
        // 요청 객체 생성
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // 검색 조건 생성
        let fetchRequest: NSFetchRequest<LogMO> = LogMO.fetchRequest()
        let predict = NSPredicate(format: "board == %@", self.board) // Log 엔터티의 레코드 중에서 board가 self.board 멤버 변수와 일치하는 것들만 가져와!
        fetchRequest.predicate = predict
        
        // 정렬 조건 생성
        let sort = NSSortDescriptor(key: "regdate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        // 데이터 가져오기
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            NSLog("%@ error: %@", error, error.userInfo)
            return []
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.board.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "logcell")!
        cell.textLabel?.text = "\(row.regdate!)에 \(row.type.toLogType()) 되었습니다"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return cell
    }
    
}
