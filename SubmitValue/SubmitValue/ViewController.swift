//
//  ViewController.swift
//  SubmitValue
//
//  Created by 김희진 on 2022/04/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var resultEmail: UILabel!
    
    @IBOutlet var resultUpdate: UILabel!
    
    @IBOutlet var resultInterval: UILabel!
    
//    var paramEamil: String?
//    var paramUpdate: Bool?
//    var paramInterval: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {

        let ud = UserDefaults.standard

        if let paramEamil = ud.string(forKey: "email") {
            resultEmail.text =  paramEamil
        }

        let paramUpdate = ud.bool(forKey: "isUpdate")
        resultUpdate.text = paramUpdate == true ? "자동갱신" : "자동갱신안함"
    
        let paramInterval = ud.double(forKey: "interval")
        resultInterval.text = "\(Int(paramInterval))분 마다"
        
        
//        let ad = UIApplication.shared.delegate as? AppDelegate
//        if let paramEamil = ad?.paramEamil {
//            resultEmail.text =  paramEamil
//        }
//
//        if let paramUpdate = ad?.paramUpdate {
//            resultUpdate.text = paramUpdate == true ? "자동갱신" : "자동갱신안함"
//        }
//        if let paramInterval = ad?.paramInterval {
//            resultInterval.text = "\(Int(paramInterval))분 마다"
//        }

        
//        if let paramEamil = paramEamil {
//            resultEmail.text =  paramEamil
//        }
//
//        if let paramUpdate = paramUpdate {
//            resultUpdate.text = paramUpdate == true ? "자동갱신" : "자동갱신안함"
//        }
//        if let paramInterval = paramInterval {
//            resultInterval.text = "\(Int(paramInterval))분 마다"
//        }

    }
  
}

