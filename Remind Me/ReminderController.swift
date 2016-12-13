//
//  ReminderController.swift
//  Remind Me
//
//  Created by Salieu Kamara on 13/12/2016.
//  Copyright © 2016 Coventry University. All rights reserved.
//

import UIKit

//http://codewithchris.com/uipickerview-example/

class ReminderController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    public var reminderID:Int?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var moduleField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    var categoryData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self

        if let id:Int = self.reminderID {
            print("view did load with reminder \(id)")
            if let reminder:Reminder = try? Reminders.sharedInstance.getReminder(at: id) {
                self.title = reminder.title
                self.titleField.text = reminder.title
                self.moduleField.text = reminder.module
                categoryData = ["Item 1", "Item 2", "Item 3"]
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryData[row]
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
