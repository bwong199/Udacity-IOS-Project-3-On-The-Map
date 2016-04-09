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
        
        let latitudeAnn:CLLocationDegrees = self.latitude
        let longitudeAnn:CLLocationDegrees = self.longitude
        
        
        let latDelta:CLLocationDegrees = 0.1
        let lonDelta:CLLocationDegrees = 0.1
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeAnn, longitudeAnn)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        
        self.mapView.addAnnotation(annotation)
        
        mapView.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
        
        //        self.performSegueWithIdentifier("toMapFromLinkAdd", sender: nil)
        
        let navigationViewController = self.navigationController?.viewControllers[0]
        
        self.navigationController?.popToViewController(navigationViewController!, animated: true)
    }
    
    @IBAction func submitLink(sender: AnyObject) {
        
        GlobalVariables.mediaURL = linkTextField.text!
        
        
        FetchInfo().submitLink(){(success, error, results) in
            if success {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.performSegueWithIdentifier("postLinkSegue", sender: nil)
                    
                }
                
                if (error != nil) {
                    dispatch_async(dispatch_get_main_queue(), {
                        let alertController = UIAlertController(title: nil, message:
                            "Posting Failed" , preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    })
                }
                
            }
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
}