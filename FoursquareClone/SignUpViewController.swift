//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Yurii Sameliuk on 15/02/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import Parse

//WAŽNO!!! - 4tobu podklu4it Parse serwer smotri kod w AppDelegate!!!
// !!! - 4tobu pomnit awtorizacujy polzowatelia smotri kod w SceneDelegate!!!
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // sozdaem i daem imja nowoj  kolekcuji(kak y FireBase)
        //        let parseObject = PFObject(className: "Fruits")
        //        // zapisuwaem nowoe zna4enije
        //        parseObject["name"] = "Banana"
        //        parseObject["calories"] = 150
        //        // sochraniaem zapisanue danue
        //        parseObject.saveInBackground { (success, error) in
        //
        //            if error != nil {
        //                print("Error saveInBackground\(error?.localizedDescription) ")
        //
        //
        //            } else {
        //                print("Uploaded")
        //            }
        //        }
        // sozdaem i daem imja nowoj  kolekcuji(kak y FireBase)
        //        let query = PFQuery(className: "Fruits")
        //        // sozdaem filtr, kakie imenno dannue mu cho4em poly4it iz bazu
        //        query.whereKey("name", equalTo: "Apple")
        //        // poly4aem wse danue is bazu
        //        query.findObjectsInBackground { (objects, error) in
        //
        //            if error != nil {
        //                print(error?.localizedDescription)
        //            } else {
        //                print(objects)
        //            }
        //        }
        
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        if userNameText.text != "" && passwordText.text != "" {
            // wupolniaem wchod polzowatelia , kogga on yže imeet registracujy
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { (user, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error", prefferedStyle: UIAlertController.Style.alert)
                } else {
                    // Segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
            }
            
            
        } else {
            makeAlert(title: "Error", message: "Ussrname/Password", prefferedStyle: UIAlertController.Style.alert)
        }
        
        
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        if userNameText.text != "" && passwordText.text != "" {
            let user = PFUser()
            user.username = userNameText.text!
            user.password = passwordText.text!
            //registracuja nowogo polzowatelia
            user.signUpInBackground { (success, error) in
              
                    if error != nil {
                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error", prefferedStyle: UIAlertController.Style.alert)
                    } else {
                        // Segue
                        self.performSegue(withIdentifier: "toPlacesVC", sender: nil) 
                    }
                }
        
        } else {
            makeAlert(title: "Error", message: "Username/Password", prefferedStyle: UIAlertController.Style.alert)
        }
    }
    
    func makeAlert(title: String, message: String, prefferedStyle: UIAlertController.Style ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

