//
//  SignUpEmailViewController.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/02.
//

import UIKit
import TextFieldEffects

class SignUpEmailViewController: UIViewController {

    // textfield
    @IBOutlet weak var tfEmail: HoshiTextField!
    @IBOutlet weak var tfPassword: HoshiTextField!
    lazy var tfInput : [HoshiTextField] = [tfEmail, tfPassword]
    let textFieldArr = ["이메일", "비밀번호"]
    var dbInputText : [String] = []
    
    // lable
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    lazy var lblNotice : [UILabel] = [lblEmail, lblPassword]
    
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
    
    // next button click event
    @IBAction func btnNext(_ sender: UIButton) {
        if checkEmptyText(){ // 1. 빈 값 체크
            if checkRegularExpression(){ // 2. 정규식 확인
                let model = SignUpDuplicateCheckModel()
                model.isVaildItem(item: "email", content: dbInputText[0])
                model.delegate = self // 3. email 중복 확인
            }
        }
    }
    
    
    // text 공백 체크
    func checkEmptyText()-> Bool{
        dbInputText.removeAll()
        for i in 0..<tfInput.count{
            if tfInput[i].text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
                setBlankInLabel()
                lblNotice[i].text = "\(textFieldArr[i])을 입력해주세요."
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
    
    // 정규식 체크
    func checkRegularExpression() -> Bool {
        let regularExpression = SignUpRegularExpression()
        
        for i in 0..<dbInputText.count{
            switch i {
            case 0:
                if regularExpression.isValidEmail(email: dbInputText[i]){
                    continue
                }else{
                    setBlankInLabel()
                    lblNotice[i].text = "이메일 형식이 올바르지 않습니다."
                    tfInput[i].becomeFirstResponder()
                    return false
                }
            case 1:
                if regularExpression.isValidPassword(password: dbInputText[i]){
                    continue
                }else{
                    setBlankInLabel()
                    lblNotice[i].text = "비밀번호는 8-20자 이내의 문자와 숫자를 포함하여 입력해주세요."
                    tfInput[i].becomeFirstResponder()
                    return false
                }
            default:
                continue
            }
        }
        return true
    }

    // lblNotice 초기화
    func setBlankInLabel(){
        for i in 0..<lblNotice.count{
            lblNotice[i].text = ""
        }
    }
    
    // touch시 keyboard 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // SignUpNicknameViewController로 Email, Password 값 넘기기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgSignUp2"{
            let destinationView = segue.destination as! SignUpNicknameViewController
            destinationView.email = dbInputText[0]
            destinationView.password = dbInputText[1]
        }
    }
    
}

extension SignUpEmailViewController: SignUpDuplicateCheckProtocol{
    func duplicateCheck(result: String) {
        if result == "0"{
            self.performSegue(withIdentifier: "sgSignUp2", sender: self)
        }else{
            setBlankInLabel()
            lblEmail.text = "이미 사용중인 이메일 입니다."
        }
    }
}
