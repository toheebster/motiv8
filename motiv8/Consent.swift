//
//  ViewController.swift
//  motiv8
//
//  Created by Okenla, Toheeb on 5/12/16.
//  Copyright © 2016 Okenla, Toheeb. All rights reserved.
//

import UIKit
import ResearchKit

class Consent: UIViewController {

    let check = UserDefaults.standard
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkConsent()
        self.navigationController?.isNavigationBarHidden = true
        self.consent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func consent() {
        print("consent called")
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    func checkConsent() {
        if check.bool(forKey: "completedConsent") != true {
            check.set(false, forKey: "completedConsent")
        }
    }

}

extension Consent : ORKTaskViewControllerDelegate {
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
        case ORKTaskViewControllerFinishReason.completed:
            
            check.set(true, forKey: "completedConsent")
            print("completed consent")
            //send to survey vc
            self.performSegue(withIdentifier: "ShowSurvey", sender:self)
            
        case ORKTaskViewControllerFinishReason.discarded:
            
            print("discarded consent")
            //start over
            self.consent()
            
        default:
            print("breaking from consent")
            break
        }
    }

}

