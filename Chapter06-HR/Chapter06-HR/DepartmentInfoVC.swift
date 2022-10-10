//
//  DepartmentInfoVC.swift
//  Chapter06-HR
//
//  Created by 김희진 on 2022/10/10.
//

import UIKit

class DepartmentInfoVC: UITableViewController {
    
    typealias DepartRecord = (departCd: Int, departTitle: String, departAddr: String)
    
    var departCd: Int! // 부서 목록으로부터 넘겨받을 부서 코드
    
    let departDAO = DepartmentDAO()
    let empDAO = EmployeeDAO()
    var departInfo: DepartRecord!
    var empList: [EmployeeVO]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        departInfo = departDAO.get(departCd: departCd)
        empList = empDAO.find(departCd: departCd)
        
        self.navigationItem.title = "\(departInfo.departTitle)"
    }
    
    @objc func changeState(_ sender: UISegmentedControl) {

        let empCd = sender.tag
        let stateCd = EmpStateType(rawValue: sender.selectedSegmentIndex)
        
        if self.empDAO.editState(empCd: empCd, stateCd: stateCd!) {
            let alert = UIAlertController(title: nil, message: "재직 상태가 변경되었습니다", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated: true)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 이렇게 디테일한 설정 필요 없으면 viewForHeaderInSection 이 아니라 titleForHeaderInSection 써도 됨
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let textHeader = UILabel(frame: CGRect(x: 35, y: 5, width: 200, height: 30))
        textHeader.font = .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 2.5))
        textHeader.textColor = UIColor(red: 0.03, green: 0.28, blue: 00.71, alpha: 1.0)
        
        let icon = UIImageView()
        icon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        
        if section == 0 {
            textHeader.text = "부서 정보"
            icon.image = UIImage(imageLiteralResourceName: "depart")
        } else {
            textHeader.text = "부서 정보"
            icon.image = UIImage(imageLiteralResourceName: "employee")
        }
        
        // 레이블과 이미지뷰를 담을 컨테이너뷰. 이게 리턴된다.
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        v.backgroundColor = .black
        v.addSubview(textHeader)
        v.addSubview(icon)
        return v
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return empList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // 부서 정보 영역

            let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
            cell?.textLabel?.font = .systemFont(ofSize: 13)
            cell?.detailTextLabel?.font = .systemFont(ofSize: 12)
            
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "부서 코드"
                cell?.detailTextLabel?.text = "\(departInfo.departCd)"
            case 1:
                cell?.textLabel?.text = "부서명"
                cell?.detailTextLabel?.text = departInfo.departTitle
            case 2:
                cell?.textLabel?.text = "부서 주소"
                cell?.detailTextLabel?.text = departInfo.departAddr
            default:
                ()
            }
            return cell!
        } else { // 사원리스트 영역
            
            let row = empList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL")
            cell?.textLabel?.text = "\(row.empName) (입사일:\(row.joinDate))"
            cell?.detailTextLabel?.font = .systemFont(ofSize: 12)
            
            let state = UISegmentedControl(items: ["재직중", "휴직", "퇴사"])
            
            state.tag = row.empCd
            state.addTarget(self, action: #selector(self.changeState(_:)), for: .valueChanged)
            
            // 크기가 지정되지 않을 경우 세그먼트 컨트롤은 콘텐츠에 맞추어 스스로의 크기를 조절한다.
            state.frame.origin.x = self.view.frame.width - state.frame.width - 10
            state.frame.origin.y = 10
            state.selectedSegmentIndex = row.stateCd.rawValue
            
            cell?.contentView.addSubview(state)
            return cell!
        }
    }
    
}
