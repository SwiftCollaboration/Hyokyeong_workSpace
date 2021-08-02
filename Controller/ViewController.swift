//
//  ViewController.swift
//  BebeLogin
//
//  Created by hyogang on 2021/08/02.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnKakao(_ sender: UIButton) {
    }
    
    @IBAction func btnNaver(_ sender: UIButton) {
    }
    
    @IBAction func btnGoogle(_ sender: UIButton) {
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sgLogin", sender: self)
    }
    
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sgSignUp", sender: self)
    }
    
}

