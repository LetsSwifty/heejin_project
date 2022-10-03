//
//  UserInfoManger.swift
//  MyMemory
//
//  Created by 김희진 on 2022/10/03.
//

import Foundation

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
    
    func logout() -> Bool {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: UserInfoKey.loginId)
        ud.removeObject(forKey: UserInfoKey.account)
        ud.removeObject(forKey: UserInfoKey.name)
        ud.removeObject(forKey: UserInfoKey.profile)
        ud.synchronize()
        return true
    }
}
