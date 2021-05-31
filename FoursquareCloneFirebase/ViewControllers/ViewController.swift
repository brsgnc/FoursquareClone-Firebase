//
//  ViewController.swift
//  FoursquareCloneFirebase
//
//  Created by Barış Genç on 15.05.2021.
//  Copyright © 2021 BG. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailField.text != "" && passwordField.text != "" {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (result, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    //Segue
                    self.performSegue(withIdentifier: "toPlaceListVC", sender: nil)
                }
            }
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailField.text != "" && passwordField.text != "" {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (result, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    //Segue
                    self.performSegue(withIdentifier: "toPlaceListVC", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OKAction)
        present(alert, animated: true, completion: nil)
    }
}

