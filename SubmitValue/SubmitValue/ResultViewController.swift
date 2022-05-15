//
//  ResultViewController.swift
//  SubmitValue
//
//  Created by 김희진 on 2022/04/21.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var isUpdate: UISwitch!
    
    @IBOutlet var interval: UIStepper!
    
    @IBAction func onSubmit(_ sender: Any) {
        
        let ud = UserDefaults.standard
        ud.set(self.email.text, forKey: "email")
        ud.set(self.isUpdate.isOn, forKey: "isUpdate")
        ud.set(self.interval.value, forKey: "interval")

        
        // presentingViewController 속성을 통해 이전 화면 객체를 읽어온 다음, 뷰 컨트롤러로 캐스팅한다.
//        let preVC = self.presentingViewController
//        guard let vc = preVC as? ViewController else {return}
//        vc.paramEamil = self.email.text
//        vc.paramUpdate = self.isUpdate.isOn
//        vc.paramInterval = self.interval.value



//        let ad = UIApplication.shared.delegate as? AppDelegate
//        ad?.paramEamil = self.email.text
//        ad?.paramUpdate = self.isUpdate.isOn
//        ad?.paramInterval = self.interval.value
                
        self.presentingViewController?.dismiss(animated: true)
    }
}
