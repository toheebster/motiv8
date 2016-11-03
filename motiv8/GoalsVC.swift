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


// group 1 = <3.3
// group 2 = >3.3 & <6.6
// group 3 = >6.6 && < 1

class GoalsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var goals = [NSManagedObject]()
    var goalName = String()
    var goalDescription = String()
    var goalDueDate = String()
    var date = Date()
    
    
//    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        //fetch goals
        
        self.navigationController?.isNavigationBarHidden = false

        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Goal")
        
        do {
            
            let results = try managedContext.fetch(fetchRequest)
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
        
        for goal in goals {
            let reminderDate = goal.value(forKey: "goal_due_date")!
            switch (reminderDate as AnyObject).compare(Date()) {
            case .orderedSame: break //remove
                //fire a popup
            case .orderedAscending: break
                //fire a popup
            default: break
                
            }
        }
    }
    
    
    @IBAction func editTable(_ sender: AnyObject) {
        tableView.isEditing = !tableView.isEditing
        if tableView.isEditing{
            tableView.setEditing(true, animated: true)
        }else{
            tableView.setEditing(false, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let goal = goals[(indexPath as NSIndexPath).row]
        
        let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "GoalCell")
        cell!.textLabel!.text = goal.value(forKey: "goal_name") as? String
        
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        
        self.date = goal.value(forKey: "goal_due_date") as! Date
        self.goalDueDate = formatter.string(from: date)
        cell.detailTextLabel?.text = "Due on: " + self.goalDueDate

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete) {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            let goalToDelete = goals[(indexPath as NSIndexPath).row]
            managedContext.delete(goalToDelete)
            self.goals.remove(at: (indexPath as NSIndexPath).row)
            
            do {
                try managedContext.save()
            } catch _ {
                
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }


    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowGoalsDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM, d, yyyy 'at' hh:mm a"
        
        let goal = goals[(indexPath as NSIndexPath).row]
        self.goalName = goal.value(forKey: "goal_name") as! String
        self.goalDescription = goal.value(forKey: "goal_name") as! String
        self.date = goal.value(forKey: "goal_due_date") as! Date
        self.goalDueDate = formatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGoalsDetails" {
           
            let goalDetailsVC = segue.destination as! GoalsDetails
            
            let indexPath = tableView.indexPathForSelectedRow
            let goal = goals[(indexPath! as NSIndexPath).row]
            goalDetailsVC.passGoal(goal, location: (indexPath! as NSIndexPath).row)
    
        } else {
            
            let newGoalVC = segue.destination as! NewGoal
            newGoalVC.goals = goals
        }
    }
}
