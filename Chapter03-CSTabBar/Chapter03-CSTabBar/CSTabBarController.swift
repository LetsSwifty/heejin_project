//
//  CSTabBarController.swift
//  Chapter03-CSTabBar
//
//  Created by 김희진 on 2022/09/11.
//

import Foundation
import UIKit

class CSTabBarController: UITabBarController {
    
    let csView = UIView()
    let tabItem01 = UIButton(type: .system)
    let tabItem02 = UIButton(type: .system)
    let tabItem03 = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true //원래의 탭바를 숨김
        
        let width = self.view.frame.width
        let height: CGFloat = 80
        let x: CGFloat = 0
        let y = self.view.frame.height - height
        
        self.csView.frame = CGRect(x: x, y: y, width: width, height: height)
        self.csView.backgroundColor = .brown
        self.view.addSubview(self.csView)
        
        
        
        let tabBtnWidth = self.csView.frame.size.width / 3
        let tabBtnHeight = self.csView.frame.size.height
        self.tabItem01.frame = CGRect(x: 0, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        self.tabItem02.frame = CGRect(x: tabBtnWidth, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        self.tabItem03.frame = CGRect(x: tabBtnWidth * 2, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        
        
        self.addTabBarBtn(btn: self.tabItem01, title: "버튼0", tag: 0)
        self.addTabBarBtn(btn: self.tabItem02, title: "버튼1", tag: 1)
        self.addTabBarBtn(btn: self.tabItem03, title: "버튼2", tag: 2)
        
        self.onTabBarItemClick(self.tabItem01) // 맨 첨에 첫번째 탭이 선택된 채로 만들기!
    }

    func addTabBarBtn(btn: UIButton, title: String, tag: Int) {
        btn.setTitle(title, for: .normal)
        btn.tag = tag
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.yellow, for: .selected)
        btn.addTarget(self, action: #selector(onTabBarItemClick), for: .touchUpInside)
        self.csView.addSubview(btn)
    }
    
    @objc func onTabBarItemClick(_ sender: UIButton) {
        self.tabItem01.isSelected = false
        self.tabItem02.isSelected = false
        self.tabItem03.isSelected = false

        sender.isSelected = true
        self.selectedIndex = sender.tag // 이 코드 덕분에 화면 전환 코드를 작성하지 않아도 된다. selectedIndex 속성에 의해 탭바 컨트롤러의 탭이 바뀐다!
    }
}
