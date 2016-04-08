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
}