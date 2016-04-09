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
    
    //    var studentInformationList : [StudentInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        FetchInfo().fetchInfo(){(success, error, results) in
            if success {
                self.do_table_refresh()
            } else {
                
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        FetchInfo().fetchInfo(){(success, error, results) in
            if success {
                self.do_table_refresh()
            } else {
                
            }
        }
    }
    

    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalVariables.studentInformationList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell",
                                                               forIndexPath: indexPath) as! ItemCell
        
        cell.updateLabels()
        
        
        let info = GlobalVariables.studentInformationList[indexPath.row]
        
        cell.nameLabel.text = info.firstName + " " + info.lastName
        cell.linkLabel.text = info.link
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let link = GlobalVariables.studentInformationList[indexPath.row].link
        
        if let requestUrl = NSURL(string: link) {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
}