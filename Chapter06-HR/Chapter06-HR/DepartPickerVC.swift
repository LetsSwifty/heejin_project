//
//  DepartPickerVC.swift
//  Chapter06-HR
//
//  Created by 김희진 on 2022/10/10.
//

import UIKit

class DepartPickerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let departDAo = DepartmentDAO()
    var departList: [(departCd: Int, departTitle: String, departAddr: String)]!
    var pickerView: UIPickerView!

    // 현재 피커뷰에 선택되어있는 부서의 코드를 가져온다
    var selectedDepartCd: Int {
        let row = self.pickerView.selectedRow(inComponent: 0)
        return self.departList[row].departCd
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        departList = departDAo.find()
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        pickerView.dataSource = self
        pickerView.delegate = self
        view.addSubview(pickerView)
        
        let pwidth = pickerView.frame.width
        let pHeight = pickerView.frame.height
        self.preferredContentSize = CGSize(width: pwidth, height: pHeight)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return departList.count
    }
    
    // 이전에 피커 뷰 실습에는 viewForRow 가 아닌 titleForRow를 사용했다. 근데 그 메소드는 문자열의 커스텀이 불가능하고 텍스트 크기도 수정할 수 없기 때문에 요걸로 해준다.
    // 그리고 이 메소드는 뷰에 라벨뿐만 아니라 이미지 등등을 리턴할 수도 있고, 재사용view 도 지원한다!
    // 인자로 전달되는 view 매개변수는 피커뷰의 이전 행에서 사용되다가 현재는 스크롤에 의해 그려지면서 캐시된 객체임
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var titleView = view as? UILabel // 타입캐스팅이 실패하면 nil 이다. 이렇게 만들어서 뷰를 라벨로바꿈!

        if titleView == nil {
            titleView = UILabel()
            titleView?.font = UIFont.systemFont(ofSize: 14)
            titleView?.textAlignment = .center
        }
        
        titleView?.text = "\(departList[row].departTitle)(\(departList[row].departAddr))"
        return titleView!
    }
    
}
