//
//  DataSync.swift
//  MyMemory
//
//  Created by 김희진 on 2022/10/16.
//

import Foundation
import CoreData
import Alamofire

// 서버와의 데이터 동기화를 담당할 클래스
class DataSync {
    // 코어 데이터의 컨텍스트 객체
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    func downloadBackUpData() {
        // 최초에 한번만 다운로드 받도록 체크. 로그인에 성공하면 유저디포트에 firstLogin 이라는 키로 값 저장
        let ud = UserDefaults.standard
        guard ud.value(forKey: "firstLogin") == nil else { return }
        
        //API 호출용 인증 헤더
        let tk = TokenUtils()
        let header = tk.getAuthorizationHeader()
        
        let url = "http://swiftapi.rubypaper.co.kr:2029/memo/search"
        let get = AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header)
        
        get.responseJSON { res in
            //응답 결과가 잘못되었거나 list 항목이 없을 경우에는 잘못된 응답이므로 그대로 종료한다.
            guard let jsonObject = try! res.result.get() as? NSDictionary else {return}
            guard let list = jsonObject["list"] as? NSArray else {return}
            
            //list 항목을 순회하면서 각각의 데이터를 코어 데이터로 저장한다.
            for item in list {
                guard let record = item as? NSDictionary else {return}
                
                // Memo 타입의 관리 객체 인스턴스를 생성해서 값을 각 속성에 맞게 대입한다.
                let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: self.context) as! MemoMO
                object.title = (record["title"] as! String)
                object.contents = (record["contents"] as! String)
                object.regdate = self.stringToDate(record["create_date"] as! String)
                object.sync = true
                
                // 이미지가 있을 경우에만 대입한다
                if let imagePath = record["image_path"] as? String {
                    let url = URL(string: imagePath)!
                    object.image = try! Data(contentsOf: url) //Data 타입으로 저장한다
                }
            }
            
            // 영구 저장소에 커밋한다
            do {
                try self.context.save()
            } catch let e as NSError {
                NSLog("error %s", e.localizedDescription)
            }
            
            // 다운로드가 끝났으므로 이후로는 실행되지 않도록 처리
            ud.setValue(true, forKey: "firstLogin")
        }
    }
    
    // Memo 엔티티에 저장된 모든 데이터 중에서 동기화 되지 않은것을 찾아 업로드한다.
    func uploadData(_ indicatorView: UIActivityIndicatorView? = nil) {
        
        let fetchRequest: NSFetchRequest<MemoMO> = MemoMO.fetchRequest() // 코어데이터 내장 메소드를 통해 요청 객체 생성

        // 최신 글 순으로 정렬
        let regDateDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [regDateDesc]
        //업로드가 되지 않은 데이터만 추출
        fetchRequest.predicate = NSPredicate(format: "sync == false")
        
        do {
            let resultset = try self.context.fetch(fetchRequest)
            
            // 읽어온 결과 집합을 순회하면서 MemoData 타입으로 변경
            for record in resultset {
                indicatorView?.startAnimating()
                print(record.title)
                self.uploadDatum(record) { // 서버에 업로드
                    if record === resultset.last { // 마지막 데이터의 업로드가 끝나면 로딩 표시 해제
                        indicatorView?.stopAnimating()
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // 인자값으로 입력된 개별 MemoMO 객체를 서버에 업로드한다
    func uploadDatum(_ item: MemoMO, complete: (() -> Void)? = nil) {
        let tk = TokenUtils()
        guard let header = tk.getAuthorizationHeader() else {
            print("로그인 상태가 아니므로 \(item.title)를 업로드할 수 없습니다")
            return
        }
        
        // 전송할 값 설정
        var param: Parameters = [
            "title": item.title!,
            "contents": item.contents!,
            "create_date": self.dateToString(item.regdate!)
        ]
        // 이미지가있을경우 이미지도 포함!
        if let imageData = item.image as Data? {
            param["image"] = imageData.base64EncodedString()
        }
        let url = "http://swiftapi.rubypaper.co.kr:2029/memo/save"
        let upload = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header)
        
        // sync를 true 로 바꿔서 영구 저장소에 반영
        upload.responseJSON { res in
            guard let jsonObject = try! res.result.get() as? NSDictionary else {
                print("잘못된 응답입니다ㅏ")
                return
            }
            
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode == 0 {
                print("\(item.title)가 등록되었습니다")
                
                //코어 데이터에 반영(true)
                do {
                    item.sync = true
                    try self.context.save()
                } catch let e as NSError {
                    self.context.rollback()
                    NSLog("error: \(e.localizedDescription)")
                }
                
            } else {
                print(jsonObject["error_msg"] as! String)
            }
            complete?()
        }
    }

}

extension DataSync {
    func stringToDate(_ value: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.date(from: value)!
    }
    
    func dateToString(_ value: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: value as Date)
    }
}
