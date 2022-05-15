//
//  ViewController.swift
//  SceneCustomSegue
//
//  Created by 김희진 on 2022/04/17.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("\(segue.identifier)세그웨이가 곧 실행됩니다")
    }

}

