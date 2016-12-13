//
//  ReminderController.swift
//  Remind Me
//
//  Created by Salieu Kamara on 13/12/2016.
//  Copyright © 2016 Coventry University. All rights reserved.
//

import UIKit

class ReminderController: UIViewController {
    
    public var reminderID:Int?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var moduleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let id:Int = self.reminderID {
            print("view did load with reminder \(id)")
            if let reminder:Reminder = try? Reminders.sharedInstance.getReminder(at: id) {
                self.title = reminder.title
                self.titleField.text = reminder.title
                self.moduleField.text = reminder.module
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
