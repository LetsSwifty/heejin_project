//
//  Utils.swift
//  MyMemory
//
//  Created by 김희진 on 2022/10/03.
//

import Foundation

extension UIViewController {
    var tutorialSB: UIStoryboard {
        return UIStoryboard(name: "Tutorial", bundle: Bundle.main)
    }
    
    func instanceTutorialVC(name: String) ->  UIViewController? {
        return self.tutorialSB.instantiateViewController(withIdentifier: name)
    }
}
