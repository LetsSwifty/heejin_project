//
//  SceneDelegate.swift
//  Chapter03-TabBar
//
//  Created by 김희진 on 2022/09/02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let tbC = self.window?.rootViewController as? UITabBarController {
            if let tbItems = tbC.tabBar.items {
                tbItems[0].image = UIImage(named: "designbump")?.withRenderingMode(.alwaysOriginal)
                tbItems[1].image = UIImage(named: "rss")?.withRenderingMode(.alwaysOriginal)
                tbItems[2].image = UIImage(named: "facebook")?.withRenderingMode(.alwaysOriginal)
                
                
                for tbItem in tbItems {
                    let image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysOriginal)
                    tbItem.selectedImage = image

//                    tbItem.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .disabled)
//                    tbItem.setTitleTextAttributes([.foregroundColor: UIColor.red], for: .selected)
//                    tbItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 15)], for: .normal)
                }
                
                let tbItemProxy = UITabBarItem.appearance()
                tbItemProxy.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .disabled)
                tbItemProxy.setTitleTextAttributes([.foregroundColor: UIColor.red], for: .selected)
                tbItemProxy.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 15)], for: .normal)
                

 
                tbItems[0].title = "Calendar"
                tbItems[1].title = "File"
                tbItems[2].title = "Photo"
            }

            
//            tbC.tabBar.backgroundColor = .black
//            tbC.tabBar.tintColor = .white
//            tbC.tabBar.unselectedItemTintColor = .gray

            let tProxy = UITabBar.appearance()
            tProxy.backgroundColor = .black
            tProxy.tintColor = .white
            tProxy.unselectedItemTintColor = .gray
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

