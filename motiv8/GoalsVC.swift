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
    var goalDueDate = String()
    var date = NSDate()
    
    
//    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
        //fetch goals
        
        self.navigationController?.navigationBarHidden = false

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
        tableView.reloadData()
        
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
        
        let goal = goals[indexPath.row]
        
        let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("GoalCell")
        cell!.textLabel!.text = goal.valueForKey("goal_name") as? String
        
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, MMMM, d, yyyy 'at' hh:mm a"
        
        self.date = goal.valueForKey("goal_due_date") as! NSDate
        self.goalDueDate = formatter.stringFromDate(date)
        cell.detailTextLabel?.text = "Due on: " + self.goalDueDate

        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == .Delete) {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            let goalToDelete = goals[indexPath.row]
            managedContext.deleteObject(goalToDelete)
            self.goals.removeAtIndex(indexPath.row)
            
            do {
                try managedContext.save()
            } catch _ {
                
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }


    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowGoalsDetails", sender: self)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, MMMM, d, yyyy 'at' hh:mm a"
        
        let goal = goals[indexPath.row]
        self.goalName = goal.valueForKey("goal_name") as! String
        self.goalDescription = goal.valueForKey("goal_name") as! String
        self.date = goal.valueForKey("goal_due_date") as! NSDate
        self.goalDueDate = formatter.stringFromDate(date)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowGoalsDetails" {
           
            let goalDetailsVC = segue.destinationViewController as! GoalsDetails
            
            let indexPath = tableView.indexPathForSelectedRow
            let goal = goals[indexPath!.row]
            goalDetailsVC.passGoal(goal, location: indexPath!.row)
    
        } else {
            
            let newGoalVC = segue.destinationViewController as! NewGoal
            newGoalVC.goals = goals
        }
    }
}