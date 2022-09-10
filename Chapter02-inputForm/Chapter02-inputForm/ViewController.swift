//
//  ViewController.swift
//  Chapter02-inputForm
//
//  Created by 김희진 on 2022/08/14.
//

import UIKit

class ViewController: UIViewController {
    
    var paramEmail: UITextField!
    var paramUpdate: UISwitch!
    var paramInterval: UIStepper!
    var txtUpdate: UILabel!
    var txtInterval: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "설정"
        
        let lblEmail = UILabel()
        lblEmail.frame = CGRect(x: 30, y: 100, width: 100, height: 30)
        lblEmail.text = "이메일"
        //커스텀 폰트 사용법 >  let font = UIFont(name: "Times New Roman", size:14)
        lblEmail.font = UIFont.systemFont(ofSize: 14) //.boldSystemFont 써도댐
        self.view.addSubview(lblEmail)

        let lblUpdate = UILabel()
        lblUpdate.frame = CGRect(x: 30, y: 150, width: 100, height: 30)
        lblUpdate.text = "자동갱신"
        lblUpdate.font = UIFont.systemFont(ofSize: 14) //.boldSystemFont 써도댐
        self.view.addSubview(lblUpdate)
        
        let lblInterval = UILabel()
        lblInterval.frame = CGRect(x: 30, y: 200, width: 100, height: 30)
        lblInterval.text = "갱신주기"
        lblInterval.font = UIFont.systemFont(ofSize: 14) //.boldSystemFont 써도댐
        self.view.addSubview(lblInterval)


        self.paramEmail = UITextField()
        self.paramEmail.frame = CGRect(x: 120, y: 100, width: 220, height: 30)
        self.paramEmail.font = UIFont.systemFont(ofSize: 13)
        self.paramEmail.borderStyle = .roundedRect // .line, .bezel, .roundedRect, .none
        self.paramEmail.textAlignment = .left
        self.paramEmail.adjustsFontSizeToFitWidth = true // 입력된 문자열의 폰트 사이즈를 텍스트 필들의 너비에 맞게 자동으로 조절해준다!
        self.paramEmail.placeholder = "이메일을 입력하세오"
        self.paramEmail.autocapitalizationType = .none //입력된 내용의 첫번째 글자를 대문자로 바꾸는걸 해제
        self.view.addSubview(self.paramEmail)
        
        
        self.paramUpdate = UISwitch()
        self.paramUpdate.frame = CGRect(x: 120, y: 150, width: 50, height: 30)
        self.paramUpdate.setOn(true, animated: true)
        self.paramUpdate.addTarget(self, action: #selector(presentUpdateValue), for: .valueChanged) // 발생 이벤트는 valueChanged이다!!!
        self.view.addSubview(self.paramUpdate)
        
        
        self.paramInterval = UIStepper()
        self.paramInterval.frame = CGRect(x: 120, y: 200, width: 50, height: 30)
        // stepper가 가지는 최소 최대값
        self.paramInterval.minimumValue = 0
        self.paramInterval.maximumValue = 100
        self.paramInterval.stepValue = 1
        self.paramInterval.value = 0
        self.paramInterval.addTarget(self, action: #selector(presentIntervalValue), for: .valueChanged)
        self.view.addSubview(self.paramInterval)

        
        
        self.txtUpdate = UILabel()
        self.txtUpdate.frame = CGRect(x: 250, y: 150, width: 100, height: 30)
        self.txtUpdate.font = UIFont.systemFont(ofSize: 12)
        self.txtUpdate.textColor = .red
        self.txtUpdate.text = "갱신함"
        self.view.addSubview(self.txtUpdate)

        
        self.txtInterval = UILabel()
        self.txtInterval.frame = CGRect(x: 250, y: 200, width: 100, height: 30)
        self.txtInterval.font = UIFont.systemFont(ofSize: 12)
        self.txtInterval.textColor = .red
        self.txtInterval.text = "0분마다"
        self.view.addSubview(self.txtInterval)

        
        // barButtonSystemItem 는 UIBarButtonSystemItem버튼 타입이다. 버튼의 타입이 .compose로 지정해 주었기 때문에 타이틀을 입력할 필요가 없다.
        let submitBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(submit))
        self.navigationItem.rightBarButtonItem = submitBtn

        
        /// 이 코드를 통해 지원하는 폰트의 종류를 알아볼 수 있다.
        /*
        let fonts = UIFont.familyNames
        for f in fonts {
            print("\(f)")
        }
         */        
    }
    
    @objc func submit(_ sender: Any) {
        let rvc = ReadViewController()
        rvc.pEmail = self.paramEmail.text
        rvc.pUpdate = self.paramUpdate.isOn
        rvc.pInterval = self.paramInterval.value
        
        self.navigationController?.pushViewController(rvc, animated: true)
    }
    
    
    func UIColorFromRGB(rgbValue: Int) -> UIColor {
        // 사용법> let color = UIColorFromRGB(rgbValue: 0xDFDFDF)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
    @objc func presentUpdateValue(_ sender: UISwitch) {
        self.txtUpdate.text = (sender.isOn == true ? "갱신함" : "갱신하지 않음")
    }
    
    @objc func presentIntervalValue(_ sender: UIStepper) { //value 는 실수이기 때문에 정수로 바꿔줘야함
        self.txtInterval.text = "\(Int(sender.value))분마다"
    }


}

