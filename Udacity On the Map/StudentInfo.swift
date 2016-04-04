//
//  StudentInfo.swift
//  Udacity On the Map
//
//  Created by Ben Wong on 2016-04-04.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit

struct StudentInfo {
    var firstName = ""
    var lastName = ""
    var latitude = ""
    var longitude = ""
    var mapString = ""
    var link = ""
    
    init(infoDict: Dictionary<String, String>){
        self.firstName = (infoDict["firstName"])!
        self.lastName = infoDict["lastName"]!
        self.latitude = infoDict["latitude"]!
        self.longitude = infoDict["longitude"]!
        self.mapString = infoDict["mapString"]!
        self.link = infoDict["link"]!
    }
    
}

