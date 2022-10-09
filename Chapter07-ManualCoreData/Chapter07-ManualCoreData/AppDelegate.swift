//
//  AppDelegate.swift
//  Chapter07-ManualCoreData
//
//  Created by 김희진 on 2022/10/09.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // 앱이 실행된 이후 한번만 DataModel 파일을 영구 저장소로 연결하고 컨테이너 객체로 만들어 리턴한다.
    lazy var persistentContainter: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { // 연결한 영구저장소를 읽어들인다.
            if let error = $1 as NSError? {
                fatalError("Unsolved error\(error) - \(error.userInfo)")
            }
        }
        return container
    }()
    
    // 관리 컨텍스트에 변경된 내용이 있는지 체크해서 변경사항을 영구 저장소에 반영해준다.
    func saveContext() {
        let context = persistentContainter.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unsolved error\(error) - \(error.userInfo)")
            }
        }
    }
    
    // 앱 종료 시에 컨텍스트가 자동으로 저장되도록 델리게이트 메소드 추가
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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


}

