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
import CoreData

class GoalsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var goals = [NSManagedObject]()
    var goalName = String()
    var goalDescription = String()
    var goalDueDate: UIDatePicker!
    
    
//    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
        //fetch goals
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Goal")
        
        do {
            
            let results = try managedContext.executeFetchRequest(fetchRequest)
            goals = results as! [NSManagedObject]
            
        } catch let error as NSError {
            
            print("Could not fetch \(error), \(error.userInfo)")
            
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("GoalCell")
        
        let goal = goals[indexPath.row]
        
        cell!.textLabel!.text = goal.valueForKey("goal_name") as? String
        
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let dueDate = goal.valueForKey("goal_due_date")?.dueDateComponents?!.date{
            cell.detailTextLabel?.text = formatter.stringFromDate(dueDate)
        } else {
            cell.detailTextLabel?.text = "N/A"
        }
        return cell
    }
    
    //fix delete
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        print("delete true")
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == .Delete) {
            print(".Delete")
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            let goalToDelete = goals[indexPath.row]
            managedContext.deleteObject(goalToDelete)
            
            self.goals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }


    }
    
    //might have to just make this a function
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowGoalsDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowGoalsDetails" {
            
            print("at goal detail vc")
            
            let goalDetailsVC = segue.destinationViewController as! GoalsDetails
            goalDetailsVC.goalName = self.goalName
            goalDetailsVC.goalDescription = self.goalDescription
            goalDetailsVC.goalDueDate = self.goalDueDate
    
        } else {
            
            print("at new goal vc")
            
            let newGoalVC = segue.destinationViewController as! NewGoal
            newGoalVC.goals = goals
            
        }
    }
}