//
//  SecondViewController.swift
//  ScenceTrans02
//
//  Created by 김희진 on 2022/04/17.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func back(_ sender: Any) {
        if (navigationController?.isBeingPresented) != nil {
            navigationController?.popViewController(animated: true)
        }else{
            dismiss(animated: true)
        }
    }

}
