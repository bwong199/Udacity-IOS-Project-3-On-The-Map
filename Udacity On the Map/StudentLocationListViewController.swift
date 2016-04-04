//
//  StudentLocationViewController.swift
//  Udacity On the Map
//
//  Created by Ben Wong on 2016-04-03.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit

class StudentLocationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var studentInformationList : [StudentInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
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
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
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
                                
                                
                                self.studentInformationList.append(studentItem)
                                
                                
                            }
                            
                        }
                        
                    }
                    self.do_table_refresh();
                    
                    
                } catch {
                    print("JSON Serialization failed")
                }
            }
            
        }
        
        task.resume()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentInformationList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell",
                                                               forIndexPath: indexPath) as! ItemCell
        
        cell.updateLabels()
        
        
        let info = self.studentInformationList[indexPath.row]
        
        cell.nameLabel.text = info.firstName + " " + info.lastName
        cell.linkLabel.text = info.link
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let link = studentInformationList[indexPath.row].link
        
        if let requestUrl = NSURL(string: link) {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
}