//
//  ViewController.swift
//  Chapter03-CSStepper
//
//  Created by 김희진 on 2022/09/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stepper = CSStepper()
        stepper.frame = CGRect(x: 30, y: 100, width: 130, height: 30)
        stepper.addTarget(self, action: #selector(logging), for: .valueChanged)
        self.view.addSubview(stepper)
    }
    
    @objc func logging(_ sender: CSStepper) {
        print(sender.value)
    }
}

