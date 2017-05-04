//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by knax on 4/23/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var appleReachability = OTMap_NetworkReachability(hostName: "www.appple.com")
    var reachability: OTMap_NetworkReachability? = OTMap_NetworkReachability.networkReachabilityForInternetConnection()

    
    @IBOutlet weak var emailAccount: UITextField!
    @IBOutlet weak var userPwd: UITextField!
    
    @IBOutlet weak var missingLoginNameLabel: UILabel!
    @IBOutlet weak var missingPasswordLabel: UILabel!
    
    
    var emailAccountText: String? = nil
    var userPwdText: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        _ = reachability?.startNotifier()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            checkReachability()
        
        missingLoginNameLabel.isHidden = true
        missingPasswordLabel.isHidden = true
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
    }

    
    @IBAction func signUP(_ sender: UIButton) {
        
        
    }
    
    
    
    //check textField for input and add 1 for each textField meets base input requirement
    var textFieldRequirementVal = 2
    @IBAction func udacityAuthLogin(_ sender: AnyObject) {
        
        emailAccountText = emailAccount.text!
        userPwdText = userPwd.text!

       
        
            OTMap_Tasks.sharedInstance().udacityAuthLogin(emailAccountText!, userPwdText!) { (success, errorString) in
                performUpdatesOnMainQueue {
                    if success {
                        self.completeLogin()
                    } else {
                        if self.presentedViewController != nil {
                            //self.dismiss(animated: true, completion: nil)
                            //surpress warning message
                        }
                        else {
                            let actionSheet = UIAlertController(title: "ERROR", message: "\(errorString!)", preferredStyle: .alert)
                            
                            
                            
                            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                            self.present(actionSheet,animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    
        func completeLogin(){
            let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            present(controller, animated: true, completion: nil)
        }

            
        }

extension LoginViewController {
    
    //network reachability
    
    func checkReachability() {
        guard let r = reachability else { return }
        
        if r.isReachable {
            view.backgroundColor = UIColor.green
        } else {
            view.backgroundColor = UIColor.red
        }
    }
    
    
    func reachabilityDidChange(_ notification: Notification){
        checkReachability()
    }
}




