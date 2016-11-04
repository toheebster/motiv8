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
    let defaults = UserDefaults.standard

    var goals = [NSManagedObject]()
    var goalName = String()
    var goalDescription = String()
    var goalDueDate: UIDatePicker! //really just the reminder time

    @IBOutlet var goalNameTextField: UITextField!
    @IBOutlet weak var goalDescriptionTextView: UITextView!
    @IBOutlet var dateTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.goalNameTextField.placeholder = "What is your goal?"
        self.dateTextField.placeholder = "Due date"
        
        
        goalDueDate = UIDatePicker()
        goalDueDate.addTarget(self, action: #selector(NewGoal.addDate), for: UIControlEvents.valueChanged)
        goalDueDate.datePickerMode = UIDatePickerMode.time
        dateTextField.inputView = goalDueDate
        goalDescriptionTextView.becomeFirstResponder()
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    //pass in goal and use goal id as notifc.userinfo hahahhaha
    func createFeedbackNotification(){
        let notification = UILocalNotification()
        notification.alertBody = "Did you meet your daily exercise goal today?"
        notification.alertTitle = "Motiv8"
        notification.alertAction = "respond"
        notification.fireDate = self.goalDueDate.date //change to reminder date
        notification.repeatInterval = NSCalendar.Unit.day
        notification.soundName = UILocalNotificationDefaultSoundName
        //assign unique identifiers to notification
        
        UIApplication.shared.scheduleLocalNotification(notification)
        print("notification created")
    }
    
    func createGenericNotification(){
        let notification = UILocalNotification()
        notification.alertBody = "Remember to excercise"
        notification.alertAction = "open"
        notification.alertTitle = "Motiv8"
        notification.fireDate = self.goalDueDate.date //change to reminder date
        notification.soundName = UILocalNotificationDefaultSoundName
        //assign unique identifiers to notification
        
        UIApplication.shared.scheduleLocalNotification(notification)
        print("notification created")
    }
    
    func removeNotification(){
        
    }
    //set badge numbers

    
    // SAVE NEW GOAL
    
    // to-do : sanitize for all fields
    @IBAction func saveNewGoal(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Goal", in: managedContext)
        let goal = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        goal.setValue(self.goalNameTextField!.text!, forKey: "goal_name")
        goal.setValue(self.goalDescriptionTextView!.text!, forKey: "goal_description")
        goal.setValue(self.goalDueDate.date, forKey: "goal_due_date")
        
        do {
            
            try managedContext.save()
            goals.append(goal)
            
        } catch let error as NSError {
            
            print("Could not save \(error), \(error.userInfo)")
            
        }
        self.navigationController!.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // if either in group 1 or 2
        if(defaults.integer(forKey: "group") < 3){
            self.createFeedbackNotification(goal)
        } else {
            self.createGenericNotification(goal)
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
