//
//  LoginViewController.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/02.
//

import UIKit
import TextFieldEffects

class LoginViewController: UIViewController {

    // textfield
    @IBOutlet weak var tfEmail: HoshiTextField!
    @IBOutlet weak var tfPassword: HoshiTextField!
    lazy var tfInput : [HoshiTextField] = [tfEmail, tfPassword]
    let textFieldArr = ["이메일", "비밀번호"]
    var dbInputText : [String] = []
    
    // label
    @IBOutlet weak var lblNotice: UILabel!
    
    // password button
    @IBOutlet weak var btnShowPassword: UIButton!
    let showPassword = UIImage(systemName: "eye.fill")
    let hidePassword = UIImage(systemName: "eye.slash.fill")
    var isShowPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.endEditing(true)
        
        setBlankInLabel()
        
        // setting hide password button
        btnShowPassword.setImage(hidePassword, for: .normal)
        tfPassword.isSecureTextEntry = true
        isShowPassword = false
    }
    
    // password button click event
    @IBAction func btnPasswordAction(_ sender: UIButton) {
        if isShowPassword{
            btnShowPassword.setImage(hidePassword, for: .normal)
            tfPassword.isSecureTextEntry = true
            isShowPassword = false
        }else{
            btnShowPassword.setImage(showPassword, for: .normal)
            tfPassword.isSecureTextEntry = false
            isShowPassword = true
        }
    }
    
    // login button click event
    @IBAction func btnLogin(_ sender: UIButton) {
        if checkEmptyText(){
            let model = LoginModel()
            model.loginResult(email: dbInputText[0], password: dbInputText[1])
            model.delegate = self
        }
    }
    
    // findPassword button click event
    @IBAction func btnFindPassword(_ sender: UIButton) {
    }
    
    
    // text 공백 체크
    func checkEmptyText()-> Bool{
        dbInputText.removeAll()
        for i in 0..<tfInput.count{
            if tfInput[i].text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
                setBlankInLabel()
                lblNotice.text = "\(textFieldArr[i])을 입력해주세요."
                tfInput[i].becomeFirstResponder()
                return false
            }else{
                let input = tfInput[i].text?.trimmingCharacters(in: .whitespacesAndNewlines)
                dbInputText.append(input!)
                print(dbInputText[i])
            }
        }
        return true
    }
    
    // lblNotice 초기화
    func setBlankInLabel(){
        lblNotice.text = ""
    }
    
    // touch시 keyboard 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


} // LoginViewController

extension LoginViewController: LoginModelProtocol {
    
    func resultOfLogin(nickname: String) {
        //print(nickname)
        if nickname == "loginFail" || nickname == "loginError" {
            lblNotice.text = "이메일 혹은 비밀번호가 일치하지 않습니다."
        }else{
            Share.userEmail = dbInputText[0]
            Share.userNickName = nickname

            self.performSegue(withIdentifier: "sgLoginSuccess", sender: self)
        }
    }
}
