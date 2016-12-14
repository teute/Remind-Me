//
//  ListController.swift
//  Remind Me
//
//  Created by Salieu Kamara on 13/12/2016.
//  Copyright © 2016 Coventry University. All rights reserved.
//

import UIKit
import CoreData

//http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
//http://www.knowstack.com/swift-nsdateformatter/
//http://www.sthoughts.com/2016/06/16/swift-3-working-with-dates/

protocol DeleteReminderDelegate {
    func clearReminderView(at index: Int)
}

class ListController: UITableViewController, UpdateDelegate{
    
    var reminders = Reminders.sharedInstance
    var reminderObj = [NSManagedObject]()
    var delegate: DeleteReminderDelegate?
    
    @IBAction func editMode(_ sender: UIBarButtonItem) {
        self.isEditing = !self.isEditing
        print("editmode: \(self.isEditing)")
        if self.isEditing {
            sender.title = "Done"
        } else {
            sender.title = "Edit"
        }
    }
    
    @IBAction func addReminder(_ sender: UIBarButtonItem) {
        try? self.reminders.add(reminder: Reminder(title: "New Reminder", module: " ", category: 0, deadline: Date()))
            self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = .short
        //dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        
        let date1: Date = dateFormatter.date(from: "2016-12-06  11:59 PM")!
        let date2: Date = dateFormatter.date(from: "2016-12-25 4:00 PM")!
        let date3: Date = dateFormatter.date(from: "2016-12-29 9:30 PM")!
        
        let time_between = date1.timeIntervalSince(date2)

        print("Time Interval: \(time_between/60/60/24) days")
        
        try? reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                              category: 3, deadline: date1))
        try? reminders.add(reminder: Reminder(title: "Reminder Two", module: "310SE",
                                              category: 0, deadline: date2))
        try? reminders.add(reminder: Reminder(title: "Reminder Three", module: "306AEE",
                                              category: 2, deadline: date3))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reminder", for: indexPath)
        
        if let label = cell.textLabel {
            do {
                let days:Int = try! Int(reminders.getReminder(at: indexPath.row).dueIn / 86400)
                
                if (days < 0) {
                    try label.text = reminders.getReminder(at: indexPath.row).title + " was due \(-days) days ago"
                } else {
                    try label.text = reminders.getReminder(at: indexPath.row).title + " due in \(days) days"
                }
            } catch {
                print("an error has occured")
            }
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row \(indexPath) selected")
        if let cell:UITableViewCell = self.tableView?.cellForRow(at: indexPath) {
            print("we found the selected cell: \(cell)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try? self.reminders.remove(at: indexPath.row)
            //TODO: the delegate points to nil, needs fixing for feature to work
            delegate?.clearReminderView(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let reminder: Reminder = try! reminders.getReminder(at: fromIndexPath.row)
        try? self.reminders.remove(at: fromIndexPath.row)
        try? reminders.insert(reminder: reminder, at: to.row)
        self.tableView.reloadData()
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func update(with reminder: Reminder, at index: Int) {
        print("delegate method called with note title: \(reminder.title) at index \(index)")
        try? Reminders.sharedInstance.update(reminder: reminder, at: index)
        self.tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReminder" {
            print("segue with \(segue.identifier) identifier trigger")
            if let indexPath = self.tableView.indexPathForSelectedRow {
                print("found row\(indexPath.row)")
                if let navigationController = segue.destination as? UINavigationController {
                    if let reminderController = navigationController.topViewController as? ReminderController {
                        print("found Reminder Controller")
                        reminderController.reminderID = indexPath.row
                        reminderController.delegate = self
                    }
                }
            }
        }
    }

}
