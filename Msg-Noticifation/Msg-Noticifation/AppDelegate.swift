//
//  AppDelegate.swift
//  Msg-Noticifation
//
//  Created by 김희진 on 2022/04/23.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let notiCeneter = UNUserNotificationCenter.current()
        
        // alert, badge, sound 권한을 요청하고 수락 여부는 didAllow에서 알 수 있다. e 는 오류발생시 출력하면 된다.
        // didAllow가 false면 알림메시지를 발송하더라도 사용자게에 표시되지 않는다.
        notiCeneter.requestAuthorization(options: [.alert, .badge, .sound]) { didAllow, e in
            
        }
        notiCeneter.delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillResignActive(_ application: UIApplication) {
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
    

//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            if notification.request.identifier == "wakeup" {
                let uesrInfo = notification.request.content.userInfo
                print(uesrInfo["name"]!)
            }

        //알림 배너 띄워주기
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "wakeup" {
            let userInfo = response.notification.request.content.userInfo
            print(userInfo["name"]!)
        }
        completionHandler()
    }
    
}

