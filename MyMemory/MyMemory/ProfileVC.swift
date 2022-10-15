//
//  ProfileVC.swift
//  MyMemory
//
//  Created by 김희진 on 2022/09/12.
//

import UIKit
import Alamofire
import LocalAuthentication

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var profileImage = UIImageView()
    let tv = UITableView()
    
    let uinfo = UserInfoManager()
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var isCalling = false
    
    
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
        
        self.view.bringSubviewToFront(self.indicatorView)
        
        
        let tk = TokenUtils()
        if let at = tk.load("kr.co.rubypaper.MyMemory", account: "accessToken") {
            print("at: \(at)")
        } else {
            print("at nil")
        }
        
        if let rt = tk.load("kr.co.rubypaper.MyMemory", account: "refreshToken") {
            print("rt: \(rt)")
        } else {
            print("rt nil")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tokenValidate()
    }
    
    @objc func doLogin(_ sender: Any) {
        if self.isCalling {
            self.alert("응답을 기다리는 중입니다. 잠시만 기다려 주세요.")
            return
        } else {
            self.isCalling = true
        }
        
        let loginAlert = UIAlertController(title: "LOGIN", message: nil, preferredStyle: .alert)
        loginAlert.addTextField() {
            $0.placeholder =  "Your Account"
        }
        loginAlert.addTextField() {
            $0.placeholder = "Password"
            $0.isSecureTextEntry = true
        }
        
        loginAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.isCalling = false
        })
        
        loginAlert.addAction(UIAlertAction(title: "Login", style: .destructive) { _ in
            self.indicatorView.startAnimating()
            
            let account = loginAlert.textFields?[0].text ?? ""
            let pw = loginAlert.textFields?[1].text ?? ""
            
//            if self.uinfo.login(account: account, pw: pw) {
            self.uinfo.login2(account: account, passwd: pw, success: {
                self.indicatorView.stopAnimating()
                self.isCalling = false
                
                // 로그인 성공시 처리할 내용
                self.tv.reloadData()
                self.profileImage.image = self.uinfo.profile
                self.drawBtn()
                
                // 서버와 데이터 동기화
                let sync = DataSync()
                DispatchQueue.global(qos: .background).async {
                    sync.downloadBackUpData() // 서버에 데이터가 있으면 내려받는다
                }
                DispatchQueue.global(qos: .background).async {
                    sync.uploadData() // 서버에 저장해야할 데이터가 있으면 업로드한다.
                }
            }, fail: { msg in
                self.indicatorView.stopAnimating()
                self.isCalling = false
                self.alert(msg)
            })
        })
        
        self.present(loginAlert, animated: false)
    }

    
    @objc func doLogout(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { _ in
//            if self.uinfo.logout() {
            self.uinfo.logout2() {
               
                self.indicatorView.startAnimating()
                
                // 로그아웃시 처리할 내용
                self.tv.reloadData()
                self.profileImage.image = self.uinfo.profile
                self.drawBtn()
                
                self.indicatorView.stopAnimating()
            
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
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        // info 에는 이미지 타입, 생성날짜 등 다양한 메타데이터가 들어있다.
//        // 이중에서 이미지를 읽어올때는 .editedImage, .originalImage를 이용하면 된다.
//        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            self.uinfo.profile = img
//            self.profileImage.image = img
//        }
//        picker.dismiss(animated: true)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.indicatorView.startAnimating()
        
        // info 에는 이미지 타입, 생성날짜 등 다양한 메타데이터가 들어있다.
        // 이중에서 이미지를 읽어올때는 .editedImage, .originalImage를 이용하면 된다.
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.uinfo.newProfile(img, success: {
                self.indicatorView.stopAnimating()
                self.profileImage.image = img
            }, fail: { msg in
                self.indicatorView.stopAnimating()
                self.alert(msg)
            })
        }
        picker.dismiss(animated: true)
    }

    
    
    @IBAction func backProfileVC(_ segue: UIStoryboardSegue) {
        //단지 프로필 화면으로 되돌아 오기 위한 표시 역할만 할 뿐이므로 아무 내용도 작성하지 않음
    }

}


extension ProfileVC {
    // 토큰 인증을 통해 유효성을 검사하는 메소드
    func tokenValidate() {
        
        // 응답 캐시를 사용하지 않도록 함. URLCache 가 관리하고, removeAllCachedResponses 를 통해 캐시를 삭제한다.
        URLCache.shared.removeAllCachedResponses()
        
        // 케체인에 엑세스 토큰이 없을 경우 유효성 검증을 진행하지 않음
        let tk = TokenUtils()
        guard let header = tk.getAuthorizationHeader() else { return } // 액세스 토큰이 비어있을 경우 nil을 반환한다. 이는 로그아웃되었거나 로그인한 적이 없는거다.
        
        // 로딩 인디케이터 시작
        self.indicatorView.startAnimating()
        
        // 유효성 검사 API 호출. 헤더만 필요!
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/tokenValidate"
        let validate = AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header)
        validate.responseJSON { res in
            self.indicatorView.stopAnimating()
            let responseBody = try! res.result.get()
            print(responseBody)
            
            guard let jsonObject = responseBody as? NSDictionary else {
                self.alert("잘못된 응답입니다")
                return
            }
            
            // 응답 결과 처리
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode != 0 { // 응답 결과가 실패. 즉 토큰이 만료됨. 0이면 엑세스 토큰이 유효하므로 그대로 둔 채 메소드를 종료한다.
                self.touchID()
            }
        }
    }
    
    // (토큰만료시) 터치 아이디 인증 메소드
    func touchID() {
        let context = LAContext()
        
        var error: NSError?
        let msg = "인증이 필요합니다"
        let deviceAuth = LAPolicy.deviceOwnerAuthenticationWithBiometrics // 인증 정책
        
        //로컬 인증이 사용 가능한지 여부 확인(터치인증 제공하는 기종, 아이디 등록 여부 체크)
        if context.canEvaluatePolicy(deviceAuth, error: &error) {
            // 가능하다면 터치 아이디 인증창 실행
            context.evaluatePolicy(deviceAuth, localizedReason: msg) { success, e in
                if success { // 인증 성공 -> 토큰 갱신 로직!
                    self.refresh()
                } else { // 인증 실패
                    // 인증 실패 원인에 대한 대응 로직
                    print((e?.localizedDescription)!)
                    
                    // (LAError.systemCancel) - 어떤 식으로든 인증창이 일단 실행된 후에 인증이 실패했을 때 발생하는 오류들
                    switch  e!._code {
                    case LAError.systemCancel.rawValue:
                        self.alert("시스템에 의해 취소되었습니다")
                    case LAError.userCancel.rawValue: // 다시시도 Alert에 -> 취소 액션
                        self.alert("사용자에 의해 취소되었습니다")
                    case LAError.userFallback.rawValue: // 다시시도 Alert에 -> 암호입력 액션
                        OperationQueue.main.addOperation { // 경고창과 인증텍스트필드 창이 겹치지 않도록 요렇게 해줌
                            self.commonLogout(true)
                        }
                    default:
                        OperationQueue.main.addOperation {
                            self.commonLogout(true)
                        }
                    }
                }
            }
        } else { // 인증창이 싱행되지 못한 경우
            // 인증창 실행 불가 원인에 대한 대응 로직
            
            print(error!.localizedDescription)
            switch error?.code {
            case LAError.biometryNotEnrolled.rawValue:
                print("터치 아이디가 등록되어 있지 않습니다")
            case LAError.passcodeNotSet.rawValue:
                print("패스 코드가 설정되어 있지 않습니다")
            default:
                print("터치 아이디를 사용할 수 없습니다")
            }
            
            OperationQueue.main.addOperation {
                self.commonLogout(true)
            }
        }
    }
    
    // (인증 성공시)토큰 갱신 메소드
    func refresh() {
        self.indicatorView.startAnimating()

        // 인증 헤더 가져오기
        let tk = TokenUtils()
        let header = tk.getAuthorizationHeader()
 
        // 리프레시 토큰 전달 준비(원래 토큰 갱신시에는 맨첨에 저장되어있던 리프레시 토큰 쓰는거임. 이 값은 바뀌지 않음!)
        let refreshToken = tk.load("kr.co.rubypaper.MyMemory", account: "refreshToken")
        let param: Parameters = ["refresh_token": refreshToken!]
        
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/refresh"
        let refresh = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header) // 서버에 리프레시토큰 보냄
        refresh.responseJSON { res in
            self.indicatorView.startAnimating()
            
            guard let jsonObject = try! res.result.get() as? NSDictionary else {
                self.alert("잘못된 응답입니다.")
                return
            }
            
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode == 0 { // 성공 -> 엑세스 토큰이 갱신되어있다는 의미
                // 키체인에 저장된 엑세스 토큰 교체
                let accessToken = jsonObject["access_token"] as! String
                tk.save("kr.co.rubypaper.MyMemory", account: "accessToken", value: accessToken)
            } else {
                // 갱신 실패 -> 액세스 토큰 만료처리 해줘야함
                self.alert("인증이 만료되었으므로 다시 로그인해야 합니다") {
                    // 로그아웃 처리 및 로그인 화면으로 유도
                    OperationQueue.main.addOperation {
                        self.commonLogout(true)
                    }
                }
            }
        }
    }
    
    // 토큰 갱식 과정에서 발생할 각족 실패나 오류 상황에 사용할 공용 로그아웃 메소드
    func commonLogout(_ isLogin: Bool = false) {
        // 저장된 기존 개인 정보 & 키체인 데이터를 삭제하여 로그아웃 상태로 전환
        let userInfo = UserInfoManager()
        userInfo.deviceLogout()
        
        // 현재의 화면이 프로필화면이라면 UI갱신
        self.tv.reloadData()
        self.profileImage.image = userInfo.profile
        self.drawBtn()
        
        // 기본 로그인 창 실행 여부. 기존에 아이디/패스위드 셀 누르면 작동했던 메소드임
        if isLogin {
            self.doLogin(self)
        }
    }
}
