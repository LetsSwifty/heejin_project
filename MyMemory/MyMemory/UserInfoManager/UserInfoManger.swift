//
//  UserInfoManger.swift
//  MyMemory
//
//  Created by 김희진 on 2022/10/03.
//

import Foundation
import Alamofire

struct UserInfoKey {
    static let loginId = "LOGINID"
    static let account = "ACCOUNT"
    static let name = "NAME"
    static let profile = "PROFILE"
    static let tutorial = "TUTORIAL"
}


class UserInfoManager {
    // 연산프로퍼티 loginId 정의
    var loginId: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserInfoKey.loginId)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.loginId)
            ud.synchronize()
        }
    }
    
    var account: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.account)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.account)
            ud.synchronize()
        }
    }
    
    var name: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.name)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.name)
            ud.synchronize()
        }
    }
    
    var profile: UIImage? { // UImage 타입은 프로퍼티 리스트에 직접 저장할 수 없어서 Data타입으로 변환 후 저장해야한다. -> UIImage.pngData()
        get {
            let ud = UserDefaults.standard
            if let _profile = ud.data(forKey: UserInfoKey.profile) {
                return UIImage(data: _profile) // Data타입을 UImage로 변환할 수 있다.
            } else {
                return UIImage(named: "account.jpg")
            }
        }
        set(v) {
            if v != nil {
                let ud = UserDefaults.standard
                ud.set(v!.pngData(), forKey: UserInfoKey.profile)
                ud.synchronize()
            }
        }
    }
    
    var isLogin: Bool {
        if self.loginId == 0 || self.account == nil { // 로그인 아이디가 0이거나 계정이 비어있으면 로그인 되어있지 않다고 판단한다.
            return false
        } else {
            return true
        }
    }
    
    func login(account: String, pw: String) -> Bool {
        if account.isEqual("sqlPro@naver.com") && pw.isEqual("1234") { // 로그인 성공
            let ud = UserDefaults.standard
            ud.set(100, forKey: UserInfoKey.loginId)
            ud.set(account, forKey: UserInfoKey.account)
            ud.set("재은씨", forKey: UserInfoKey.name)
            ud.synchronize()
            return true
        } else {
            return false
        }
    }
    
    func login2(account: String, passwd: String, success: (() -> Void)? = nil, fail: ((String) -> Void)? = nil) {
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/login"
        let param: Parameters = [
            "account": account,
            "passwd": passwd
        ]
        
        let call = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
        call.responseJSON { res in
            
            let result = try! res.result.get()
            
            guard let jsonObject = result as? NSDictionary else {
                fail?("잘못된 응답 형식입니다: \(result)")
                return
            }
            
            let resultCode = jsonObject["result_code"] as! Int
            if resultCode == 0 {
                let user = jsonObject["user_info"] as! NSDictionary

                self.loginId = user["user_id"] as! Int
                self.account = user["account"] as? String
                self.name = user["name"] as? String

                if let path = user["profile_path"] as? String {
                    if let imageData = try? Data(contentsOf: URL(string: path)!) {
                        self.profile = UIImage(data: imageData)
                    }
                }
                
                //키체인
                let accessToken = jsonObject["access_token"] as! String
                let refreshToken = jsonObject["refresh_token"] as! String
                
                let tk = TokenUtils()
                tk.save("kr.co.rubypaper.MyMemory", account: "accessToken", value: accessToken)
                tk.save("kr.co.rubypaper.MyMemory", account: "refreshToken", value: refreshToken)
                
                success?()
                
            } else {
                let msg = (jsonObject["error_msg"] as? String) ?? "로그인이 실패했습니다"
                fail?(msg)
            }
        }
    }
    
    func logout() -> Bool {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: UserInfoKey.loginId)
        ud.removeObject(forKey: UserInfoKey.account)
        ud.removeObject(forKey: UserInfoKey.name)
        ud.removeObject(forKey: UserInfoKey.profile)
        ud.synchronize()
        return true
    }
    
    func logout2(completion: (() -> Void)? = nil) {
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/logout"
        
        //인증 헤더 구현
        let tokenUtils = TokenUtils()
        let header = tokenUtils.getAuthorizationHeader()
        
        let call = AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header)
        call.responseJSON { _ in
            self.deviceLogout()
            completion?()
        }
    }
    
    func deviceLogout() {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: UserInfoKey.loginId)
        ud.removeObject(forKey: UserInfoKey.account)
        ud.removeObject(forKey: UserInfoKey.name)
        ud.removeObject(forKey: UserInfoKey.profile)
        ud.synchronize()
        
        let tokenUtils = TokenUtils()
        tokenUtils.delete("kr.co.rubypaper.MyMemory", account: "accessToken")
        tokenUtils.delete("kr.co.rubypaper.MyMemory", account: "refreshToken")
    }
    
    func newProfile(_ profile: UIImage?, success: (() -> Void)? = nil, fail: ((String) -> Void)? = nil) {
        
        let url = "http://swiftapi.rubypaper.co.kr:2029/userAccount/profile"
        
        let tk = TokenUtils()
        let header = tk.getAuthorizationHeader()
        
        let profileData = profile?.pngData()?.base64EncodedString()
        let params: Parameters = ["profile_image": profileData!]
        
        let call = AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
        call.responseJSON { res in
            guard let jsonObject = try! res.result.get() as? NSDictionary else {
                fail?("올바른 응답값이 아닙니다")
                return
            }
            
            let resultcode = jsonObject["result_code"] as! Int
            if resultcode == 0 {
                self.profile = profile
                success?()
            } else {
                fail?(jsonObject["error_msg"] as? String ?? "이미지 프로필 변경에 실패했습니다")
            }
        }
    }
}
