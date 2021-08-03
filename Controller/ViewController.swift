//
//  ViewController.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/02.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import NaverThirdPartyLogin
import Alamofire
import GoogleSignIn
import AuthenticationServices


class ViewController: UIViewController {
    
    var apiEmail = ""
    var apiPassword = ""
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    let signInConfig = GIDConfiguration.init(clientID: "<#googleClientID#>")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 자동로그인
        if let userEmail = UserDefaults.standard.string(forKey: "email"){
            if let userNickname = UserDefaults.standard.string(forKey: "nickname"){
                Share.userEmail = userEmail
                Share.userNickName = userNickname
                self.performSegue(withIdentifier: "sgSocialLogin", sender: self)
            }
        }else{
            return
        }
        
    }
    
    
    @IBAction func btnKakao(_ sender: UIButton) {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                UserApi.shared.me() {(user, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("me() success.")
                        let email = String(user!.kakaoAccount!.email!)
                        let password = "kakao"
                        self.emailDuplicateCheck(email: email, password: password)
                    }
                }
                //do something
                //print(oauthToken)
            }
        }
    }
    
    @IBAction func btnNaver(_ sender: UIButton) {
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
    }
    
    // naver
    func getInfo() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        if !isValidAccessToken {
            return
        }

        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }

        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!

        let authorization = "\(tokenType) \(accessToken)"

        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])

        req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let email = object["email"] as? String else { return }
            let password = "naver"
            self.emailDuplicateCheck(email: email, password: password)
        }
    }
    
    @IBAction func btnGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }

            let email = user.profile?.email
            let password = "google"
            self.emailDuplicateCheck(email: email!, password: password)
        }
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sgLogin", sender: self)
    }
    
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sgSignUp", sender: self)
    }
    
    // API login 가입 여부 체크
    func emailDuplicateCheck(email:String, password:String){
        let model = SignUpDuplicateCheckModel()
        apiEmail = email
        apiPassword = password
        model.isVaildItem(item: "email", content: email)
        model.delegate = self
    }
    
    func socialLogin(){
        let model = LoginModel()
        model.loginResult(email: apiEmail, password: apiPassword)
        model.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgSosialSignUp"{
            let destinationView = segue.destination as! SignUpNicknameViewController
            destinationView.email = apiEmail
            destinationView.password = apiPassword
        }
    }
    
    
} // ViewController

// email 중복체크
extension ViewController: SignUpDuplicateCheckProtocol, LoginModelProtocol{
    func duplicateCheck(result: String) {
        if result == "0"{
            self.performSegue(withIdentifier: "sgSosialSignUp", sender: self)
        }else{
            socialLogin()
        }
    }
    
    func resultOfLogin(nickname: String) {
        //print(nickname)
        if nickname == "loginFail" || nickname == "loginError" {
            print("social login error")
        }else{
            Share.userEmail = apiEmail
            Share.userNickName = nickname
            self.performSegue(withIdentifier: "sgSocialLogin", sender: self)
        }
    }
}

// 네이버 로그인 관련
extension ViewController: NaverThirdPartyLoginConnectionDelegate {
    
  // 로그인에 성공했을 경우 호출
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    print("[Success] : Success Naver Login")
    getInfo()
  }
  
  // 접근 토큰 갱신
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
//    loginInstance?.requestAccessTokenWithRefreshToken()
  }
  
  // 로그아웃 할 경우 호출(토큰 삭제)
  func oauth20ConnectionDidFinishDeleteToken() {
        loginInstance?.requestDeleteToken()
    print("naver logout")
  }
  
  // 모든 Error
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
  }
}
