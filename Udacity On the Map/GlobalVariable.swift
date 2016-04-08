//
//  GlobalVariable.swift
//  Udacity On the Map
//
//  Created by Ben Wong on 2016-04-04.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit

struct GlobalVariables {
    static var firstName : String = ""
    static var lastName : String = ""
    static var mapString : String = ""
    static var mediaURL : String = ""
    static var latitude : Double = 0
    static var longitude : Double = 0
    static var uniqueKey : String = ""
    
    static var studentInformationList : [StudentInfo] = []

    
    // prevent instantiation of this class
    private init()
    {
        // initializer code here
    }
}