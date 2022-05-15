//
//  SceneDelegate.swift
//  Msg-Noticifation
//
//  Created by 김희진 on 2022/04/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
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
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized { //권한이 있으면
                //알림 콘텐츠 객체 생성
                let nContent = UNMutableNotificationContent()
                nContent.badge = 1  // 앱 아이콘 뱃지에 1 표시

                //상단 알림창에 표시될 메세지의 제목과 소제목, 바디
                nContent.title = "로컬 알림 메시지"
                nContent.subtitle = "준비된 내용이 아주 만아요! 얼른 다시 앱을 열어주세요!"
                nContent.body = "앗 ! 왜나갔어요?? 얼른 들어오세요~"
                
                //알림음
                nContent.sound = UNNotificationSound.default

                //로컬알림과 함께 전달하고 싶은 값이 있을때 사용하는 속성. 이 속성에 저장된 값은 화면에는 표시되지 않지만 이 알림을 눌러서 연결되는 앱델리게이트메소드에서는 참조가 가능
                //사용자가 알림 메시지를 클릭했을 때 뭔가 처리를 해주기 위해 추가데이터가 필요하다면 이 속성에 커스텀 데이터를 정의하여 전달하면 된다.
                nContent.userInfo = ["name":"김희진"]
                
                
                //알림시간 설정.
                //UNTimeIntervalNotificationTrigger 말고 UNCalendarNotificationTrigger 하루중 특정시각을 지정하여 알림메시지를 전송하는 갹체이다.
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) //5초후에 자동발송되도록 함
                
                
                //알림 요청 객체
                //식별아이디, 내용, 시간등을 전부 포함한다.
                let request = UNNotificationRequest(identifier: "wakeup", content: nContent, trigger: trigger)

                
                //노티피케이션 센터에 추가
                UNUserNotificationCenter.current().add(request)
                
            }else { // 권한이 없으면
                print("사용자가 동의하지 않음")
            }
        }
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

