//
//  ViewController.swift
//  Udacity On the Map
//
//  Created by Ben Wong on 2016-04-02.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        
        print(self.emailTextField.text)
        print(self.passwordTextField.text)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(self.emailTextField.text!)\", \"password\": \"\(self.passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            
            
            if error != nil { // Handle error…
                return
            }
            
            
            
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            let stringData = String(NSString(data: newData, encoding: NSUTF8StringEncoding)!)
            
            
            //            print(stringData)
            //
            if let data = stringData.dataUsingEncoding(NSUTF8StringEncoding) {
                do {
                    let json =   try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String:AnyObject]
                    
                    print(json)
                    
                    if let item = json["account"] as? NSObject {
                        print(item.valueForKey("key"))
                        
                        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/" + String(item.valueForKey("key")!))!)
                        let session = NSURLSession.sharedSession()
                        let task = session.dataTaskWithRequest(request) { data, response, error in
                            if error != nil { // Handle error...
                                return
                            }
                            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                            //                            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                            
                            do {
                                let json =   try NSJSONSerialization.JSONObjectWithData(newData, options: []) as! [String:AnyObject]
                                print(json)
                                if let item = json["user"] as? NSObject {
                                    print(item.valueForKey("first_name"))
                                    print(item.valueForKey("last_name"))
                                    
                                    GlobalVariables.firstName = String(item.valueForKey("first_name"))
                                    GlobalVariables.lastName = String(item.valueForKey("last_name"))
                                    
                                }
                                
                                //
                                
                            } catch let error as NSError {
                                print(error)
                            }
                            
                            
                            
                            
                        }
                        task.resume()
                        
                        //                        if let key = item["key"] as? String {
                        //                            print(key)
                        //                        }
                        
                        
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            
                        if(stringData.containsString("error") &&  stringData.containsString("400")){
                            print("Error")
                            dispatch_async(dispatch_get_main_queue(), {
                                let alertController = UIAlertController(title: nil, message:
                                    "Missing Email or Password", preferredStyle: UIAlertControllerStyle.Alert)
                                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
                                self.presentViewController(alertController, animated: true, completion: nil)
                            })
                        } else if (stringData.containsString("error") &&  stringData.containsString("403")){
                            print("Error")
                            dispatch_async(dispatch_get_main_queue(), {
                                let alertController = UIAlertController(title: nil, message:
                                    "Invalid Email or Password", preferredStyle: UIAlertControllerStyle.Alert)
                                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
                                self.presentViewController(alertController, animated: true, completion: nil)
                            })
                        } else {
                            print("No error")
            
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.performSegueWithIdentifier("toMapSegue", sender: nil)
                            }
                        }
                        
            
            
        }
        task.resume()
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toMapSegue"){
            //            let playViewController = segue.destinationViewController as! StudentLocationViewController
            //            playViewController.receivedAudio  = recordedAudio
        }
    }
    
}

