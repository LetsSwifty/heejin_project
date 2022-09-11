//
//  ControllerViewController.swift
//  Chapter03-Alert
//
//  Created by 김희진 on 2022/09/10.
//

import UIKit

class ControllerViewController: UIViewController {

    let slider = UISlider()
    
    var sliderValue: Float {
        // 연산 프로퍼티 생성. 연산프로퍼티는 get, set 구문을 이용해서 값의 읽기/쓰기를 지원하지만 get만 이용해 읽기전용의 연산 프로퍼티를 생성할 수 있다. 이럴때는 남은게 get밖에 없으므로 get키워드도 생략하고 바로 리턴을 해주면 된다!
        // 연산 프로퍼티 안에 get/set 구문이 없다면 모두 get으로 간주하면 됨!
        return self.slider.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slider.minimumValue = 0
        self.slider.maximumValue = 100
        
        self.slider.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        self.view.addSubview(self.slider)
        self.preferredContentSize = CGSize(width: self.slider.frame.width, height: self.slider.frame.height + 10)
    }
}
