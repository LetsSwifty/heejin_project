//
//  ViewController.swift
//  Chapter02-Button
//
//  Created by 김희진 on 2022/08/14.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 50, y: 100, width: 150, height: 30)
        btn.setTitle("테스트 버튼", for: .normal)
        btn.center = CGPoint(x: self.view.frame.size.width / 2, y: 100) // 버튼을 수평중앙 정렬한다.
        btn.addTarget(self, action: #selector(btnOnClick), for: .touchUpInside)
        
        self.view.addSubview(btn)
    }
    
    @objc func btnOnClick(_ sender: Any) { // 호출한 객체의 정보를 인자값으로 전달하기 위해 Any, AnyObject, 혹은 호출한 객체의 타입(UIButton)으로 선언되어야 한다.
        if let button = sender as? UIButton { // sender 가 애초에 UIButton 타입이였으면 타입 캐스팅이 필요 없다.
            button.setTitle("클릭되었습니다", for: .normal)
        }
    }
}



class testClass: UIViewController {
    
    var testSubject = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.testSubject.addSubview(testSubject)
    }
}
