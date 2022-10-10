//
//  EmployeeDAO.swift
//  Chapter06-HR
//
//  Created by 김희진 on 2022/10/10.
//

import Foundation

enum EmpStateType: Int {
    case ING = 0, STOP, OUT //순서대로 0 - 재직중, 1 - 휴직, 2 - 퇴사
    
    func desc() -> String {
        switch self {
        case .ING:
            return "재직중"
        case .STOP:
            return "휴직"
        case .OUT:
            return "퇴사"
        }
    }
}

struct EmployeeVO { // 이 스트럭은 employee 테이블에 대응되지만, department테이블과 조인 관계에 있으므로 department 와 논리적으로 칼럼을 공유해야한다.
    var empCd = 0
    var empName = ""
    var joinDate = ""
    var stateCd = EmpStateType.ING
    var departCd = 0
    var departTitle = ""
}

class EmployeeDAO {

    lazy var fmdb: FMDatabase! = {
        let fileMgr =  FileManager.default
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appendingPathComponent("hr.sqlite").path
        
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        // 준비된 데이터베이스 파일을 바탕으로 FMDataBase 객체를 생성한다.
        let db = FMDatabase(path: dbPath)
        return db
    }()
    
    init() {
        self.fmdb.open()
    }

    deinit {
        self.fmdb.close()
    }
    
    func find(departCd: Int = 0) -> [EmployeeVO] {
        var employeeList = [EmployeeVO]()
        
        do {
            
            let condition = departCd == 0 ? "" : "WHERE Employee.depart_cd = \(departCd)"
            
            let sql = """
                      SELECT emp_cd, emp_name, join_date, state_cd,
                      department.depart_title
                      From employee
                      JOIN department On department.depart_cd = employee.depart_cd
                      \(condition)
                      ORDER BY employee.depart_cd ASC
                      """
            let rx = try self.fmdb.executeQuery(sql, values: nil)
            
            while rx.next() {
                var record = EmployeeVO()
                
                record.empCd = Int(rx.int(forColumn: "emp_cd"))
                record.empName = rx.string(forColumn: "emp_name")!
                record.joinDate = rx.string(forColumn: "join_date")!
                record.departTitle = rx.string(forColumn: "depart_title")!
                record.stateCd = EmpStateType(rawValue: Int(rx.int(forColumn: "state_cd")))!
                
                employeeList.append(record)
            }
            
        } catch let err as NSError {
            print(err.localizedDescription)
        }
        
        return employeeList
    }
    
    func get(empCd: Int) -> EmployeeVO? {
        do {
            let sql = """
                      SELECT emp_cd, emp_name, join_date, state_cd,
                      department.depart_title
                      From employee
                      JOIN department On department.depart_cd = employee.depart_cd
                      WHERE emp_cd = ?
                      """
            
            let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [empCd])
            
            if let _rs = rs { // 결과 집합이 옵셔널 타입이여서 바인딩 변수를 통해 옵셔널 해제한다.
                _rs.next()
                
                var record = EmployeeVO()
                
                record.empCd = Int(_rs.int(forColumn: "emp_cd"))
                record.empName = _rs.string(forColumn: "emp_name")!
                record.joinDate = _rs.string(forColumn: "join_date")!
                record.departTitle = _rs.string(forColumn: "depart_title")!
                record.stateCd = EmpStateType(rawValue: Int(_rs.int(forColumn: "state_cd")))!
                
                return record
            } else { // 결과 집합이 없을 경우 nil을 반환한다.
                return nil
            }
        }
    }
    
    func create(param: EmployeeVO) -> Bool {
        do {
            let sql = """
                      INSERT INTO employee (emp_name, join_date, state_cd, depart_cd)
                      VALUES ( ?, ?, ?, ?)
                      """
            var params = [Any]()
            params.append(param.empName)
            params.append(param.joinDate)
            params.append(param.stateCd.rawValue)
            params.append(param.departCd)
            
            try self.fmdb.executeUpdate(sql, values: params)
            return true
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
    }
    
    func remove(empCd: Int) -> Bool {
        do {
            let sql = "DELETR FROM employee WHERE emp_cd = ?"
            try self.fmdb.executeUpdate(sql, values: [empCd])
            return true
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
    }

    
    func editState(empCd: Int, stateCd: EmpStateType) -> Bool {
        do {
            let sql = "UPDATE employee SET state_cd = ? WHERE emp_cd = ?"
            
            var params = [Any]()
            params.append(stateCd.rawValue)
            params.append(empCd)
            
            try self.fmdb.executeUpdate(sql, values: params)
            return true
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
    }
}
