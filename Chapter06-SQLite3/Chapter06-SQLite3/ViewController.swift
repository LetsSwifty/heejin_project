//
//  ViewController.swift
//  Chapter06-SQLite3
//
//  Created by 김희진 on 2022/10/05.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        let dbPath = getDBPath()
        dbExcute(dbPath: dbPath)
    }
    
    func getDBPath() -> String {
        // 앱 내 문서디렉터리 경로에서 SQLiteDB 파일을 찾는다.
        let fileMgr = FileManager()
        // 파일매니저 객체를 이용하여 앱 내의 문서 디렉터리 경로를 찾고, 이를 URL 객체로 생성해 리턴한다.
        // documentDirectory 는 찾고자 하는 디렉토리 정보를 의미하고, userDomainMask 는 앱 내부 범위를 의미한다.
        // 문서 디렉터리의 경우, 무조건 첫번째 값이므로, 예제에서 사용한것처럼 .first를 이용해도 된다.
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
        // URL 객체에 db.sqlite 파일 경로를 추가한 SQLite3 데이터베이스 경로를 만들어 낸다
        // strings(byAppendingPath:) 메소드에 대한 싱글 인자값 버전이다.
        let dbPath = docPathURL.appendingPathComponent("db.sqlite").path
        //let dbPath = "/Users/heejin_dev/db.sqlite"
        
        /*
         위 코드는
         let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
         let dbPath = path.strings(byAppendingPaths: ["db.sqlite"])[0]
         와 동일하다.
         FileManager객체는 NSSearchPathForDirectoriesInDomains 객체와 동일하지만 최근에는 파일매니저를 더 많이 이용한다.
         */
        
        //dbPath 경로에 파일이 없다면 앱 번들에 복붙해논 db.sqlite를 가져와 dbPath에 복사한다. 번들 > 내부 파일 스토리지
        //dbPath 경로에 파일이 없는 경우는 처음 접속해서 open() 함수가 한번도 호출 안되었다는것이다(최초 접속). open()실행하면 데이터베이스 파일이 없을 경우 새로 생성된다
        //이때 기본적인 테이블 구조가 만들어져있는 번들에 db.sqlite 템플릿을 복사해서 쓰면 바로 테이블을 사용할 수 있다. 이후로는 자유로운 CRUD를 하면 된다
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        return dbPath
    }
    
    
    func dbExcute(dbPath: String) {
        var db: OpaquePointer? = nil //SQLite 연결 정보를 담을 객체

        //DB 연결. db객체가 생성된다. &db 는 db 객체를 담을 변수이다. db = sqlite3_open(dbPath) 와 비슷한 의미. 그게 포인터일뿐!
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else { // libsqlite3 라이브러리에 정의된 함수들은 정상적으로 실행되었을떄 공통적으로 SQLITE_OK 를 리턴한다.
            print("database connet fail")
            return
        }
        
        // 데이터베이스 연결 종료
        // return 직전에 수행된다!
        // 그리고 return 보다 위엣 줄에 있던 defer 구문만 실행된다. 아래에 있으면 실행안됨
        // defer구문은 함수의 종료 직전에 실행되기 때문에 종료 시점에 맞추어 처리해야할 구문이 있다면 defer구문에 넣으면 된다. 위치는 상관 없다! 근데 defer이 여러개일 경우 마지막에 작성된 것부터 실행된다. 중첩될 경우에는 가장 바깥쪽 defer부터 실행된다.
        defer {
            print("Close Database connection")
            sqlite3_close(db) // db객체 연결이 해제된다.
        }
        
        var stmt: OpaquePointer? = nil //컴파일된 sql을 담을 객체
        let sql = "CREATE TABLE IF NOT EXISTS sequence (num INTEGER)" // sequeunce라는 이름의 테이블을 만들어라. 칼럼은 Integer타입의 num으로 해라.
        // sql 구문 전달 준비. db경로(db) 와 sql구문(sql) 데이터로 컴파일된 sql 구문인 stmt가 생성된다.
        guard sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            print("Parepare statement Fail")
            return
        }
        
        // smtp 연결해제
        defer {
            print("Finalize Statement")
            sqlite3_finalize(stmt) //sql 구문객체를 삭제해서 stmt가 해제된다.
        }

        
        if sqlite3_step(stmt) == SQLITE_DONE { //sql 호출. 얘는 성공하면 SQLITE_DONE를 반환한다.
            print("Create Table Success")
        }

        
//기존코드
//        if sqlite3_open(dbPath, &db) == SQLITE_OK { // libsqlite3 라이브러리에 정의된 함수들은 정상적으로 실행되었을떄 공통적으로 SQLITE_OK 를 리턴한다.
//            // sql 구문 전달 준비. db경로(db) 와 sql구문(sql) 데이터로 컴파일된 sql 구문인 stmt가 생성된다.
//            if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK {
//                print("sql compile Success")
//                if sqlite3_step(stmt) == SQLITE_DONE { //sql 호출. 얘는 성공하면 SQLITE_DONE를 반환한다.
//                    print("Create Table Success")
//                }
//                sqlite3_finalize(stmt) //sql 구문객체를 삭제해서 stmt가 해제된다.
//            } else {
//                print("Parepare statemernt Fail")
//            }
//
//            sqlite3_close(db) // db객체 연결이 해제된다.
//
//        } else {
//            print("database connet fail")
//            return
//        }
    }
}

