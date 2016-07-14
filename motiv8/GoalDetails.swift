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

class GoalsDetails: UIViewController {
    
    var datePicker: UIDatePicker!
    var reminder: EKReminder!
    var eventStore: EKEventStore!
    
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet weak var reminderTextView: UITextView!
    
    
    @IBAction func saveReminder(sender: AnyObject) {
        self.reminder.title = reminderTextView.text
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dueDateComponents = appDelegate.dateComponentFromNSDate(self.datePicker.date)
        
        reminder.dueDateComponents = dueDateComponents
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        
        do {
            try self.eventStore.saveReminder(reminder, commit: true)
            self.navigationController?.popToRootViewControllerAnimated(true)
        } catch {
            print("Error saving new reminder : \(error)")
        }
        
    }
    
    override func viewDidLoad() {
        print("at gd")
        super.viewDidLoad()
        self.reminderTextView.text = self.reminder.title
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(GoalsDetails.addDate), forControlEvents: UIControlEvents.ValueChanged)
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        dateTextField.inputView = datePicker
        reminderTextView.becomeFirstResponder()
    }
    
    func addDate() {
        self.dateTextField.text = self.datePicker.date.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
