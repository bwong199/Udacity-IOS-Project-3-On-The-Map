//
//  NavigationBarController.swift
//  Udacity On the Map
//
//  Created by Ben Wong on 2016-04-04.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit

class NavigationBarController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        
        
        
    }
    @IBAction func logout(sender: AnyObject) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.performSegueWithIdentifier("logoutSegue", sender: nil)
            }
        }
        task.resume()
    }
    
    
    @IBAction func addLocation(sender: AnyObject) {
        
        
//        "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt"
//        
//        let urlString = "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt"
//        let url = NSURL(string: urlString)
//        print(url)
//        let request = NSMutableURLRequest(URL: url!)
//        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        print(request)
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            if error != nil { /* Handle error */ return }
//            
//            if let data = data {
//                
//                let responseString = String(NSString(data: data, encoding: NSUTF8StringEncoding))
//                
//                // if link exists, edit link
//                if responseString.containsString(GlobalVariables.uniqueKey){
//                    print("link exists")
//                } else {
//                    print("link doesn't exist")
//                }
//                
//            }
//            
//        }
//        task.resume()
        
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.performSegueWithIdentifier("addLocationSegue", sender: nil)
        }
        
    }
    
    
    
}