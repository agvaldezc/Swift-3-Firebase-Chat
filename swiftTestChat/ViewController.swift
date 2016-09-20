//
//  ViewController.swift
//  swiftTestChat
//
//  Created by Alan Valdez on 9/19/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var loggedUser : FIRUser!
    var authReference : FIRAuth!
    var userID = "default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        authReference = FIRAuth.auth()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAnonimously(sender: UIButton) {
        authReference?.signInAnonymouslyWithCompletion() { (user, error) in
            if error != nil {
                print(error!.description)
                return
            }
            
            self.loggedUser = user
            self.performSegueWithIdentifier("loggedIn", sender: self)
        }
    }
}

