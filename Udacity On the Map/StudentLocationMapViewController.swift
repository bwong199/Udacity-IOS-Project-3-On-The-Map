//
//  StudentLocationMapViewController.swift
//  Udacity On the Map
//
//  Created by Ben Wong on 2016-04-03.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var studentInformationList : [StudentInfo] = []
    
    var link = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        
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
                                
                                //
                                //                                print(firstName)
                                //                                print(lastName)
                                //                                print(latitude)
                                //                                print(longitude)
                                //                                print(mapString)
                                //                                print(link)
                                //                                print(" " )
                                //
                                let studentItem =
                                    
                                    StudentInfo(infoDict: ["firstName": firstName, "lastName": lastName, "latitude": latitude, "longitude":longitude, "mapString":mapString, "link": link])
                                
                                
                                
                                
                                self.studentInformationList.append(studentItem)
                                
                            }
                        }
                    }
                    self.do_map_refresh();
                    
                    //                    print(jsonResult)
                    
                } catch {
                    print("JSON Serialization failed")
                }
            }
        }
        task.resume()
    }
    
    func do_map_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            
            for x in self.studentInformationList {
                let latitudeAnn:CLLocationDegrees = Double(x.latitude)!
                let longitudeAnn:CLLocationDegrees = Double(x.longitude)!
                
                let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeAnn, longitudeAnn)
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = location
                annotation.title = x.firstName + " " + x.lastName
                annotation.subtitle = x.link
                
                self.mapView.addAnnotation(annotation)
            }
            return
        })
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        link = String((view.annotation!.subtitle!)!)
//        
//        print(link)
//        
//        if let requestUrl = NSURL(string: link) {
//            UIApplication.sharedApplication().openURL(requestUrl)
//        }
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
        }
        task.resume()
    }

    
}










