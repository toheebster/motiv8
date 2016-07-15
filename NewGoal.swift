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

class NewGoal: UIViewController {
    var goals = [NSManagedObject]()
    var goalName = String()
    var goalDescription = String()
    var goalDueDate: UIDatePicker!

    @IBOutlet var goalNameTextField: UITextField!
    @IBOutlet weak var goalDescriptionTextView: UITextView!
    @IBOutlet var dateTextField: UITextField!
    
    
    override func viewDidLoad() {
        print("did load")
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // SAVE NEW GOAL
    
    // to-do : sanitize for all fields
    @IBAction func saveNewGoal(sender: AnyObject) {
        print("here1")
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
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let goalVC = storyBoard.instantiateViewControllerWithIdentifier("GoalVCID") as! GoalsVC
        
        self.presentViewController(goalVC, animated: true, completion: nil)


    }
    
    func addDate() {
        self.dateTextField.text = self.goalDueDate.date.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}