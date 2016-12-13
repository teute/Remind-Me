//
//  Reminders.swift
//  Remind Me
//
//  Created by Salieu Kamara on 13/12/2016.
//  Copyright © 2016 Coventry University. All rights reserved.
//

import Foundation

public struct Reminder {
    var title: String
    var module: String
    var category: String
    var deadline: Date
    
    public init(title: String, module: String, category: String, deadline: Date) {
        self.title = title
        self.module = module
        self.category = category
        self.deadline = deadline
    }
}

enum ReminderError: Error {
    case emptyString
    case outOfRande(index: Int)
}

public class Reminders {
    
    var reminders:[Reminder]
    
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
        if (reminder.title.isEmpty || reminder.module.isEmpty || reminder.category.isEmpty) {
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
}
