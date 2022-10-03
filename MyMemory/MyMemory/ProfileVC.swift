//
//  ProfileVC.swift
//  MyMemory
//
//  Created by 김희진 on 2022/09/12.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var profileImage = UIImageView()
    let tv = UITableView()
    
    let uinfo = UserInfoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "프로필"
        let backBtn = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationController?.navigationBar.isHidden = true
        
        let bgImg = UIImageView(image: UIImage(named: "profile-bg"))
        bgImg.frame.size = CGSize(width: bgImg.frame.width, height: bgImg.frame.height)
        bgImg.center = CGPoint(x: self.view.frame.width / 2, y: 40)
        bgImg.layer.cornerRadius = bgImg.frame.size.width / 2
        bgImg.layer.borderWidth = 0
        bgImg.layer.masksToBounds = true
        self.view.addSubview(bgImg)
        
//        self.profileImage.image = UIImage(named: "account.jpg")
        self.profileImage.image = self.uinfo.profile
        self.profileImage.frame.size = CGSize(width: 100, height: 100)
        self.profileImage.center = CGPoint(x: self.view.frame.width / 2, y: 270)
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        self.view.addSubview(profileImage)

        self.tv.frame = CGRect(x: 0, y: self.profileImage.frame.origin.y + self.profileImage.frame.size.height + 20, width: self.view.frame.width, height: 100)
        self.tv.delegate = self
        self.tv.dataSource = self
        self.view.addSubview(tv)
        
        // self.view.bringSubviewToFront(self.tv) 를 통해 가장 위로 올릴 수 있다!!!!!!!!!!!
        self.drawBtn()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profile))
        self.profileImage.addGestureRecognizer(tap)
        self.profileImage.isUserInteractionEnabled = true // 디폴트가 false 임
    }
    
    @objc func doLogin(_ sender: Any) {
        let loginAlert = UIAlertController(title: "LOGIN", message: nil, preferredStyle: .alert)
        loginAlert.addTextField() {
            $0.placeholder =  "Your Account"
        }
        loginAlert.addTextField() {
            $0.placeholder = "Password"
            $0.isSecureTextEntry = true
        }
        
        loginAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        loginAlert.addAction(UIAlertAction(title: "Login", style: .destructive) { _ in
            let account = loginAlert.textFields?[0].text ?? ""
            let pw = loginAlert.textFields?[1].text ?? ""
            
            if self.uinfo.login(account: account, pw: pw) {
                // 로그인 성공시 처리할 내용
                self.tv.reloadData()
                self.profileImage.image = self.uinfo.profile
                self.drawBtn()
            } else {
                let alert = UIAlertController(title: nil, message: "로그인에 실패하였습니다", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel))
                self.present(alert, animated: false)
            }
        })
        self.present(loginAlert, animated: false)
    }

    
    @objc func doLogout(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { _ in
            if self.uinfo.logout() {
                // 로그아웃시 처리할 내용
                self.tv.reloadData()
                self.profileImage.image = self.uinfo.profile
                self.drawBtn()
            }
        })
        self.present(alert, animated: false)
    }
    
    @objc func close() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func drawBtn() {
        let v = UIView()
        v.frame.size.width = self.view.frame.width
        v.frame.size.height = 40
        v.frame.origin.x = 0
        v.frame.origin.y = self.tv.frame.origin.y + self.tv.frame.height
        v.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        
        self.view.addSubview(v)
        
        let btn = UIButton(type: .system)
        btn.frame.size.width = 100
        btn.frame.size.height = 30
        btn.center.x = v.frame.size.width / 2
        btn.center.y = v.frame.size.height / 2
        
        if self.uinfo.isLogin {
            btn.setTitle("로그아웃", for: .normal)
            btn.addTarget(self, action: #selector(doLogout), for: .touchUpInside)
        } else {
            btn.setTitle("로그인", for: .normal)
            btn.addTarget(self, action: #selector(doLogin), for: .touchUpInside)
        }
        v.addSubview(btn)
    }
    
    func imgPicker(_ source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    @objc func profile(_ sender: UIButton) {
        guard self.uinfo.account != nil else { // 로그인되어있지 않을 경우에는 피로필 이미지 등록을 막고 대신 로그인 창을 띄워 준다.
            self.doLogin(self)
            return
        }
        
        let alert = UIAlertController(title: nil, message: "사진을 가져올 곳을 선택해주세요", preferredStyle: .actionSheet)

        // 카메라를 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "카메라", style: .default) { _ in
                self.imgPicker(.camera)
            })
        }
        
        // 저장된 앨범을 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            alert.addAction(UIAlertAction(title: "저장된 앨범", style: .default) { _ in
                self.imgPicker(.savedPhotosAlbum)
            })
        }

        // 포토 라이브러리를 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default) { _ in
                self.imgPicker(.photoLibrary)
            })
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //value1은 왼쪽 끝에 textLabel, 오른쪽 끝에 deailTextLabel이 있는 형태이다
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")

        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.detailTextLabel?.font = .systemFont(ofSize: 13)
        cell.accessoryType = .disclosureIndicator

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "이름"
//            cell.detailTextLabel?.text = "이름"
            cell.detailTextLabel?.text = self.uinfo.name ?? "Login Please"
        case 1:
            cell.textLabel?.text = "계정"
//            cell.detailTextLabel?.text = "이름"
            cell.detailTextLabel?.text = self.uinfo.account ?? "Login Please"
        default:
            ()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.uinfo.isLogin == false {
            self.doLogin(self.tv)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // info 에는 이미지 타입, 생성날짜 등 다양한 메타데이터가 들어있다.
        // 이중에서 이미지를 읽어올때는 .editedImage, .originalImage를 이용하면 된다.
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.uinfo.profile = img
            self.profileImage.image = img
        }
        picker.dismiss(animated: true)
    }

}
