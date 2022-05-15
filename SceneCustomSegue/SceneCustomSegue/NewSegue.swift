//
//  NewSegue.swift
//  SceneCustomSegue
//
//  Created by 김희진 on 2022/04/17.
//

import Foundation
import UIKit

class NewSegue: UIStoryboardSegue {
    
    override func perform(){

        //세그웨이의 출발지 뷰컨
        let srcUVC = self.source
        //세그웨이의 목작지 뷰컨
        let destUVC = self.destination
        //뷰 전환 실행
        UIView.transition(from: srcUVC.view, to: destUVC.view, duration: 2, options: .transitionCurlDown)
    }
}
