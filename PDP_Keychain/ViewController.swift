//
//  ViewController.swift
//  PDP_Keychain
//
//  Created by Galiev Aynur on 31.01.16.
//  Copyright © 2016 FlatStack. All rights reserved.
//

import UIKit

let defaultService = "_default_service_"
let defaultAccount = "_default_account_"

class ViewController: UIViewController {

    @IBOutlet weak var passwordLabel: UILabel!
    private var progressHUD: MBProgressHUD!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lPassword = SSKeychain.passwordForService(defaultService, account: defaultAccount) {
            self.passwordLabel.text = lPassword
        } else {
            self.passwordLabel.text = "Password is nil"
        }
        
        self.progressHUD = MBProgressHUD(view: self.view)
        self.progressHUD.labelText = "Progress..."
        self.progressHUD.detailsLabelText = "Detailed progress.."
        self.progressHUD.mode = MBProgressHUDMode.Determinate
        self.progressHUD.animationType = MBProgressHUDAnimation.Fade
        self.progressHUD.dimBackground = true
        self.view.addSubview(self.progressHUD)
    }
    
    @IBAction func save(sender: UIButton) {
        
        self.progressHUD.progress = 0.0
        self.progressHUD.showAnimated(true, whileExecutingBlock: { () -> Void in
            
            for var i=0; i<100000; i++ {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.progressHUD.progress = Float(i)/100000
                })
            }
        },
        onQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        completionBlock: { Void in
            SSKeychain.setPassword(self.passwordTextfield.text, forService: defaultService, account: defaultAccount)
            self.passwordLabel.text = SSKeychain.passwordForService(defaultService, account: defaultAccount)
        })
    }
    
    @IBAction func deletePassword(sender: UIButton) {
        
        if self.passwordTextfield.text == SSKeychain.passwordForService(defaultService, account: defaultAccount) {
            SSKeychain.deletePasswordForService(defaultService, account: defaultAccount)
        }
        self.passwordLabel.text = SSKeychain.passwordForService(defaultService, account: defaultAccount)
    }
}

