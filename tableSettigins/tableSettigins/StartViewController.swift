//
//  StartViewController.swift
//  tableSettigins
//
//  Created by Li on 1/6/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

 
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var token = Token() {
        didSet {
            DispatchQueue.main.async {
                self.loginTextField.text = ""
                self.passwordTextField.text = ""
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "tabBarController")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.text = "rct.lishanen"
        passwordTextField.text = "1721265"
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func buttonTapped(_ sender: Any) {
        let login = Login(login: loginTextField.text ?? "", pass: passwordTextField.text ?? "")
        let api = ApiRequest(endpoint: "user/login")
        api.login(login) { (result) in
            switch result {
            case.failure(let error) : print(error)
            case.success(let token) : self.token = token
            }
        }
    }
}
