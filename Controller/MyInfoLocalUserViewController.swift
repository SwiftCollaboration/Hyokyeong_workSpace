//
//  MyInfoViewController.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/03.
//

import UIKit
import TextFieldEffects

class MyInfoLocalUserViewController: UIViewController {

    let email = Share.userEmail
    
    @IBOutlet weak var lblMyNickname: UILabel!
    
    // textField
    @IBOutlet weak var tfEmail: HoshiTextField!
    @IBOutlet weak var tfPassword: HoshiTextField!
    @IBOutlet weak var tfNickname: HoshiTextField!
    @IBOutlet weak var tfPhone: HoshiTextField!
    @IBOutlet weak var tfBabyage: HoshiTextField!
    lazy var tfInput : [HoshiTextField] = [tfPassword, tfNickname, tfPhone]
    let textFieldArr = ["비밀번호", "닉네임", "휴대폰 번호"]
    var dbInputText : [String] = []
    
    // label
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblNickname: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    lazy var lblNotice : [UILabel] = [lblPassword, lblNickname, lblPhone]

    // password button
    @IBOutlet weak var btnShowPassword: UIButton!
    let showPassword = UIImage(systemName: "eye.fill")
    let hidePassword = UIImage(systemName: "eye.slash.fill")
    var isShowPassword = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let model = ModifyMyinfoModel()
        model.selectMyinfo(email: Share.userEmail)
        model.delegate = self
        
        view.endEditing(true)
        
        setBlankInLabel()
        
        // setting hide password button
        btnShowPassword.setImage(hidePassword, for: .normal)
        tfPassword.isSecureTextEntry = true
        isShowPassword = false
        
        // setting label and textField
        lblMyNickname.text = Share.userNickName
        lblMyNickname.sizeToFit()

        tfEmail.text = email
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
    
    // 아기 나이 선택
    @IBAction func tfChoiceBabyage(_ sender: HoshiTextField) {
        self.view.endEditing(true)
        let babyage = UIAlertController(title: "선택", message: "아기 나이를 선택 해 주세요.", preferredStyle: .alert)
        let age0 = UIAlertAction(title: "없음", style: .default, handler: {ACTION in self.choiceBabyage(babyage: 0)})
        let age1 = UIAlertAction(title: "12개월", style: .default, handler: {ACTION in self.choiceBabyage(babyage: 1)})
        let age2 = UIAlertAction(title: "24개월", style: .default, handler: {ACTION in self.choiceBabyage(babyage: 2)})
        let age3 = UIAlertAction(title: "36개월", style: .default, handler: {ACTION in self.choiceBabyage(babyage: 3)})

        babyage.addAction(age0)
        babyage.addAction(age1)
        babyage.addAction(age2)
        babyage.addAction(age3)

        present(babyage, animated: true, completion: nil)
    }
    
    // 아기 나이 선택
    func choiceBabyage(babyage:Int){
        switch babyage {
        case 1:
            tfBabyage.text = "12개월"
            break
        case 2:
            tfBabyage.text = "24개월"
            break
        case 3:
            tfBabyage.text = "36개월"
            break
        default:
            tfBabyage.text = "없음"
            break
        }
    }
    
    // update myinfo button click event
    @IBAction func btnUpdateMyInfo(_ sender: UIButton) {
        if checkEmptyText(){
            if checkRegularExpression(){
                let model = SignUpDuplicateCheckModel()
                model.isVaildItem(item: "nickname", content: dbInputText[1])
                model.delegate = self
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
                if regularExpression.isValidPassword(password: dbInputText[i]){
                    continue
                }else{
                    setBlankInLabel()
                    lblNotice[i].text = "비밀번호는 8-20자 이내의 문자와 숫자를 포함하여 입력해주세요."
                    tfInput[i].becomeFirstResponder()
                    return false
                }
            case 1:
                if regularExpression.isValidNickname(nickname: dbInputText[i]){
                    continue
                }else{
                    setBlankInLabel()
                    lblNotice[i].text = "닉네임은 2-6자 이내의 문자와 숫자만 입력해주세요."
                    tfInput[i].becomeFirstResponder()
                    return false
                }
            case 2:
                if regularExpression.isValidPhone(phone: dbInputText[i]){
                    continue
                }else{
                    setBlankInLabel()
                    lblNotice[i].text = "휴대폰 번호 형식이 올바르지 않습니다."
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
    
    // DB : update user
    func dbUpdateUser(){
        let password = dbInputText[0]
        let nickname = dbInputText[1]
        let phone = dbInputText[2]
        let babyage = tfBabyage.text!
        
        let model = ModifyMyinfoModel()
        let result = model.updateMyinfo(email: email, password: password, nickname: nickname, phone: phone, babyage: babyage)
        
        if result {
            Share.userNickName = nickname
            let resultAlert = UIAlertController(title: "내 정보 수정 완료", message: nil, preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in self.viewWillAppear(true)})
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }else{
            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생했습니다.", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: nil)

            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }
    }

    
}// MyInfoLocalUserViewController

extension MyInfoLocalUserViewController: SignUpDuplicateCheckProtocol{
    func duplicateCheck(result: String) {
        if result == "0"{
            dbUpdateUser()
        }else{
            setBlankInLabel()
            lblNickname.text = "이미 사용중인 닉네임 입니다."
        }
    }
}

// select user
extension MyInfoLocalUserViewController: SelectMyInfoProtocol{
    func selectMyInfo(userData: NSMutableArray) {
        
        let user: UserDBModel = userData[0] as! UserDBModel
        
        tfPassword.text = user.password!
        tfNickname.text = user.nickname!
        tfPhone.text = user.phone!
        tfBabyage.text = user.babyage!
    }
}
