//
//  LoginModel.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/03.
//

import Foundation

protocol LoginModelProtocol{
    func resultOfLogin(nickname:String)
}

class LoginModel{
    var delegate: LoginModelProtocol!

    func loginResult(email: String, password: String){

        var urlPath = "login.jsp"
        let urlAdd = "?email=\(email)&password=\(password)"
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
                 self.convertLoginResultToDictonary(data: data!)
            }
        }
        task.resume()
    }
    
    
    func convertLoginResultToDictonary(data: Data){
        
        var json = ["":""]
        do {
            json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:String]
        }catch let  error as NSError{
            print(error)
        }
        let nickname = json["nickname"]!
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.resultOfLogin(nickname: nickname)
        })
    }
}
