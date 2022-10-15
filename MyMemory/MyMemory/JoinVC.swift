//
//  JoinVC.swift
//  MyMemory
//
//  Created by 김희진 on 2022/10/12.
//

import UIKit
import Alamofire

class JoinVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var isCalling = false
    
    var fieldAccount: UITextField!
    var fieldPassword: UITextField!
    var fieldName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.profile.layer.cornerRadius = self.profile.frame.width / 2
        self.profile.layer.masksToBounds = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedProfile))
        self.profile.addGestureRecognizer(gesture)
        
        self.view.bringSubviewToFront(self.indicatorView) // 인디케이터 뷰를 맨 앞으로
    }
    
    @objc func tappedProfile(_ sender: Any) {
        let msg = "프로필 이미지를 읽어올 곳을 선택하세요"
        let sheet = UIAlertController(title: msg, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        sheet.addAction(UIAlertAction(title: "저장된 앨범", style: .default) { _ in
            selectLibrary(src: .savedPhotosAlbum)
        })
        sheet.addAction(UIAlertAction(title: "포토 라이브러리", style: .default) { _ in
            selectLibrary(src: .photoLibrary)
        })
        sheet.addAction(UIAlertAction(title: "카메라", style: .default) { _ in
            selectLibrary(src: .camera)
        })
        self.present(sheet, animated: true)
            
        
        func selectLibrary(src: UIImagePickerController.SourceType) {
            if UIImagePickerController.isSourceTypeAvailable(src) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true

                self.present(picker, animated: true)
            } else {
                self.alert("사용할 수 없는 타입입니다")
            }
        }
    }

    // 이미지 선택 시 실행되는 델리게이트 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let rawVal = UIImagePickerController.InfoKey.originalImage.rawValue
        if let img = info[UIImagePickerController.InfoKey(rawValue: rawVal)] as? UIImage {
            self.profile.image = img
        }
        
        self.dismiss(animated: true)
    }
    
    @IBAction func submit(_ sender: Any) {
        
        if self.isCalling {
            self.alert("처리중입니다. 잠시만 기다려주세요")
            return //로직종료
        } else {
            self.isCalling = true
        }
        
        self.indicatorView.startAnimating()
        
        // 이미지를 데이터로 만들어서 Base64로 인코딩처리함
        let profile = self.profile.image!.pngData()?.base64EncodedString()
        
        let param: Parameters = [
            "account" : self.fieldAccount.text!,
            "passwd" : self.fieldPassword.text!,
            "name" : self.fieldName.text!,
            "profile_image" : profile!,
        ]
        
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/join"
        let call = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
        call.responseJSON { res in

            self.indicatorView.stopAnimating()

            guard let jsonObject = try! res.result.get() as? [String: Any] else {
                self.isCalling = false
                self.alert("서버 호출 과정에서 오류가 발생했습니다")
                return
            }
            
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode == 0 {
                self.alert("가입이 완료되었습니다") {
                    self.performSegue(withIdentifier: "backProfileVC", sender: self)
                }
            } else {
                self.isCalling = false

                let errorMsg = jsonObject["error_msg"] as! String
                self.alert("오류발생: \(errorMsg)")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let ffFrame = CGRect(x: 20, y: 0, width: cell.bounds.width - 20, height: 37)

        switch indexPath.row {
        case 0:
            self.fieldAccount = UITextField(frame: ffFrame)
            self.fieldAccount.placeholder = "이메일 계정"
            self.fieldAccount.borderStyle = .none
            self.fieldAccount.autocapitalizationType = .none
            self.fieldAccount.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(self.fieldAccount)
        case 1:
            self.fieldPassword = UITextField(frame: ffFrame)
            self.fieldPassword.placeholder = "비밀번호"
            self.fieldPassword.borderStyle = .none
            self.fieldPassword.isSecureTextEntry = true
            self.fieldPassword.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(self.fieldPassword)
        case 2:
            self.fieldName = UITextField(frame: ffFrame)
            self.fieldName.placeholder = "이름"
            self.fieldName.borderStyle = .none
            self.fieldName.font = UIFont.systemFont(ofSize: 14)
            cell.addSubview(self.fieldName)
        default:
            ()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

}
