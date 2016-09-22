//
//  NewGoal.swift
//  motiv8
//
//  Created by Okenla, Toheeb on 7/12/16.
//  Copyright © 2016 Okenla, Toheeb. All rights reserved.
//
import Foundation
import UIKit
import EventKit
import CoreData

// group 1 = < .4 - notification + feedback
// group 2 = > .4 & < .6 - notification no feedback
// group 3 = >.7 && < 1 - no notification no feedback

class NewGoal: UIViewController {
    let defaults = NSUserDefaults.standardUserDefaults()

    var goals = [NSManagedObject]()
    var goalName = String()
    var goalDescription = String()
    var goalDueDate: UIDatePicker!

    @IBOutlet var goalNameTextField: UITextField!
    @IBOutlet weak var goalDescriptionTextView: UITextView!
    @IBOutlet var dateTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.goalNameTextField.placeholder = "What is your goal?"
        self.dateTextField.placeholder = "Due date"
        
        
        goalDueDate = UIDatePicker()
        goalDueDate.addTarget(self, action: #selector(NewGoal.addDate), forControlEvents: UIControlEvents.ValueChanged)
        goalDueDate.datePickerMode = UIDatePickerMode.DateAndTime
        dateTextField.inputView = goalDueDate
        goalDescriptionTextView.becomeFirstResponder()
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    func createFeedbackNotification(){
        var notification = UILocalNotification()
        notification.alertBody = "Did you exercise today?"
        notification.alertTitle = "Motiv8"
        notification.alertAction = "respond"
        notification.fireDate = self.goalDueDate.date //change to reminder date
        notification.soundName = UILocalNotificationDefaultSoundName
        //assign unique identifiers to notification
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        print("notification created")
    }
    
    func createGenericNotification(){
        var notification = UILocalNotification()
        notification.alertBody = "Don't forget to exercise today!"
        notification.alertAction = "open"
        notification.alertTitle = "Motiv8"
        notification.fireDate = self.goalDueDate.date //change to reminder date
        notification.soundName = UILocalNotificationDefaultSoundName
        //assign unique identifiers to notification
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        print("notification created")
    }
    
    
    
    // SAVE NEW GOAL
    
    // to-do : sanitize for all fields
    @IBAction func saveNewGoal(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Goal", inManagedObjectContext: managedContext)
        let goal = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        goal.setValue(self.goalNameTextField!.text!, forKey: "goal_name")
        goal.setValue(self.goalDescriptionTextView!.text!, forKey: "goal_description")
        goal.setValue(self.goalDueDate.date, forKey: "goal_due_date")
        
        do {
            
            try managedContext.save()
            goals.append(goal)
            
        } catch let error as NSError {
            
            print("Could not save \(error), \(error.userInfo)")
            
        }
        self.navigationController!.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // if either in group 1 or 2
        if(defaults.doubleForKey("number") < Double(0.6)){
            self.createFeedbackNotification()
        } else {
            self.createGenericNotification()
        }

    }
    
    func addDate() {
        self.dateTextField.text = self.goalDueDate.date.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}