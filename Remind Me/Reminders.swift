//
//  Reminders.swift
//  Remind Me
//
//  Created by Salieu Kamara on 13/12/2016.
//  Copyright © 2016 Coventry University. All rights reserved.
//

//http://stackoverflow.com/questions/29986957/save-custom-objects-into-nsuserdefaults

import Foundation

public class Reminder: NSObject, NSCoding {
    var title: String
    var module: String
    var category: Int
    var deadline: Date
    var dueIn: TimeInterval
    
    public init(title: String, module: String, category: Int, deadline: Date) {
        self.title = title
        self.module = module
        self.category = category
        self.deadline = deadline
        self.dueIn = deadline.timeIntervalSince(Date())
    }
    
    required convenience public init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let module = aDecoder.decodeObject(forKey: "module") as! String
        let category = aDecoder.decodeInteger(forKey: "category")
        let deadline = aDecoder.decodeObject(forKey: "deadline") as! Date
        self.init(title: title, module: module, category: category, deadline: deadline)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(module, forKey: "module")
        aCoder.encode(category, forKey: "category")
        aCoder.encode(deadline, forKey: "deadline")
    }
}

enum ReminderError: Error {
    case emptyString
    case outOfRande(index: Int)
}

public class Reminders {
    
    var reminders:[Reminder]
    let userDefaults = UserDefaults.standard
    
    public static let sharedInstance = Reminders()
    
    private init() {
        self.reminders = []
    }
    
    public var count: Int {
        get {
            return self.reminders.count
        }
    }
    
    public func add(reminder: Reminder) throws {
        if (reminder.title.isEmpty || reminder.module.isEmpty || reminder.category < 0) {
            throw ReminderError.emptyString
        }
        
        self.reminders.append(reminder)
    }
    
    public func getReminder(at index: Int) throws -> Reminder {
        if (index < 0) || (index > (self.reminders.count - 1)) {
            throw ReminderError.outOfRande(index: index)
        }
        return self.reminders[index]
    }
    
    public func clearList() {
        self.reminders.removeAll()
    }
    
    public func insert(reminder: Reminder, at index: Int) throws {
        if (index < 0) || (index > self.reminders.count) {
            throw ReminderError.outOfRande(index: index)
        }
        self.reminders.insert(reminder, at: index)
    }
    
    public func update(reminder: Reminder, at index: Int) throws {
        if (index < 0) || (index > (self.reminders.count - 1)) {
            throw ReminderError.outOfRande(index: index)
        }
        self.reminders[index] = reminder
    }
    
    public func remove(at index: Int) throws {
        if (index < 0) || (index > (self.reminders.count - 1)) {
            throw ReminderError.outOfRande(index: index)
        }
        self.reminders.remove(at: index)
    }
    
    public func save() {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: reminders)
        userDefaults.set(encodedData, forKey: "reminders")
        userDefaults.synchronize()
    }
    
    public func load() {
        if let decoded = userDefaults.object(forKey: "reminders") as? Data {
            self.reminders = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Reminder]
        }
    }
}
