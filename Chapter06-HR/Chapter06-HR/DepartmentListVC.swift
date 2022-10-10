//
//  DepartmentListVC.swift
//  Chapter06-HR
//
//  Created by 김희진 on 2022/10/10.
//

import UIKit

class DepartmentListVC: UITableViewController {
    
    var departList: [(departCd: Int, departTitle: String, departAddr: String)]! // 데이터 소스용 멤버변수
    let departDAO = DepartmentDAO() // SQLite 처리를 담당할 DAO 객체

    override func viewDidLoad() {
        super.viewDidLoad()
        
        departList = departDAO.find() // 기존 저장된 부서 정보를 가져온다.
        initUI()
    }

    func initUI() {
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 14)
        navTitle.text = "부서 목록 \n" + "총 \(self.departList.count) 개"
        
        self.navigationItem.titleView = navTitle
        self.navigationItem.leftBarButtonItem = self.editButtonItem // 편집 버튼 추가
        // 편집 버튼의 action에 self.tableView.setEditing(true, animated:true) 이 애플에 구현되어있어서 버튼을 탭하기만 하면 편집모드로 들어갈 수 있다. //self.isEditing = true 도 동릴한데 애니메이션 없음!
        
        // 해당 셀을 스와이프했을 떄 편집 모드가 되도록 설정. 위에는 테이블 뷰 전체를 편집모드로 바꾸는거고, 이건 해당 셀만 편집 모드로 전환되도록 하는 코드임! tableView(commit: 이랑 동일!
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "신규 부서 등록", message: "신규 부서를 등록해 주세요", preferredStyle: .alert)
        
        alert.addTextField() { tf in tf.placeholder = "부서명" }
        alert.addTextField() { tf in tf.placeholder = "주소" }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) {_ in
            
            let title = alert.textFields?[0].text
            let addr = alert.textFields?[1].text
            
            // 신규 부서 테이블을 생성하고, DB에서 전체 부서목록(테이블 목록)을 읽어와 갱신해준다.
            if self.departDAO.create(title: title!, addr: addr!) {
                self.departList = self.departDAO.find()
                self.tableView.reloadData()
            }
            
            let navTitle = self.navigationItem.titleView as! UILabel
            navTitle.text = "부서 목록 \n" + "총 \(self.departList.count) 개"
        })
        
        self.present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = departList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
        cell?.textLabel?.text = rowData.departTitle
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.detailTextLabel?.text = rowData.departAddr
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // 편집모드에서 DELETE 버튼을 클릭했을때, 스와이프 되면서 사라질때 호출되는 메소드. 앞에서 살펴봤던 편집 관련 속성을 설정하거나 메소드를 호출하지 않고 이 메소드를 추가하는 것만으로 사용자가 셀을 스와이프 했을 때 delete 버튼이 나타난다.(근데 네비게이션에 delete 타입의 바 아이템을 추가는 해줘야함! 바 아이템 탭 시 자동으로 이 메소드가 실행되는거지 버튼 자체가 생기는건 아니니까) 메소드 안에는 DELETE
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .insert {
            // 데이터 등록을 위한 팝업창을 띄워주던가 함
        } else if editingStyle == .delete {
            // 삭제할 row의 데이터 소스를 구한다.
            let departCd = self.departList[indexPath.row].departCd
            
            // 그 데이터 소스를 sqlite에서 지우고
            if departDAO.remove(departCd: departCd) {
                // 성공한다면 테이블 뷰를 그리는 데이터 소스에서도 지우고
                self.departList.remove(at: indexPath.row)
                // 테이블 뷰에서도 지운다.
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let departCd = departList[indexPath.row].departCd
        
        let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "DEPART_INFO")
        if let _infoVC = infoVC as? DepartmentInfoVC {
            _infoVC.departCd = departCd
            self.navigationController?.pushViewController(_infoVC, animated: true)
        }
    }
}
