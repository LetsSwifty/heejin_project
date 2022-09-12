//
//  FrontViewController.swift
//  Chapter04-SideBar
//
//  Created by 김희진 on 2022/09/11.
//

import UIKit

class FrontViewController: UIViewController {

    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let revealVC = self.revealViewController() { // 메인 컨트롤러의 참조 정보를 가져온다. 그니까 스토리보드에서 SWRevealViewController 클래스를 가지고 맨 앞에있던애!
            // 버튼이 클릭될 때 메인 컨트롤러에 정의된 revealToggle()을 호출한다.
            self.sideBarButton.target = revealVC
            self.sideBarButton.action = #selector(revealVC.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }

}
