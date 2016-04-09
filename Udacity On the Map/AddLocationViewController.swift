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
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        self.locationTextField.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        subscribeToKeyboardNotifications()
        
    }
    
    @IBAction func findLocation(sender: AnyObject) {
        
        self.activityIndicator.hidden = false
        activityIndicator.color = UIColor.whiteColor()
        activityIndicator.startAnimating()
        
        let address = locationTextField.text as String?
        
        GlobalVariables.mapString = address!
        
        let geocoder = CLGeocoder()
        
        if let addressExist = address {
            geocoder.geocodeAddressString(addressExist, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error)
                    // Alert error if result is nil
                    self.activityIndicator.stopAnimating()
                    let alertController = UIAlertController(title: nil, message:
                        "Cannot Find Location. Please Try Again!" , preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                if let placemark = placemarks?.first {
                    self.activityIndicator.stopAnimating()
                    
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
//        self.performSegueWithIdentifier("toMapfromLocationAdd", sender: nil)
        
        let navigationViewController = self.navigationController?.viewControllers[0]
        
        self.navigationController?.popToViewController(navigationViewController!, animated: true)
        
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
        //        view.frame.origin.y += getKeyboardHeight(notification)
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        if locationTextField.editing {
            return keyboardSize.CGRectValue().height/2
        } else {
            return 0
        }
        
    }
}