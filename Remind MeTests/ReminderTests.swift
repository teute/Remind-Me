//
//  ReminderTests.swift
//  Remind Me
//
//  Created by Salieu Kamara on 13/12/2016.
//  Copyright © 2016 Coventry University. All rights reserved.
//

import XCTest
@testable import Remind_Me

class ReminderTests: XCTestCase {
    
    override func tearDown() {
        let reminders = Reminders.sharedInstance
        reminders.clearList()
        super.tearDown()
    }
    
    func testAddSingleReminder() {
        let reminders = Reminders.sharedInstance
        reminders.clearList()
        
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "201CDE",
                                                 category: 0, deadline: Date()))
            XCTAssertEqual(reminders.count, 1)
        } catch {
            XCTFail()
        }
    }
    
    func testAddMultipleReminders() {
        let reminders = Reminders.sharedInstance
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                                 category: 3, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Two", module: "310SE",
                                                 category: 0, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Three", module: "306AEE",
                                                 category: 2, deadline: Date()))
            XCTAssertEqual(reminders.count, 3)
        } catch {
            XCTFail()
        }
    }
    
    func testRetrieveSingleReminder() {
        let reminders = Reminders.sharedInstance
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                                 category: 3, deadline: Date()))
            let reminder = try reminders.getReminder(at: 0)
            XCTAssertEqual(reminder.title, "Reminder One")
            XCTAssertEqual(reminder.module, "305AEE")
        } catch {
            XCTFail()
        }
    }
    
    func testRetrieveLastReminder() {
        let reminders = Reminders.sharedInstance
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                                 category: 3, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Two", module: "310SE",
                                                 category: 0, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Three", module: "306AEE",
                                                 category: 2, deadline: Date()))
            let reminder = try reminders.getReminder(at: 2)
            XCTAssertEqual(reminder.title, "Reminder Three")
            XCTAssertEqual(reminder.module, "306AEE")
        } catch {
            XCTFail()
        }
    }
    
    func testRetrieveInvalidReminder() {
        let reminders = Reminders.sharedInstance
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                                 category: 3, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Two", module: "310SE",
                                                 category: 0, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Three", module: "306AEE",
                                                 category: 3, deadline: Date()))
            let _ = try reminders.getReminder(at: 3)
            XCTFail()
        } catch ReminderError.outOfRande(let index) {
            XCTAssertEqual(index, 3, "the exception should pass array index 3")
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveOnlyReminder() {
        let reminders = Reminders.sharedInstance
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE", category: 1, deadline: Date()))
            XCTAssertEqual(reminders.count, 1)
            try reminders.remove(at: 0)
            XCTAssertEqual(reminders.count, 0)
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveLastReminder() {
        let reminders = Reminders.sharedInstance
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                                 category: 3, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Two", module: "310SE",
                                                 category: 0, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Three", module: "306AEE",
                                                 category: 3, deadline: Date()))
            XCTAssertEqual(reminders.count, 3)
            try reminders.remove(at: 2)
            XCTAssertEqual(reminders.count, 2)
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveInvalidReminder() {
        let reminders = Reminders.sharedInstance
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                                 category: 3, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Two", module: "310SE",
                                                 category: 0, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Three", module: "306AEE",
                                                 category: 3, deadline: Date()))
            XCTAssertEqual(reminders.count, 3)
            try reminders.remove(at: 3)
            XCTFail()
        } catch ReminderError.outOfRande(let index) {
            XCTAssertEqual(reminders.count, 3)
            XCTAssertEqual(index, 3, "the exception should pass array index 3")
        } catch {
            XCTFail()
        }
    }
    
    func testInsertAtFirstIndex() {
        let reminders = Reminders.sharedInstance
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                                 category: 3, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Two", module: "310SE",
                                                 category: 0, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Three", module: "306AEE",
                                                 category: 2, deadline: Date()))
            XCTAssertEqual(reminders.count, 3)
            let reminder = Reminder(title: "Reminder Zero", module: "301CDE",
                                    category: 0, deadline: Date())
            try reminders.insert(reminder: reminder, at: 0)
            XCTAssertEqual(reminders.count, 4)
        } catch {
            XCTFail()
        }
    }
    
    func testInsertAtLastIndex() {
        let reminders = Reminders.sharedInstance
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                                 category: 3, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Two", module: "310SE",
                                                 category: 0, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Three", module: "306AEE",
                                                 category: 2, deadline: Date()))
            XCTAssertEqual(reminders.count, 3)
            let reminder = Reminder(title: "Reminder Four", module: "301CDE",
                                    category: 0, deadline: Date())
            try reminders.insert(reminder: reminder, at: reminders.count)
            XCTAssertEqual(reminders.count, 4)
        } catch {
            XCTFail()
        }
    }
    
    func testInsertAtInvalidIndex() {
        let reminders = Reminders.sharedInstance
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                                 category: 3, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Two", module: "310SE",
                                                 category: 0, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Three", module: "306AEE",
                                                 category: 2, deadline: Date()))
            XCTAssertEqual(reminders.count, 3)
            let reminder = Reminder(title: "Reminder Five", module: "301CDE",
                                    category: 0, deadline: Date())
            try reminders.insert(reminder: reminder, at: reminders.count + 1)
            XCTFail()
        } catch ReminderError.outOfRande(let index) {
            XCTAssertEqual(reminders.count, 3)
            XCTAssertEqual(index, 4, "the exception should pass array index 4")
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateFirstIndex() {
        let reminders = Reminders.sharedInstance
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                                 category: 3, deadline: Date()))
            XCTAssertEqual(reminders.count, 1)
            var reminder = Reminder(title: "Reminder One Update", module: "301AEF",
                                    category: 3, deadline: Date())
            try reminders.update(reminder: reminder, at: 0)
            XCTAssertEqual(reminders.count, 1)
            reminder = try reminders.getReminder(at: 0)
            XCTAssertEqual(reminder.title, "Reminder One Update")
            XCTAssertEqual(reminder.module, "301AEF")
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateLastIndex() {
        let reminders = Reminders.sharedInstance
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                                 category: 3, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Two", module: "310SE",
                                                 category: 0, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Three", module: "306AEE",
                                                 category: 2, deadline: Date()))
            XCTAssertEqual(reminders.count, 3)
            var reminder = Reminder(title: "Reminder Three Update", module: "306AFF",
                                    category: 2, deadline: Date())
            try reminders.update(reminder: reminder, at: 2)
            XCTAssertEqual(reminders.count, 3)
            reminder = try reminders.getReminder(at: 2)
            XCTAssertEqual(reminder.title, "Reminder Three Update")
            XCTAssertEqual(reminder.module, "306AFF")
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateInvalidIndex() {
        let reminders = Reminders.sharedInstance
        do {
            try reminders.add(reminder: Reminder(title: "Reminder One", module: "305AEE",
                                                 category: 3, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Two", module: "310SE",
                                                 category: 0, deadline: Date()))
            try reminders.add(reminder: Reminder(title: "Reminder Three", module: "306AEE",
                                                 category: 2, deadline: Date()))
            XCTAssertEqual(reminders.count, 3)
            let reminder = Reminder(title: "Reminder Four Update", module: "301CDE", category: 1, deadline: Date())
            try reminders.update(reminder: reminder, at: 3)
            XCTFail()
        } catch ReminderError.outOfRande(let index) {
            XCTAssertEqual(reminders.count, 3)
            XCTAssertEqual(index, 3)
        } catch {
            XCTFail()
        }
    }
}
