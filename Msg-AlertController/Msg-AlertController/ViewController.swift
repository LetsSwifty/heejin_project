//
//  ViewController.swift
//  Msg-AlertController
//
//  Created by 김희진 on 2022/04/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func alert(_ sender: Any) {
        
        let alert = UIAlertController(title: "선택", message: "항목을 선택해주세요", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel){_ in
            self.result.text = "취소 버튼을 클릭했습니다"
        }
        
        let ok = UIAlertAction(title: "확인", style: .default){_ in
            self.result.text = "확인 버튼을 클릭했습니다"
        }
        
        let exec = UIAlertAction(title: "실행", style: .destructive){_ in
            self.result.text = "실행 버튼을 클릭했습니다"
        }
        
        let stop = UIAlertAction(title: "중지", style: .default){_ in
            self.result.text = "증지 버튼을 클릭했습니다"
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.addAction(exec)
        alert.addAction(stop)

        self.present(alert, animated: false)
    }
    
    @IBAction func login(_ sender: Any) {
        let title = "iTunes Store에 로그인"
        let message = "사용자의 Apple ID 의 암호를 입력하세요"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default) {_ in
            
            // 텍스트 필드를 여러개 추가가 가능하기 때문에 인덱스를 붙여서 (혹은 .first) 가져온다.
            if let tf = alert.textFields?[0]{
                print("입력된 값은 \(tf.text!)입니다")
            }else {
                print("입력된 값이 없습니다")
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
    
        // 새로 텍스트필드를 추가하지 않고 addTextField를 이용해서 추가한다.
        alert.addTextField { tf in
            // 이 클로져의 목적은 추가된 텍스트 필드의 속성을 설정하는 용도.
            tf.placeholder = "암호"
            tf.isSecureTextEntry  = true
        }
        
        self.present(alert, animated: false)
    }
    
    @IBAction func auth(_ sender: Any) {
        
        let msg = "로그인"
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default) {_ in
            let loginId = alert.textFields?.first?.text
            let loginPW = alert.textFields?[1].text
            
            if loginId == "sqlPro" && loginPW == "1234" {
                self.result.text = "인증되었습니다"
            }else {
                self.result.text = "인증에 실패하였습니다"
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
    
        alert.addTextField { tf in
            tf.placeholder = "아이디"
            tf.isSecureTextEntry = false
        }
        alert.addTextField { tf in
            tf.placeholder = "비밀번호"
            tf.isSecureTextEntry = true
        }

        self.present(alert, animated: false)
    }
}

