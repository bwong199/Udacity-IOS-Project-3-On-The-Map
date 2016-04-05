//
//  AddLinkViewController.swift
//  Udacity On the Map
//
//  Created by Ben Wong on 2016-04-04.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit
import MapKit

class AddLinkViewController: UIViewController , UITextFieldDelegate {
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    @IBOutlet var linkTextField: UITextField!
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.linkTextField.delegate = self
        
        //Testing Global variables
        
        //        print(GlobalVariables.firstName)
        //        print(GlobalVariables.lastName)
        //        print(GlobalVariables.latitude)
        //        print(GlobalVariables.longitude)
        //        print(GlobalVariables.mapString)
        //        print(GlobalVariables.uniqueKey)
        
        let latitudeAnn:CLLocationDegrees = self.latitude
        let longitudeAnn:CLLocationDegrees = self.longitude
        
        
        let latDelta:CLLocationDegrees = 0.01
        let lonDelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeAnn, longitudeAnn)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        
        self.mapView.addAnnotation(annotation)
        
        mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
        if((self.presentingViewController) != nil){
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }

    @IBAction func submitLink(sender: AnyObject) {
        
        GlobalVariables.mediaURL = linkTextField.text!
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(GlobalVariables.uniqueKey)\", \"firstName\": \"\(GlobalVariables.firstName)\", \"lastName\": \"\(GlobalVariables.lastName)\",\"mapString\": \"\(GlobalVariables.mapString)\", \"mediaURL\": \"\(GlobalVariables.mediaURL)\",\"latitude\": \(GlobalVariables.latitude), \"longitude\": \(GlobalVariables.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
                    
                    // Show alert message if posting failed
                    dispatch_async(dispatch_get_main_queue(), {
                        let alertController = UIAlertController(title: nil, message:
                            "Posting Failed" , preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    })
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            let postResponse = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            
            if postResponse.containsString("createdAt"){
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.performSegueWithIdentifier("postLinkSegue", sender: nil)
                }
            }
        }
        task.resume()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        
        return true
    }
}