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
    let standards = UserDefaults.standard

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
    
    func createFeedbackNotification(goalId: String, goalName: String){
        let notification = UILocalNotification()
        notification.alertBody = "Did you complete \'\(goalName)\'"
        notification.alertTitle = "Motiv8 Reminder"
        notification.alertAction = "respond"
        notification.fireDate = self.goalDueDate.date //change to reminder date
        notification.repeatInterval = NSCalendar.Unit.day
        notification.soundName = UILocalNotificationDefaultSoundName
        print("goal id is \(goalId)")
        notification.userInfo = ["id": goalId]
        print(notification.userInfo?["id"])
        UIApplication.shared.scheduleLocalNotification(notification)
        print("feedback notification created")
    }
    
    func createGenericNotification(goalId: String){
        let notification = UILocalNotification()
        notification.alertBody = "Remember to excercise"
        notification.alertAction = "open"
        notification.alertTitle = "Motiv8 Reminder"
        notification.fireDate = self.goalDueDate.date //change to reminder date
        notification.soundName = UILocalNotificationDefaultSoundName
        //assign unique identifiers to notification
        notification.userInfo = ["id": goalId]
        UIApplication.shared.scheduleLocalNotification(notification)
        print("generic notification created")
    }
    
    
    // SAVE NEW GOAL
    
    // to-do : sanitize for all fields
    @IBAction func saveNewGoal(_ sender: AnyObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Goal", in: managedContext)
        let goal = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        print(self.goalDescriptionTextView!.text!)
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
        
        let goalId = goalIdToURI(goalId: goal.objectID)
        print(goalId)
//         if either in group 1 or 2
        if(standards.integer(forKey: "group") < 3){
            self.createFeedbackNotification(goalId: goalId, goalName: goalNameTextField!.text!)
        } else {
            self.createGenericNotification(goalId: goalId)
        }

    }
    
    func goalIdToURI(goalId: NSManagedObjectID) -> String {
        let URI = goalId.uriRepresentation().absoluteString
        return URI
    }
    
    func addDate() {
        self.dateTextField.text = self.goalDueDate.date.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
