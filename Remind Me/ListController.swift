//
//  ListController.swift
//  Remind Me
//
//  Created by Salieu Kamara on 13/12/2016.
//  Copyright © 2016 Coventry University. All rights reserved.
//

import UIKit

class ListController: UITableViewController {
    
    var reminders = Reminders.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        try? reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                              category: "Report", deadline: Date()))
        try? reminders.add(reminder: Reminder(title: "Reminder Two", module: "310SE",
                                              category: "Coursework", deadline: Date()))
        try? reminders.add(reminder: Reminder(title: "Reminder Three", module: "306AEE",
                                              category: "Project", deadline: Date()))
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
                try label.text = reminders.getReminder(at: indexPath.row).title
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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
                    }
                }
            }
        }
    }

}
