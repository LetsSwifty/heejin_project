//
//  ViewController.swift
//  ScenceTrans02
//
//  Created by 김희진 on 2022/04/17.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func moveByNavi(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") else {return}
        
        self.navigationController?.pushViewController(uvc, animated: true)
    }
    
    
    @IBAction func movePresent(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") else {return}
        
        self.present(uvc, animated: true)
    }
    
}

