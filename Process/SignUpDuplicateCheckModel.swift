//
//  SignUpDuplicateCheckModel.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/03.
//

import Foundation

protocol SignUpDuplicateCheckProtocol{
    func duplicateCheck(result:String)
}

class SignUpDuplicateCheckModel{
    
    var delegate : SignUpDuplicateCheckProtocol!
    
    func isVaildItem(item:String, content:String){
        
        var urlPath = "signUpDuplicateCheck.jsp"
        let urlAdd = "?\(item)=\(content)"
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
                //let loginresult = String(decoding: data!, as: UTF8.self)
                 self.convertCheckItem(data: data!)
            }
        }
        task.resume()
    }
    
    
    func convertCheckItem(data: Data){
        var json = ["":""]
        do {
            json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:String]
        }catch let  error as NSError{
            print(error)
        }
        let result = json["result"]!
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.duplicateCheck(result: result)
        })
    }
}
