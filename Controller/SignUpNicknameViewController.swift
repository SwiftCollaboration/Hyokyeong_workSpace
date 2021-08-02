//
//  SignUpNicknameViewController.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/02.
//

import UIKit
import TextFieldEffects

class SignUpNicknameViewController: UIViewController {
    
    var email = ""
    var password = ""
    
    // textfield
    @IBOutlet weak var tfNickname: HoshiTextField!
    @IBOutlet weak var tfPhone: HoshiTextField!
    @IBOutlet weak var tfBabyage: HoshiTextField!
    lazy var tfInput : [HoshiTextField] = [tfNickname, tfPhone, tfBabyage]
    let textFieldArr = ["닉네임", "휴대폰 번호", "아기 나이"]
    var dbInputText : [String] = []

    // label
    @IBOutlet weak var lblNickname: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblBabyage: UILabel!
    lazy var lblNotice : [UILabel] = [lblNickname, lblPhone, lblBabyage]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        view.endEditing(true)
        setBlankInLabel()
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
    
    
    
    // 회원가입 button click event
    @IBAction func btnSignUp(_ sender: UIButton) {
        if checkEmptyText(){ // 1. 빈 값 체크
            if checkRegularExpression(){ // 2. 정규식 확인
                let duplicateCheckModel = SignUpDuplicateCheckModel()
                duplicateCheckModel.isVaildItem(item: "nickname", content: dbInputText[0])
                duplicateCheckModel.delegate = self // 3. nickname 중복 확인
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
                if regularExpression.isValidNickname(nickname: dbInputText[i]){
                    continue
                }else{
                    setBlankInLabel()
                    lblNotice[i].text = "닉네임은 2-6자 이내의 문자와 숫자만 입력해주세요."
                    tfInput[i].becomeFirstResponder()
                    return false
                }
            case 1:
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
    
    // DB : insert user
    func dbInsertUser() -> Bool {
        let insertUser = SignUpModel()
        let result = insertUser.insertUser(email: email, password: password, nickname: dbInputText[0], phone: dbInputText[1], babyage: dbInputText[2])
        return result
    }

} // SignUpNicknameViewController

extension SignUpNicknameViewController: SignUpDuplicateCheckProtocol{
    func duplicateCheck(result: String) {
        if result == "0"{
            if dbInsertUser(){
                Share.userEmail = email
                Share.userNickName = dbInputText[0]
                let resultAlert = UIAlertController(title: "가입 완료", message: "가입을 축하드립니다...", preferredStyle: .alert)
                let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                    self.performSegue(withIdentifier: "sgSignUpSuccess", sender: self)
                })
                resultAlert.addAction(onAction)
                present(resultAlert, animated: true, completion: nil)
            }else{
                let resultAlert = UIAlertController(title: "실패", message: "에러가 발생했습니다.", preferredStyle: .alert)
                let onAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                resultAlert.addAction(onAction)
                present(resultAlert, animated: true, completion: nil)
            }
        }else{
            setBlankInLabel()
            lblNickname.text = "이미 사용중인 닉네임 입니다."
        }
    }
}
