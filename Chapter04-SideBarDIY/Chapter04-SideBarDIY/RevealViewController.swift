//
//  RevealViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by 김희진 on 2022/09/12.
//

import UIKit

// 스토리보드의 루트뷰. 프론트 뷰와 리어 뷰를 컨트롤할 메인뷰 컨트롤러. 화면에 직접 등장하지는 않음!
// 첫 화면을 읽어오고 사이드 바를 여닫는 등 자식 뷰 컨트로롤러들의 기능을 처리하는 컨테이너 뷰 컨트롤러이다.(네비게이션, 탭바, 스플릿 뷰 컨트롤러와 동일한 계열)
class RevealViewController: UIViewController {

    var contentVC: UIViewController? // 콘텐츠를 담당할 뷰 컨트롤러
    var sideVC: UIViewController? // 사이드 바 메뉴를 담당할 뷰 컨트롤러
    var isSideBarShowing = false // 현재 사이드 바가 열려있는지 여부
    let SLIDE_TIME = 0.3 // 슬라이드 바 애니메이션 시간
    let SLIDE_WIDTH: CGFloat = 260 // 슬라이드 바 너비
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    // 초기화면 설정
    func setup() {
        // 네비게이션 컨트롤러(sw_front) 객체를 읽어온다.
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_front") as? UINavigationController {
            self.contentVC = vc
            
            // 자식 컨트롤러로 등록.뷰컨트롤러와 뷰 각각을 연결해줘야함
            self.addChild(vc)
            self.view.addSubview(vc.view)
            // 읽어온 컨트롤러에 부모 뷰 컨트롤러가 바뀌었음을 알려준다.
            vc.didMove(toParent: self)
            
            let frontVC = vc.viewControllers[0] as? FrontViewController
            frontVC?.delegate = self
        }
    }
    
    // 사이드 바의 뷰를 읽어옴
    func getSideView() {
        
        guard self.sideVC == nil else { return }
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_rear") else {
            return
        }
        
        self.sideVC = vc
        
        // 자식 컨트롤러로 등록.뷰컨트롤러와 뷰 각각을 연결해줘야함
        self.addChild(vc)
        self.view.addSubview(vc.view)
        // 읽어온 컨트롤러에 부모 뷰 컨트롤러가 바뀌었음을 알려준다.
        vc.didMove(toParent: self)
        
        
        // 프론트 컨트롤러의 뷰를 제일 위로 올린다!!
        self.view.bringSubviewToFront((self.contentVC?.view)!)
    }

    // 콘텐츠 뷰에 그림자 효과를 준다. shadow는 그림자 셋팅여부, offset은 그림자의 깊이감이다.
    func setShadowEffect(shadow: Bool, offset: CGFloat) {
        if shadow {
            self.contentVC?.view.layer.masksToBounds = false
            self.contentVC?.view.layer.cornerRadius = 10
            self.contentVC?.view.layer.shadowOpacity = 0.8
            self.contentVC?.view.layer.shadowColor = UIColor.black.cgColor
            self.contentVC?.view.layer.shadowOffset = CGSize(width: offset, height: offset) //그림자 크기
        } else { // 효과제거, 크기를 0으로 만들어버림
            self.contentVC?.view.layer.cornerRadius = 0.0
            self.contentVC?.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }
    
    // 사이드 바를 연다
    func openSideBar(_ complete: (() -> Void)?) {
        self.getSideView()
        self.setShadowEffect(shadow: true, offset: -2) // 그림자 효과를 줌
    
        UIView.animate(withDuration: SLIDE_TIME, delay: 0, options: [.curveEaseOut, .beginFromCurrentState]) {
            // getSideView() 에의해 사이드 바는 가져왔지만, 콘텐츠 뷰에 가려 안보이는 상태이다. 그래서 콘텐츠뷰를 옆으로 밀어주면 보임!
            self.contentVC?.view.frame = CGRect(x: self.SLIDE_WIDTH, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        } completion: {
            // animate() 애니메이션은 비동기로 실행되기 때문에 완료 시점을 알기위해 컴플리젼을 씀
            if $0 { //$0 는 실행완료 여부임
                self.isSideBarShowing = true
                complete?()
            }
        }
    }
    
    // 사이드 바를 닫는다.
    func closeSideBar(_ complete: (() -> Void)?) {
        UIView.animate(withDuration: SLIDE_TIME, delay: 0, options: [.curveEaseOut, .beginFromCurrentState]) {
            self.contentVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        } completion: {
            if $0 {
                self.sideVC?.view.removeFromSuperview()
                self.sideVC = nil
                self.isSideBarShowing = false
                self.setShadowEffect(shadow: false, offset: 0)
                complete?()
            }
        }
    }
}
