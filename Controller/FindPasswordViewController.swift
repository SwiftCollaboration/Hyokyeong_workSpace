//
//  FindPasswordViewController.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/03.
//

import UIKit
import TextFieldEffects

class FindPasswordViewController: UIViewController {

    @IBOutlet weak var tfEmail: HoshiTextField!
    @IBOutlet weak var lblNotice: UILabel!
    var email = ""
    var tempPassword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBlankInLabel()
    }
    
    @IBAction func btnFindPassword(_ sender: UIButton) {

        if checkEmptyText(){
            let model = SignUpDuplicateCheckModel()
            model.isVaildItem(item: "email", content: email)
            model.delegate = self
        }
        
    }
    // DB 임시비밀번호로 업데이트
    func updateToTemporaryPassword() -> Bool{
        issueTemporaryPassword() // 임시 비밀번호 발급
        let model = FindPasswordModel()
        return model.updatePassword(email: email, password: tempPassword)
    }
    
    // 임시 비밀번호 이메일 전송
    func sendTemporaryPasswordToEmail() -> Bool{
        let model = FindPasswordModel()
        return model.sendEmail(email: email, password: tempPassword)
    }

    // 임시 비밀번호 발급 - 16자리
    func issueTemporaryPassword(){
        let num = 16 // 발급할 비밀번호 자릿수
        let temp = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        for _ in 0..<num{
            let random = Int(arc4random_uniform(UInt32(temp.count)))
            tempPassword += String(temp[temp.index(temp.startIndex, offsetBy: random)])
        }
    }
    
    // 텍스트필드 빈 값 체크
    func checkEmptyText()-> Bool{
        let checkEmail = tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if checkEmail?.count == 0{
            setBlankInLabel()
            lblNotice.text = "이메일을 입력해주세요."
            return false
        }else{
            email = checkEmail!
            return true
        }
    }
    
    // lblNotice 초기화
    func setBlankInLabel(){
        lblNotice.text = ""
    }
    
    // touch시 keyboard 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // alert
    func showCompleteAlert(){
        let alert = UIAlertController(title: "임시 비밀번호 발급", message: "이메일로 임시 비밀번호를 전송했습니다.\n마이페이지에서 비밀번호를 꼭 변경해주세요.", preferredStyle: .alert)
        let goToLogin = UIAlertAction(title: "로그인 하러 가기", style: .default, handler: {ACTION in self.navigationController?.popViewController(animated: true)})
        alert.addAction(goToLogin)
        present(alert, animated: true, completion: nil)
    }
    
    

} // FindPasswordViewController

extension FindPasswordViewController: SignUpDuplicateCheckProtocol{
    
    func duplicateCheck(result: String) {
        if result == "0"{
            setBlankInLabel()
            lblNotice.text = "등록되지 않은 이메일 입니다."
        }else{
            setBlankInLabel()
            // updatePassword
            if updateToTemporaryPassword(){
                // 이메일 보내기
                if sendTemporaryPasswordToEmail(){
                    showCompleteAlert()
                }
            }else{
                print("temp password update error")
            }
            
        }
    }
}

