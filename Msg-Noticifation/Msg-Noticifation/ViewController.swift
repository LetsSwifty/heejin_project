//
//  ViewController.swift
//  Msg-Noticifation
//
//  Created by 김희진 on 2022/04/23.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet var msg: UITextField!

    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func save(_ sender: Any) {
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            
            if setting.authorizationStatus == UNAuthorizationStatus.authorized {
     
                DispatchQueue.main.async {

                    let nContent = UNMutableNotificationContent()
                    nContent.body = self.msg.text!
                    nContent.title = "미리알림"
                    nContent.sound = UNNotificationSound.default

                    // 발송 시각을 지금으로 부터 몇초 후 형식으로 변환
                    let time = self.datePicker.date.timeIntervalSinceNow
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
                    
                    let requset = UNNotificationRequest(identifier: "alarm", content: nContent, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(requset){_ in
                        DispatchQueue.main.async {
                            
                            //9시간 * 60분 * 60초
                            let date = self.datePicker.date.addingTimeInterval(9*60*60)
                            let message = "알림이 등록되었습니다. 등록된 알림은 \(date)에 발송됩니다"

                            
                            let alert = UIAlertController(title: "알림 등록", message: message, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "확인", style: .default)

                            alert.addAction(ok)
                            self.present(alert, animated: false)
                        }
                    }
                }
                
            }else {
                let alert = UIAlertController(title: "알림 등록", message: "알림이 허용되어 있지 않습니다", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)

                alert.addAction(ok)
                self.present(alert, animated: false)
                return
            }
        }
    }
}

