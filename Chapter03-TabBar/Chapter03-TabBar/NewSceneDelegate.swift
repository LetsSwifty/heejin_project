//
//  NewSceneDelegate.swift
//  Chapter03-TabBar
//
//  Created by 김희진 on 2022/09/10.
//

import Foundation
import UIKit

class NewSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow? // 이 window 객체는 씬델리게이트 클래스를 통해 제공된다.
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let tbC = UITabBarController()
        tbC.view.backgroundColor = .white //탭바 컨트롤러의 기본 배경색은 검정색이기 때문에 흰색으로 지정해줘야 한다.
        
        self.window?.rootViewController = tbC // 윈도우 객체가 참조하는 뷰 컨트롤러가 곧 루트뷰컨트롤러이므로, 탭바 컨트롤러를 윈도우의 루트 컨트롤러 속성에 대입한다.
        
        let view01 = ViewController()
        let view02 = SecondViewController()
        let view03 = ThirdViewController()
        
        tbC.setViewControllers([view01, view02, view03], animated: true) // 3개의 뷰 컨트롤러를 탭바의 뷰 컨트롤러들로 설정한다.

        // 탭바 아이템은 각 뷰 컨트롤러 하위에 연결되어 있는 속성이기 떄문에 탭바 아이템은 각 뷰 컨트롤러를 통해서 변경을 해야한다.
        view01.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(named: "calendar"), selectedImage: nil)
        view02.tabBarItem = UITabBarItem(title: "File", image: UIImage(named: "file-tree"), selectedImage: nil)
        view03.tabBarItem = UITabBarItem(title: "Photo", image: UIImage(named: "photo"), selectedImage: nil)
    }
    
}
