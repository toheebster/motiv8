//
//  Survey.swift
//  motiv8
//
//  Created by Okenla, Toheeb on 8/17/16.
//  Copyright © 2016 Okenla, Toheeb. All rights reserved.
//

import Foundation
import UIKit
import ResearchKit

class Survey: UIViewController {
    
    let check = UserDefaults.standard
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkSurvey()
        self.navigationController?.isNavigationBarHidden = true
        self.survey()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func survey() {
        print("survey called")
        let taskVC = ORKTaskViewController(task: SurveyTask, taskRun: nil)
        taskVC.delegate = self
        present(taskVC, animated: true, completion: nil)
    }
    
    func checkSurvey() {
        if check.bool(forKey: "completedSurvey") != true {
            check.set(false, forKey: "completedSurvey")
        }
    }
    
}

extension Survey : ORKTaskViewControllerDelegate {
    /**
     Tells the delegate that the task has finished.
     
     The task view controller calls this method when an unrecoverable error occurs,
     when the user has canceled the task (with or without saving), or when the user
     completes the last step in the task.
     
     In most circumstances, the receiver should dismiss the task view controller
     in response to this method, and may also need to collect and process the results
     of the task.
     
     @param taskViewController  The `ORKTaskViewController `instance that is returning the result.
     @param reason              An `ORKTaskViewControllerFinishReason` value indicating how the user chose to complete the task.
     @param error               If failure occurred, an `NSError` object indicating the reason for the failure. The value of this parameter is `nil` if `result` does not indicate failure.
     */
    public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        //Handle results with taskViewController.result
        taskViewController.dismiss(animated: true, completion: nil)
        
        switch reason {
        case .completed:
            
            check.set(true, forKey: "completedSurvey")
            print("completed survey")
            //send to survey vc
            self.performSegue(withIdentifier: "ShowGoalsVC", sender:self)
            
        case ORKTaskViewControllerFinishReason.discarded:
            
            print("discarded survey")
            let alert = UIAlertController(title: "Alert", message: "You must complete survey before continuing", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                //start over
                switch action.style {
                case .default:
                    self.survey()
                default:
                    self.survey()
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
            
        default:
            print("breaking from survey")
            break
        }

    }

}
