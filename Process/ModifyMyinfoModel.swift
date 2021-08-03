//
//  ModifyMyinfoModel.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/03.
//

import Foundation

protocol SelectMyInfoProtocol {
    func selectMyInfo(userData:NSMutableArray)
}

class ModifyMyinfoModel{
    
    var delegate: SelectMyInfoProtocol!
    
    func selectMyinfo(email: String){
        
        var urlPath = "myinfo_SelectUser.jsp"
        let urlAdd = "?email=\(email)"
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
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                 self.parseJson(data!)
            }
        }
        task.resume()
    }
    
    func parseJson(_ data: Data){
        var jsonResult = NSArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let userdata = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            if let email = jsonElement["email"] as? String,
               let password = jsonElement["password"] as? String,
               let nickname = jsonElement["nickname"] as? String,
               let phone = jsonElement["phone"] as? String,
               let babyage = jsonElement["babyage"] as? String,
               let rating = jsonElement["rating"] as? String,
               let signupdate = jsonElement["signupdate"] as? String,
               let signoutdate = jsonElement["signoutdate"] as? String{
                let query = UserDBModel(email: email, password: password, nickname: nickname, phone: phone, babyage: babyage, rating: rating, signupdate: signupdate, signoutdate: signoutdate)
                userdata.add(query)
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.selectMyInfo(userData: userdata)
        })
    }
    
    
    func updateMyinfo(email: String, password: String, nickname: String, phone: String, babyage: String) -> Bool{
        var result : Bool = true
        
        var urlPath = "myinfo_UpdateUser.jsp"
        let urlAdd = "?email=\(email)&password=\(password)&nickname=\(nickname)&phone=\(phone)&babyage=\(babyage)"
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
                print("Failed to insert data")
                result = false
            }else{
                print("Data is inserted")
                result = true
            }
        }
        task.resume()
        return result
    }
}
