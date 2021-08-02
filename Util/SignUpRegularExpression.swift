//
//  SignUpRegularExpression.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/03.
//

import Foundation

// 회원가입 정규식
class SignUpRegularExpression{
    
    func isValidEmail(email: String) -> Bool{
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testing = NSPredicate(format: "SELF MATCHES %@", pattern)
        return testing.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool{
     
        let pattern = "(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
        let testing = NSPredicate(format: "SELF MATCHES %@", pattern)
        
        return testing.evaluate(with: password)
    }
    
    func isValidNickname(nickname: String) -> Bool{
        
        let pattern = "^([0-9]|[a-z]|[A-Z]|[가-힣]){2,6}$"
        let testing = NSPredicate(format: "SELF MATCHES %@", pattern)
        
        return testing.evaluate(with: nickname)
    }
    
    func isValidPhone(phone: String) -> Bool{
        let pattern = "^01(?:0|1|[6-9])+(?:[0-9]{3,4})+(?:[0-9]{4})$"
        let testing = NSPredicate(format: "SELF MATCHES %@", pattern)
        
        return testing.evaluate(with: phone)
    }

}
