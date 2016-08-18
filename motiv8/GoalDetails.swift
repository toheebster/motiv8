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

class GoalsDetails: UIViewController {
    
    var goals = [NSManagedObject]()
    var goalName = String()
    var goalDescription = String()
    var goalDueDate: UIDatePicker!
    
    @IBOutlet var goalDateLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet var goalNameLabel: UILabel!
    
    // handle if a field is deleted
    @IBAction func saveGoal(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Goal", inManagedObjectContext: managedContext)
        let goal = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        goal.setValue(self.goalNameLabel!.text!, forKey: "goal_name")
        goal.setValue(self.descriptionLabel!.text!, forKey: "goal_description")
        goal.setValue(self.goalDateLabel!.text!, forKey: "goal_due_date")
        
        do {
            try managedContext.save()
            goals.append(goal)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
       
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        print("hit cancel")
        self.navigationController!.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        
    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.descriptionLabel.text = self.goalDescription
//        self.goalDateLabel.text = self.goalDueDate.date.description
        self.goalNameLabel.text = self.goalName
        
        
        goalDueDate = UIDatePicker()
        goalDueDate.addTarget(self, action: #selector(GoalsDetails.addDate), forControlEvents: UIControlEvents.ValueChanged)
        goalDueDate.datePickerMode = UIDatePickerMode.DateAndTime
        goalDateLabel.inputView = goalDueDate
        descriptionLabel.becomeFirstResponder()
    }
    
    func addDate() {
        self.goalDateLabel.text = self.goalDueDate.date.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
