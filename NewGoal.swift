//
//  NewGoal.swift
//  motiv8
//
//  Created by Okenla, Toheeb on 7/12/16.
//  Copyright © 2016 Okenla, Toheeb. All rights reserved.
//

import UIKit
import EventKit

class NewGoal: UIViewController {
    
    var eventStore: EKEventStore!
    var datePicker: UIDatePicker!
    
    @IBOutlet weak var reminderTextView: UITextView!
    @IBOutlet var dateTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(NewGoal.addDate), forControlEvents: UIControlEvents.ValueChanged)
        
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        dateTextField.inputView = datePicker
        reminderTextView.becomeFirstResponder()
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveNewReminder(sender: AnyObject) {
        let reminder = EKReminder(eventStore: self.eventStore)
        reminder.title = reminderTextView.text
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dueDateComponents = appDelegate.dateComponentFromNSDate(self.datePicker.date)
        reminder.dueDateComponents = dueDateComponents
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        
        do {
            
            try self.eventStore.saveReminder(reminder, commit: true)
            dismissViewControllerAnimated(true, completion: nil)
            
        } catch {
            print("Error creating and saving new reminder : \(error)")
        }
    }
    
    func addDate() {
        self.dateTextField.text = self.datePicker.date.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}