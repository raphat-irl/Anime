//
//  RegisterController.swift
//  Anime
//
//  Created by MacbookAir M1 FoodStory on 6/11/2565 BE.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class RegisterController:UIViewController {
    
    @IBOutlet weak var registerLabel:UILabel!
    @IBOutlet weak var bgaImage:UIImageView!
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var confirmpassword:UITextField!
    @IBOutlet weak var registerButton:UIButton!
    @IBOutlet weak var errorLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        errorLabel.alpha = 0
        
        registerButton.addTarget(self, action: #selector(registerBtnTapped), for: .touchUpInside)
    }
    
    func createAccount(email:String, password:String) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {
            [weak self] result, error in
            
            guard let strongSelf = self else {
                return
            }

            if error != nil {
                self?.showError("Error creating user")
            } else {
                let email = self!.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let password = self!.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let confirmPassword = self!.confirmpassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["e_mail": email,"password": password,"uid": result!.user.uid]) {
                    (err) in
                    if err != nil {
                        self?.showError("Error saving user data")
                    }
                }
                strongSelf.emailTextField.becomeFirstResponder()
                self!.transitionToMain()
            }
        })
    }
    
    @objc func registerBtnTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Missing field data")
            return
        }
        if let error = validateFields() {
            showError(error)
            return
        }
        createAccount(email: email, password: password)
    }

    func transitionToMain() {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "MainController") as? MainController
        
        view.window?.rootViewController = destinationVC
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
 
    func validateFields() -> String? {
        if passwordTextField.text?.count ?? 0 <= 8{
            return "Password need to be at lest 8 char"
        }
        
        //  Check that all fields are fill in
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //  Password isn't secure enought
            
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
        }
        return nil
    }
}
