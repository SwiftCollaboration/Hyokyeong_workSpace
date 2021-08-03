//
//  FindPasswordModel.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/03.
//

import Foundation

class FindPasswordModel{
    
    func updatePassword(email: String, password: String) -> Bool{
        
        var result : Bool = true
        var urlPath = "findPassword_UpdatePassword.jsp"
        let urlAdd = "?email=\(email)&password=\(password)"
        urlPath += urlAdd
        
        let share = Share();
        urlPath = share.url(urlPath)
        print(urlPath)
        
        // 한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to update data")
                result = false
            }else{
                print("Data is updated")
                result = true
            }
        }
        task.resume()
        return result
    }
    
    func sendEmail(email: String, password: String) -> Bool{
        
        var result : Bool = true
        var urlPath = "findPassword_SendEmail.jsp"
        let urlAdd = "?email=\(email)&password=\(password)"
        urlPath += urlAdd
        
        let share = Share();
        urlPath = share.url(urlPath)
        print(urlPath)
        
        // 한글 url encoding
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to send email")
                result = false
            }else{
                print("Email is sended")
                result = true
            }
        }
        task.resume()
        return result
    }
    
    
}
