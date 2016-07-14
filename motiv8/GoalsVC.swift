//
//  GoalsVC.swift
//  motiv8
//
//  Created by Okenla, Toheeb on 7/1/16.
//  Copyright © 2016 Okenla, Toheeb. All rights reserved.
//

import Foundation
import EventKit
import UIKit


class GoalsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var eventStore: EKEventStore!
    var reminders: [EKReminder]!
    var selectedReminder: EKReminder!
    
//    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        self.eventStore = EKEventStore()
        self.reminders = [EKReminder]()
        self.eventStore.requestAccessToEntityType(EKEntityType.Reminder) { (granted: Bool, error: NSError?) -> Void in
            
            if granted {
                let predicate = self.eventStore.predicateForRemindersInCalendars(nil)
                self.eventStore.fetchRemindersMatchingPredicate(predicate, completion: { (reminders: [EKReminder]?) -> Void in
                    
                    self.reminders = reminders
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.tableView.reloadData()
                        
                    }
                
                })
            } else {
                print("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @IBAction func editTable(sender: AnyObject) {
        tableView.editing = !tableView.editing
        if tableView.editing{
            tableView.setEditing(true, animated: true)
        }else{
            tableView.setEditing(false, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowGoalsDetails" {
            //mark
            print("at segue")
            let goalDetailsVC = segue.destinationViewController as! GoalsDetails
            goalDetailsVC.reminder = self.selectedReminder
            goalDetailsVC.eventStore = eventStore
        } else {
            print("at segue2")
            let newReminderVC = segue.destinationViewController as! NewGoal
            newReminderVC.eventStore = eventStore
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("reminderCell")
        let reminder:EKReminder! = self.reminders![indexPath.row]
        cell.textLabel?.text = reminder.title
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let dueDate = reminder.dueDateComponents?.date{
            cell.detailTextLabel?.text = formatter.stringFromDate(dueDate)
        }else{
            cell.detailTextLabel?.text = "N/A"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let reminder: EKReminder = reminders[indexPath.row]
        do{
            try eventStore.removeReminder(reminder, commit: true)
            self.reminders.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }catch{
            print("An error occurred while removing the reminder from the Calendar database: \(error)")
        }
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        self.selectedReminder = self.reminders[indexPath.row]
        self.performSegueWithIdentifier("ShowGoalsDetails", sender: self)
    }
}

