//
//  LoginController.swift
//  Anime
//
//  Created by MacbookAir M1 FoodStory on 4/11/2565 BE.
//

import Foundation
import FirebaseAuth

class LoginController: UIViewController {
    @IBOutlet weak var logoImage:UIImageView!
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var registerButton:UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    func setUpView(){
        errorLabel.alpha = 0
        
        loginButton.addTarget(self, action: #selector(didLoginBtnTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didRegisterBtnTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            emailTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - LoginBtntapped
    
    @objc private func didLoginBtnTapped(){
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {

            errorLabel.alpha = 1
            errorLabel.text = "Email and Password Field are empty"
            
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password,
                                        completion: { [weak self] result, error  in
            guard let strongSelf = self else{
                return
                
            }
            
            if error != nil {
                self!.errorLabel.text = error!.localizedDescription
                self!.errorLabel.alpha = 1
            } else {
                let appPreference = AppPreference()
                appPreference.setValueString(AppPreference.email, value: email)
                appPreference.synchronize()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let destivationVc = storyboard.instantiateViewController(withIdentifier: "MainController")
                    as? MainController{
                    
                    self?.navigationController?.pushViewController(destivationVc, animated: true)
                }
            }
            strongSelf.emailTextField.becomeFirstResponder()
        })
    }
    
    //MARK: - RegisterBtntapped
    
    @objc private func didRegisterBtnTapped(){
        changetoregisterView()
    }
    
    func changetoregisterView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "RegisterController") as? RegisterController{
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
