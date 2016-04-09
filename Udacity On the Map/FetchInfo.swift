//
//  FetchInfo.swift
//  Udacity On the Map
//
//  Created by Ben Wong on 2016-04-08.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit

class FetchInfo {
    
    func fetchInfo (completionHandler:(success: Bool, error: NSError?, results: [StudentInfo]) -> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){(data, response, error) -> Void in
            
            let dataString : String? = String(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            if dataString!.containsString("error"){
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: nil, message:
                        "Failed to Download Data", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    //                    self.presentViewController(alertController, animated: true, completion: nil)
                })
                
            }
            
            
            if let data = data {
                //                print(urlContent)
                
                do {
                    let jsonResult =  try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    
                    if jsonResult.count > 0 {
                        if let items = jsonResult["results"] as? NSArray {
                            
                            for item in items {
                                
                                let firstName = item["firstName"] as! String
                                
                                let lastName = item["lastName"] as! String
                                
                                let latitudeDouble = item["latitude"] as! Double
                                
                                let latitude = String(latitudeDouble)
                                
                                let longitudeDouble = item["longitude"] as! Double
                                
                                let longitude = String(longitudeDouble)
                                
                                let mapString = item["mapString"] as! String
                                
                                let linkType = item["mediaURL"] as! String
                                
                                let link = String(linkType)
                                let studentItem =
                                    
                                    StudentInfo(infoDict: ["firstName": firstName, "lastName": lastName, "latitude": latitude, "longitude":longitude, "mapString":mapString, "link": link])
                                
                                GlobalVariables.studentInformationList.append(studentItem)
                            }
                        }
                        
                        completionHandler(success: true, error: nil, results: GlobalVariables.studentInformationList)
                    }
                    //                    self.do_map_refresh();
                    
                    //                    print(jsonResult)
                    
                } catch {
                    print("JSON Serialization failed")
                }
            }
        }
        task.resume()
        
        
    }
    
    func login(email: String, password: String, completionHandler:(success: Bool, error: String?, results: String?) -> Void){
        print(email)
        print(password)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error…
                return
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            let stringData = String(NSString(data: newData, encoding: NSUTF8StringEncoding)!)
            
            
            //                        print(stringData)
            //
            if let data = stringData.dataUsingEncoding(NSUTF8StringEncoding) {
                do {
                    let json =   try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String:AnyObject]
                    
                    if let responseMessage = json["status"] as? NSObject {
                        print(json["error"]!)
                        
                        completionHandler(success: false, error: String(json["error"]!), results: String(json["error"]!))
                    }
                    
                    // allow access if account is fetched
                    if let item = json["account"] as? NSObject {
                        //                        print(item.valueForKey("key"))
                        
                        GlobalVariables.uniqueKey = String(item.valueForKey("key")!)
                        
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
                                //                                print(json)
                                if let item = json["user"] as? NSObject {
                                    print(item.valueForKey("first_name"))
                                    print(item.valueForKey("last_name"))
                                    
                                    GlobalVariables.firstName = String(item.valueForKey("first_name")!)
                                    GlobalVariables.lastName = String(item.valueForKey("last_name")!)
                                    
                                    completionHandler(success: true, error: nil, results: String(item))
                                    
                                }
                                
                            } catch let error as NSError {
                                print(error)
                            }
                        }
                        task.resume()
                        
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    func submitLink(completionHandler:(success: Bool, error: String?, results: String?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(GlobalVariables.uniqueKey)\", \"firstName\": \"\(GlobalVariables.firstName)\", \"lastName\": \"\(GlobalVariables.lastName)\",\"mapString\": \"\(GlobalVariables.mapString)\", \"mediaURL\": \"\(GlobalVariables.mediaURL)\",\"latitude\": \(GlobalVariables.latitude), \"longitude\": \(GlobalVariables.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(success: false, error: nil, results: nil)
                return
                    
//                    // Show alert message if posting failed
//                    dispatch_async(dispatch_get_main_queue(), {
//                        let alertController = UIAlertController(title: nil, message:
//                            "Posting Failed" , preferredStyle: UIAlertControllerStyle.Alert)
//                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
//                        
//                        self.presentViewController(alertController, animated: true, completion: nil)
//                    })
    
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            let postResponse = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            
            if postResponse.containsString("createdAt"){
//                NSOperationQueue.mainQueue().addOperationWithBlock {
//                    self.performSegueWithIdentifier("postLinkSegue", sender: nil)
//                }
                
                completionHandler(success: true, error: nil, results: nil)

            }
        }
        task.resume()
    }
}