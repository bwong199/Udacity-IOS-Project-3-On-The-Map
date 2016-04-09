//
//  ViewController.swift
//  Udacity On the Map
//
//  Created by Ben Wong on 2016-04-02.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToKeyboardNotifications()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        subscribeToKeyboardNotifications()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        
        print(self.emailTextField.text)
        print(self.passwordTextField.text)
        
        FetchInfo().login(emailTextField.text!, password: passwordTextField.text!){(success, error, results) in
            if success {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.performSegueWithIdentifier("toMapSegue", sender: nil)
                }
                
            }
            
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: nil, message:
                        String(error!) , preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
            
        }
      
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toMapSegue"){
            
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "keyboardWillShow:" , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "keyboardWillHide:" , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //                view.frame.origin.y += getKeyboardHeight(notification)
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        if passwordTextField.editing {
            return keyboardSize.CGRectValue().height/4
        } else {
            return 0
        }
        
    }
    
}

