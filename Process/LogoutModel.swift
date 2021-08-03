//
//  LogoutModel.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/03.
//

import Foundation
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import AuthenticationServices

class LogoutModel{
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
//        var delegate: LoginModelProtocol!
    
    var loginType = ""
    
    func selectLoginType(email:String){
        var urlPath = "logout_SelectLoginType.jsp"
        let urlAdd = "?email=\(email)"
        urlPath += urlAdd

        let share = Share();
        urlPath = share.url(urlPath)

        // 한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        let url: URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                //let loginresult = String(decoding: data!, as: UTF8.self)
                self.checkLoginType(data: data!)
            }
        }
        task.resume()
    }
    
    func checkLoginType(data: Data){
        var json = ["":""]
        do {
            json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:String]
        }catch let  error as NSError{
            print(error)
        }
        let type = json["type"]!
//        DispatchQueue.main.async(execute: {() -> Void in
//            self.delegate.resultOfLogin(nickname: nickname)
//        })
        switch type {
        case "naver":
            naverLogout()
            break
        case "kakao":
            kakaoLogout()
            break
        case "google":
            googleLogout()
            break
        default:
            UserDefaults.standard.set(nil, forKey: "email")
            UserDefaults.standard.set(nil, forKey: "nickname")
            print("local logout")
            break
        }
    }
    
    func naverLogout(){
        loginInstance?.requestDeleteToken()
    }
    
    func kakaoLogout(){
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("kakao logout success.")
            }
        }
    }
    
    func googleLogout(){
        GIDSignIn.sharedInstance.disconnect { error in
            guard error == nil else { return }
            print("google logout")
            // Google Account disconnected from your app.
            // Perform clean-up actions, such as deleting data associated with the
            //   disconnected account.
        }
    }
    
}
