//
//  MyPageViewController.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/03.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var lblNickname: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblEmail.text = Share.userEmail
        lblNickname.text = Share.userNickName
    }
    
    
    @IBAction func btnUpdateUserinfo(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sgUpdateLocalUserinfo", sender: self)
    }
    

    @IBAction func btnLogout(_ sender: UIButton) {
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?", message: nil, preferredStyle: .alert)
        let no = UIAlertAction(title: "취소", style: .default, handler: nil)
        let yes = UIAlertAction(title: "확인", style: .destructive, handler: {ACTION in self.logout()})
        alert.addAction(no)
        alert.addAction(yes)
        
        present(alert, animated: true, completion: nil)
    }
    
    func logout(){
        UserDefaults.standard.set(nil, forKey: "email")
        UserDefaults.standard.set(nil, forKey: "nickname")
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
