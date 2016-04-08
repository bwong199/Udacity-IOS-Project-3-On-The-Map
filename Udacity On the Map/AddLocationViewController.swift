//
//  AddLocationViewController.swift
//  Udacity On the Map
//
//  Created by Ben Wong on 2016-04-04.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var locationTextField: UITextField!
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationTextField.delegate = self
        
        
    }
    
    @IBAction func findLocation(sender: AnyObject) {
        
        let address = locationTextField.text as String?
        
        GlobalVariables.mapString = address!
        
        let geocoder = CLGeocoder()
        
        if let addressExist = address {
            geocoder.geocodeAddressString(addressExist, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error)
                    // Alert error if result is nil
                    let alertController = UIAlertController(title: nil, message:
                        "Cannot Find Location. Please Try Again!" , preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)

                }
                if let placemark = placemarks?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    print(coordinates.latitude)
                    print(coordinates.longitude)
                    
                    self.latitude = coordinates.latitude
                    self.longitude = coordinates.longitude
                    
                    GlobalVariables.latitude = coordinates.latitude
                    GlobalVariables.longitude = coordinates.longitude

                    
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.performSegueWithIdentifier("toAddLinkSegue", sender: nil)
                    }
                }
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toAddLinkSegue"){
                        let linkViewController = segue.destinationViewController as!
                            AddLinkViewController
                        linkViewController.latitude  = self.latitude
                        linkViewController.longitude = self.longitude
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        
        return true
    }
    


    @IBAction func cancelButton(sender: AnyObject) {
        self.performSegueWithIdentifier("toMapfromLocationAdd", sender: nil)
        
    }

}