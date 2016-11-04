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
    var goalDate = Date()
    var goalDueDate: UIDatePicker!
    
    @IBOutlet var goalDateLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet var goalNameLabel: UILabel!
    
    // handle if a field is deleted
    @IBAction func saveGoal(_ sender: AnyObject) {
        
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
                self.navigationController!.popViewController(animated: true)
                self.navigationController?.setToolbarHidden(false, animated: false)
            } catch let error as NSError {
                print("Could not update \(error), \(error.userInfo)")
                //popup
            }
            
        } else {
            //popup
        }
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Goal")
        
        do {
            
            let results = try managedContext.fetch(fetchRequest)
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        print("view will appear")
        print(self.goalName)
        print(self.goalDescription)
        self.goalNameLabel!.text! = self.goalName
        self.descriptionLabel!.text! = self.goalDescription

        
        goalDueDate = UIDatePicker()
        goalDueDate.date = self.goalDate
        goalDueDate.addTarget(self, action: #selector(GoalsDetails.addDate), for: UIControlEvents.valueChanged)
        goalDueDate.datePickerMode = UIDatePickerMode.dateAndTime
        goalDateLabel.inputView = goalDueDate
        descriptionLabel.becomeFirstResponder()
        
        self.goalDateLabel!.text! = formatter.string(from: self.goalDueDate.date)
    }
    
    func passGoal(_ goal: NSManagedObject, location: Int) {
        self.goalName = (goal.value(forKey: "goal_name") as? String)!
        self.goalDescription = (goal.value(forKey: "goal_description") as? String)!
        print("pass goal called")
        self.goalDate = (goal.value(forKey: "goal_due_date") as? Date)!
        self.goal = goal
        self.location = location
    }
    
    
}
