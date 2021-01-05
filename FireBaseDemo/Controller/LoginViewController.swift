//
//  LoginViewController.swift
//  FireBaseDemo
//
//  Created by Knoxpo MacBook Pro on 04/01/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
  
  // MARK: Constants
  let loginToList = "LoginToList"
  
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
   /* Auth.auth().addStateDidChangeListener() { auth, user in
      if user != nil {
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
        self.textFieldLoginEmail.text = nil
        self.textFieldLoginPassword.text = nil
      }
    }
    */
    
    
  
    
    
    
    
    
  }
    
    
    
    
    
  
 
    
    @IBAction func loginDidTouch(_ sender: AnyObject){
        
        guard
            let email = textFieldLoginEmail.text,
            let password = textFieldLoginPassword.text,
            email.count > 0,
            password.count > 0
        else{
            return
            
        }
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil{
              
              //  self.performSegue(withIdentifier: self.loginToList, sender: nil)
                // self.textFieldLoginEmail.text = nil
                //  self.textFieldLoginPassword.text = nil
                
               let alert = UIAlertController(title: "Sign in fail", message: "Fail to login", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
               self.present(alert, animated: true, completion: nil)
            }
            else{
                
                
            
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
                 self.textFieldLoginEmail.text = nil
                  self.textFieldLoginPassword.text = nil
            }
            
            
            
        }
        
      
    }
    
    
    
    
    
    


@IBAction func signUpDidTouch( _ sender : AnyObject)
{
let alert = UIAlertController(title: "Register", message: "welcome to login", preferredStyle: .alert)
    let saveaction = UIAlertAction(title: "Save", style: .default){ _ in
        
        
        let emailtextfeild = alert.textFields![0]
        
        let passwordfeild = alert.textFields![1]
        Auth.auth().createUser(withEmail: emailtextfeild.text!, password: passwordfeild.text!){ user,error in
            
            if error == nil{
                
                Auth.auth().signIn(withEmail: self.textFieldLoginEmail.text!, password: self.textFieldLoginPassword.text!)
            
            }
         
        }
     
    }
 let cancelAction = UIAlertAction(title:"Cancel", style: .default)
    alert.addTextField { emailtextfeild in
        emailtextfeild.placeholder = "add email"
    
    }
    alert.addTextField { passwordfeild in
        passwordfeild.placeholder = "add password"
     
    }
    alert.addAction(saveaction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
    
}
    
 
    
    
    
    
}
/*extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFieldLoginEmail {
      textFieldLoginPassword.becomeFirstResponder()
    }
    if textField == textFieldLoginPassword {
      textField.resignFirstResponder()
    }
    return true
  }
}
*/

extension LoginViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textFeild: UITextField) -> Bool

    {
        if textFeild == textFieldLoginEmail{
            
            textFieldLoginPassword.becomeFirstResponder()
            
        }
        
        if textFeild == textFieldLoginPassword{
            
            textFeild.resignFirstResponder()
        }
        return true
    }
    
    
}












