//
//  ReminderController.swift
//  Remind Me
//
//  Created by Salieu Kamara on 13/12/2016.
//  Copyright © 2016 Coventry University. All rights reserved.
//

import UIKit

//http://codewithchris.com/uipickerview-example/

protocol UpdateDelegate {
    func update(with reminder: Reminder, at index: Int)
}

class ReminderController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    public var reminderID:Int?
    var delegate: UpdateDelegate?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var moduleField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var categoryPickerHeight: NSLayoutConstraint!
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    
    @IBAction func dismissKeyboard(_ sender: UIBarButtonItem) {
        self.titleField.resignFirstResponder()
        self.moduleField.resignFirstResponder()
    }
    
    var categoryData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneButton.tintColor = UIColor.clear
        
        // Resize category and date picker to 30% of screen height
        let screenSize: CGRect = UIScreen.main.bounds
        categoryPickerHeight.constant = screenSize.height * 0.3
        datePickerHeight.constant = screenSize.height * 0.3
        
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        self.titleField.delegate = self
        self.moduleField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardDidHide, object: nil)
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: UIControlEvents.valueChanged)
        
        categoryData = ["Coursework", "Exam", "Project", "Report"]
        
        if let id:Int = self.reminderID {
            print("view did load with reminder \(id)")
            if let reminder:Reminder = try? Reminders.sharedInstance.getReminder(at: id) {
                self.title = reminder.title
                self.titleField.text = reminder.title
                self.moduleField.text = reminder.module
                self.categoryPicker.selectRow(reminder.category, inComponent: 0, animated: true)
                self.datePicker.date = reminder.deadline
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Triggered when user makes a change to the picker selection
        print("picker: \(categoryPicker.selectedRow(inComponent: 0))")
        saveReminder()
    }
    
    func saveReminder() {
        self.title = self.titleField.text
        let reminder:Reminder = Reminder(title: titleField.text!, module: moduleField.text!,
                                         category: categoryPicker.selectedRow(inComponent: 0), deadline: datePicker.date)
        if let id:Int = self.reminderID {
            print("saving reminder with id: \(id)")
            delegate?.update(with: reminder, at: id)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleField {
            print("finished editing the title")
        } else if textField == moduleField {
            print("finished editing the module")
        }
        saveReminder()
    }
    
    func datePickerChanged(datePicker: UIDatePicker) {
        
        saveReminder()
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        print("keyboard will show")
        self.doneButton.tintColor = nil
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        print("keyboard will hide")
        self.doneButton.tintColor = UIColor.clear
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
