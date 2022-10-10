//
//  DepartmentDAO.swift
//  Chapter06-HR
//
//  Created by 김희진 on 2022/10/10.
//

import Foundation

class DepartmentDAO {
    
    // 부서 정보를 담을 튜플 타입 정의(부서코드, 부서명, 부서주소)
    typealias DepartRecord = (Int, String, String)
    
    //sqlite연결 및 초기화
    lazy var fmdb: FMDatabase! = {
        let fileMgr = FileManager.default
        
        //샌드박스 내 문서 디렉토리에서 데이터베이스 파일 경로를 확인
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appendingPathComponent("hr.sqlite").path
        
        //샌드박스 경로에 파일이 없다면 메인 번들에 만들어 둔 hr.sqlite를 가져와 복사
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        //준비된 데이터베이스 파일으 바탕으로 FMDatabase객체를 생성
        let db = FMDatabase(path: dbPath)
        return db
    }()

    //FMDatabase객체에서 SQLite연결은 open(), 연결 종료는 close() 메소드를 통해 처리된다. 모든 sql문의 실행은 이 사이에서 일어나야한다. 그래서 생성자와 소멸자 사이에 이 두 메소드를 넣으면 깔끔하다!
    init() {
        self.fmdb.open()
    }
    
    deinit {
        self.fmdb.close()
    }
    
    func find() -> [DepartRecord] {
        var departLsit = [DepartRecord]()
        
        do {
            let sql = """
                SELECT depart_cd, depart_title, depart_addr
                FROM department
                ORDER BY depart_cd ASC
                """
            let rs = try self.fmdb.executeQuery(sql, values: nil) //executeQuery 를 통해 쿼리 결과가 rs 로 리턴된다.
            
            while rs.next() { // next()를 이용해 리턴된 데이터를 하나씩 for문으로 돌림
                let departCd = rs.int(forColumn: "depart_cd")
                let departTitle = rs.string(forColumn: "depart_title")
                let departAddr = rs.string(forColumn: "depart_addr")
                
                departLsit.append(DepartRecord(Int(departCd), departTitle!, departAddr!)) //rs.int(forColumn:) 으로 넣는 값은 사실 Int 가 아니라 Int32임. 그래서 Int() 로 재변환 해줘야함
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return departLsit
    }
    
    func get(departCd: Int) -> DepartRecord? {
        let sql = """
            SELECT depart_cd, depart_title, depart_addr
            FROM department
            WHERE depart_cd = ?
            """
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [departCd])
        
        if let _rs = rs { // 결과 집합은 옵셔널 타입이기 때문에 일반 상수에 바인딩해서 해제해야한다. 그리고 이때 리턴되는 집합의 길이는 1임
            _rs.next()
            
            let departCd = _rs.int(forColumn: "depart_cd")
            let departTitle = _rs.string(forColumn: "depart_title")
            let departAddr = _rs.string(forColumn: "depart_addr")
            
            return DepartRecord(Int(departCd), departTitle!, departAddr!)
        } else { // 결과 집합이 없을경우 nil을 리턴한다.
            return nil
        }
    }
    
    func create(title: String!, addr: String!) -> Bool {
        do {
            let sql = """
            INSERT INTO department(depart_title, depart_addr)
            VALUES (?, ?)
            """
            
            guard title != nil && title?.isEmpty == false else {
                return false
            }
            guard addr != nil && addr?.isEmpty == false else {
                return false
            }

            
            try self.fmdb.executeUpdate(sql, values: [title!, addr!]) //데이터베이스 내용을 업데이트 하는 구문이므로 excuteQuery 대신 excuteUpdate계열의 메소드가 사용되었다.
            return true
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
    }
    
    func remove(departCd: Int) -> Bool {
        do {
            let sql = "DELETE FROM department WHERE depart_cd = ?"
           
            try self.fmdb.executeUpdate(sql, values: [departCd])
            return true
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
    }
}
