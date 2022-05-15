//
//  ViewController.swift
//  IBTest
//
//  Created by 김희진 on 2022/04/17.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label01: UILabel!
    
    @IBOutlet var label02: UILabel!
    
    @IBOutlet var label03: UILabel!
    
    @IBOutlet var label04: UILabel!
    
    @IBOutlet var label05: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func button01(_ sender: Any) {
        label01.text = "button01 clicked"
    }
    
    @IBAction func button02(_ sender: Any) {
        label02.text = "button02 clicked"
    }
    
    @IBAction func button03(_ sender: Any) {
        label03.text = "button03 clicked"
    }
    
    @IBAction func button04(_ sender: Any) {
        label04.text = "button04 clicked"
     }
    
    @IBAction func button05(_ sender: Any) {
        label05.text = "button05 clicked"
    }
    
}

