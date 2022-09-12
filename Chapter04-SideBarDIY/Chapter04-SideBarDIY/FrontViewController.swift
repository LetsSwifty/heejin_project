//
//  FrontViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by 김희진 on 2022/09/12.
//

import UIKit

// 앱이 실행되었을때 가장 먼저 보이는 화면
class FrontViewController: UIViewController {

    var delegate: RevealViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //요기 target은 다른 클래스의 메소드를 사용할때면 그 객체를 참조할 수 있는 값을 넣어주어야 한다.
        let btnSideBar = UIBarButtonItem(image: UIImage(named: "sidemenu.png"), style: .plain, target: self, action: #selector(moveSide))
        self.navigationItem.leftBarButtonItem = btnSideBar
        
        // UIScreenEdgePanGestureRecognizer 는 Ui의 한쪽 끝에서 시작해서 반대편까지 드래그가 이어지는 패턴을 인식하기 위한 객체다.
        let dragLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(moveSide))
        dragLeft.edges = .left // 제스쳐가 시작되는 시작위치 설정
        self.view.addGestureRecognizer(dragLeft)
        
        
        // UI 끝이 아닌 중간 위치에서 드래그하는 동작을 인식한다.
        let dragRight = UISwipeGestureRecognizer(target: self, action: #selector(moveSide))
        dragRight.direction = .left // 방향 설정
        self.view.addGestureRecognizer(dragRight)
    }
    
    // 사용자의 액션에 따라 델리게이트 메소드를 호출한다.
    @objc func moveSide(_ sender: Any) {
        if sender is UIScreenEdgePanGestureRecognizer {
            self.delegate?.openSideBar(nil)
        } else if sender is UISwipeGestureRecognizer {
            self.delegate?.closeSideBar(nil)
        } else if sender is UIBarButtonItem {
            if delegate?.isSideBarShowing == false {
                self.delegate?.openSideBar(nil)
            } else {
                self.delegate?.closeSideBar(nil)
            }
        }
    }
    
}
