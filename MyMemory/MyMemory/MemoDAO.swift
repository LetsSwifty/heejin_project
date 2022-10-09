//
//  MemoDAO.swift
//  MyMemory
//
//  Created by 김희진 on 2022/10/09.
//

import UIKit
import CoreData

class MemoDAO {
    //관리 객체 컨텍스트를 반환하는 멤버변수
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    //저장된 메모 전체를 불러오는 메소드
    func fetch(keyword text: String? = nil) -> [MemoData] { // text는 옵셔널이고 기본값이 nil이라 기존에 사용했던 곳들에 에러가나지 않음!
        var memoList = [MemoData]()
        
        //요청 객체 생성
        let fetchRequest: NSFetchRequest<MemoMO> = MemoMO.fetchRequest()
        
        //최신 글 순으로 정렬하도록 정렬 객체 생성
        let regdateDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [regdateDesc]
 
        if let t = text, t.isEmpty == false {
            fetchRequest.predicate = NSPredicate(format: "contents CONTAINS[c] %@", t) // C는 대소문자 안가린다는거임
        }
        
        do {
            let resultset = try self.context.fetch(fetchRequest)
            
            for record in resultset {
                let data = MemoData()
                data.title = record.title
                data.contents = record.contents
                data.redate = record.regdate! as Date
                data.objectID = record.objectID
                
                if let image = record.image as Data? { //바이너리 데이터를 데이터로 형변환해서 UImage(data:) 에 넣어준다.!
                    data.image = UIImage(data: image)
                }
                
                memoList.append(data)
            }
        } catch let e as NSError {
            NSLog(e.localizedDescription)
        }
        
        return memoList
    }
    
    func insert(_ data: MemoData) {
        // 관리 객체 인스턴스 생성
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: self.context) as! MemoMO
        
        object.title = data.title
        object.contents = data.contents
        object.regdate = data.redate
        
        if let image = data.image {
            object.image = image.pngData()!
        }
        
        //영구 저장소에 변경 사항을 반영한다.
        do {
            try self.context.save()
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    func delete(_ objectID: NSManagedObjectID) -> Bool {
        //삭제할 객체를 찾아 컨텍스트에서 삭제한다.
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        
        do {
            try self.context.save()
            return true
        } catch let e as NSError {
            NSLog(e.localizedDescription)
            return false
        }
    }
}
