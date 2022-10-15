//
//  ViewController.swift
//  Chapter08-APITest
//
//  Created by 김희진 on 2022/10/11.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currentTime: UILabel!
    
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var responseView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func json(_ sender: Any) {
        let userId = (self.userId.text)!
        let name = (self.name.text)!

        //param 변경됨!!!!!
        let param: [String: Any] = ["userId": userId, "name": name]
        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        
        //변경됨!!!!!!!
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echoJSON")


        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        // 변경됨!!!!!!!!!!!!
        // HTTP 헤더 설정 addValue, setValue 둘다 가능
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //본문이 인코딩 되었다는 뜻
        request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length") // 본문의 길이를 알려주는 역할. 애도 헤더에 넣어야함
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let e = error {
                NSLog(e.localizedDescription)
                return
            }
            
            // 응답이 성공했을 떄
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    guard let jsonObject = object else { return }
                    
                    let result = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String
                    
                    if result == "SUCCESS" {
                        self.responseView.text = "아이디: \(name!) \n"
                        + "이름: \(userId!) \n"
                        + "응답결과: \(result!) \n"
                        + "응답시간: \(timestamp!) \n"
                        + "요청방식: application/json"
                    }
                } catch let e as NSError {
                    print(e.localizedDescription)
                }
            }
        }
        
        // POST 전송
        task.resume()
    }
    
    @IBAction func post(_ sender: Any) {
        let userId = (self.userId.text)!
        let name = (self.name.text)!
        let param = "userId=\(userId)&name=\(name)"
        let paramData = param.data(using: .utf8) // POST는 인코딩 꼭 해서 보내야함!
        
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echo")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        // HTTP 헤더 설정 addValue, setValue 둘다 가능
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //본문이 인코딩 되었다는 뜻
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length") // 본문의 길이를 알려주는 역할. 애도 헤더에 넣어야함
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let e = error {
                NSLog(e.localizedDescription)
                return
            }
            
            // 응답이 성공했을 떄
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    
                    guard let jsonObject = object else { return }
                    
                    let result = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String
                    
                    if result == "SUCCESS" {
                        self.responseView.text = "아이디: \(name!) \n"
                        + "이름: \(userId!) \n"
                        + "응답결과: \(result!) \n"
                        + "응답시간: \(timestamp!) \n"
                        + "요청방식: x-www-form-urlencoded"
                    }
                } catch let e as NSError {
                    print(e.localizedDescription)
                }
            }
        }
        
        // POST 전송
        task.resume()
    }
    
    
    @IBAction func callCurrentTime(_ sender: Any) {
        do {
            let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime")
            let response = try String(contentsOf: url!)
            
            self.currentTime.text = response
            self.currentTime.sizeToFit()
            
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
}

