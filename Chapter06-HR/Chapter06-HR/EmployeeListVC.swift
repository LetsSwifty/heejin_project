//
//  EmployeeListVC.swift
//  Chapter06-HR
//
//  Created by 김희진 on 2022/10/10.
//

import UIKit

class EmployeeListVC: UITableViewController {

    var empList: [EmployeeVO]!
    var empDAO = EmployeeDAO()
    
    var loadingImg: UIImageView!
    var bgCircle: UIView! // 댕김 임계점에 도달했을 때 나타날 배경 뷰. 노란 원!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        empList = self.empDAO.find()
        initUI()
        
        
        self.refreshControl = UIRefreshControl()
//        self.refreshControl?.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        self.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        self.loadingImg = UIImageView(image: UIImage(named: "refresh"))
        self.loadingImg.center.x = (self.refreshControl?.frame.width)! / 2 // 가로 중심에 위치하도록 함
        
        // tintColor를 투명한걸로 설정해서 안보이게 하고, 이미지 뷰를 추가한다.
        self.refreshControl?.tintColor = .clear
        self.refreshControl?.addSubview(self.loadingImg)
        
        // 임계점 뷰
        self.bgCircle = UIView()
        self.bgCircle.backgroundColor = .yellow
        self.bgCircle.center.x = (self.refreshControl?.frame.width)! / 2
        
        self.refreshControl?.addSubview(self.bgCircle)
        self.refreshControl?.bringSubviewToFront(self.loadingImg)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) { // 스크롤이 발생할 때다마 작동
        // 테이블뷰가 댕겨지면 refreshControl 객체의 좌표값 변화를 이용하여 스크롤에 의해 당겨진 거리를 계산한다. 이 구문은 통째로 외우는게 좋음!
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)
        self.loadingImg.center.y = distance / 2 // 새로고침 컨트롤의 높이는 당긴 거리와 같다. 스크롤 시작전에 0 이였다가 스크롤되는 만큼 늘어나기 때문이다. 이 값을 2로 나누면 center.y 좌표 위치를 구할 수 있다.
        
        // 당긴 거리를 회전 각도로 반환하여 로딩 이미지에 설정한다. 회전비는 1/20
        let ts = CGAffineTransform(rotationAngle: CGFloat(distance / 20))
        self.loadingImg.transform = ts
        
        // 스크롤되는 동안 노란배경 뷰가 새로고침 컨트롤 영역의 중심에 계속 표시되도록 중심좌표 설정
        self.bgCircle.center.y = distance / 2
    }
    
    @objc func pullToRefresh() {
        //beginRefesh는 당긴 시점에 자동으로 호출된다.
        
        empList = empDAO.find()
        tableView.reloadData()
        
        self.refreshControl?.endRefreshing() // 종료는 꼭 해줘야 한다!
        
        
        //노란 원이 로딩 이미지를 중심으로 커지는 애니메이션을 구현한다. -> 노란 원이 새로고침 컨트롤 이미지 중심에서 자라나는 것처럼 연출하기 위해 애니메이션을 작성했다. 0.5초동안 커지게 처리
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)
        UIView.animate(withDuration: 0.5) {
            self.bgCircle.frame.size.width = 80
            self.bgCircle.frame.size.height = 80
            
            // 애니메이션이 진행되는 동안 bgCircle의 중심 좌표가 갱신된다. 아니면 한쪽으로만 커지게 된다
            self.bgCircle.center.x = (self.refreshControl?.frame.width)! / 2
            self.bgCircle.center.y = distance / 2
            self.bgCircle.layer.cornerRadius = (self.bgCircle?.frame.size.width)! / 2
        }
    }
    
    // 스크롤뷰의 드래그가 끝났을 때 호출되는 메소드
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 노란원을 다시 초기화 해준다
        self.bgCircle.frame.size.width = 0
        self.bgCircle.frame.size.height = 0
    }
    
    
    
    
    
    
    
    func initUI() {
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 14)
        navTitle.text = "사원 목록 \n" + "총 \(empList.count)명"
        
        self.navigationItem.titleView = navTitle
    }

    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "사원등록", message: "등록할 사원 정보를 입력해주세여", preferredStyle: .alert)
        alert.addTextField() { tf in tf.placeholder = "사원명" }
        
        let pickerVC = DepartPickerVC()
        alert.setValue(pickerVC, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            var param = EmployeeVO()
            param.departCd = pickerVC.selectedDepartCd
            param.empName = (alert.textFields?[0].text!)!
            
            // 사원 등록일은 오늘로, 재직상태는 재직중으로 한다.
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            param.joinDate = df.string(from: Date())
            param.stateCd = EmpStateType.ING
            
            // DB 처리
            if self.empDAO.create(param: param) {
                self.empList = self.empDAO.find()
                self.tableView.reloadData()
                
                if let navTitle = self.navigationItem.titleView as? UILabel {
                    navTitle.text = "사원목록 \n" + "총 \(self.empList.count) 명"
                }
            }
        })
        
        self.present(alert, animated: false)
    }
    
    @IBAction func edit(_ sender: Any) {
        if self.isEditing == false { // 편집 모드가 아닐때
            self.setEditing(true, animated: true)
            (sender as? UIBarButtonItem)?.title = "Done"
        } else {
            self.setEditing(false, animated: true)
            (sender as? UIBarButtonItem)?.title = "Edit"
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return empList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let rowData = empList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL")
        
        cell?.textLabel?.text = rowData.empName + "(\(rowData.stateCd.desc()))"
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        cell?.detailTextLabel?.text = rowData.departTitle
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
    
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 삭제할 행의 empCd를 구한다.
        let empCd = empList[indexPath.row].empCd

        // DB에서 데이터 삭제
        if empDAO.remove(empCd: empCd) {
            // 데이터 소스에서 데이터 삭제
            self.empList.remove(at: indexPath.row)
            // 테이블 뷰에서 데이터 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
