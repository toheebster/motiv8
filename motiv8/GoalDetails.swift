//
//  GoalDetails.swift
//  motiv8
//
//  Created by Okenla, Toheeb on 7/12/16.
//  Copyright © 2016 Okenla, Toheeb. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import CoreData

// group 1 = <3.3
// group 2 = >3.3 & <6.6
// group 3 = >6.6 && < 1

class GoalsDetails: UIViewController {
    
    var goal: NSManagedObject?
    var goalToUpdate: NSManagedObject?
    
    var location = Int()
    var goals = [NSManagedObject]()
    var goalName = String()
    var goalDescription = String()
    var goalDate = NSDate()
    var goalDueDate: UIDatePicker!
    
    @IBOutlet var goalDateLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet var goalNameLabel: UILabel!
    
    // handle if a field is deleted
    @IBAction func saveGoal(sender: AnyObject) {
        
        goalToUpdate!.setValue(self.goalNameLabel!.text!, forKey: "goal_name")
        goalToUpdate!.setValue(self.descriptionLabel!.text!, forKey: "goal_description")
        goalToUpdate!.setValue(self.goalDueDate.date, forKey: "goal_due_date")
        
        let name = self.goalNameLabel!.text!
        let desc = self.descriptionLabel!.text!
        let date = self.goalDateLabel!.text!
        
        //change to name != "" && desc != "" && date != "" after testing
        if desc != "" && date != "" {
            do {
                try goalToUpdate!.managedObjectContext?.save()
                self.navigationController!.popViewControllerAnimated(true)
                self.navigationController?.setToolbarHidden(false, animated: false)
            } catch let error as NSError {
                print("Could not update \(error), \(error.userInfo)")
                //popup
            }
            
        } else {
            //popup
        }
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Goal")
        
        do {
            
            let results = try managedContext.executeFetchRequest(fetchRequest)
            goalToUpdate = results[location] as? NSManagedObject
            
        } catch let error as NSError {
            
            print("Could not fetch \(error), \(error.userInfo)")
            
        }

    }
    
    func addDate() {
        self.goalDateLabel.text = self.goalDueDate.date.description
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, MMMM, d, yyyy 'at' hh:mm a"
        
        self.goalNameLabel!.text! = self.goalName
        self.descriptionLabel!.text! = self.goalDescription
        
        goalDueDate = UIDatePicker()
        goalDueDate.date = self.goalDate
        goalDueDate.addTarget(self, action: #selector(GoalsDetails.addDate), forControlEvents: UIControlEvents.ValueChanged)
        goalDueDate.datePickerMode = UIDatePickerMode.DateAndTime
        goalDateLabel.inputView = goalDueDate
        descriptionLabel.becomeFirstResponder()
        
        self.goalDateLabel!.text! = formatter.stringFromDate(self.goalDueDate.date)
    }
    
    func passGoal(goal: NSManagedObject, location: Int) {
        goalName = (goal.valueForKey("goal_name") as? String)!
        goalDescription = (goal.valueForKey("goal_description") as? String)!
        goalDate = (goal.valueForKey("goal_due_date") as? NSDate)!
        self.goal = goal
        self.location = location
    }
    
    
}
