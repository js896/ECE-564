//
//  DukePerson.swift
//  ECE564_HW
//
//  Created by Jiawei Sun on 11/2/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import Foundation

/*
enum Gender : String, Codable {
    case Male = "Male"
    case Female = "Female"
}
*/
/*
enum DukeRole : String, Codable {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "Teaching Assistant"
}
*/
protocol ECE564 {
     var hobbies : [String]   {get}
     var languages : [String]    {get}
}

class DukePerson: NSObject, ECE564, Codable {
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("ToDoJSONFile")
    var hobbies: [String] = []
    var languages: [String] = []
    var firstname: String = "First"
    var lastname: String = "Last"
    var wherefrom: String = "Anywhere"
    var gender : String = ""
    var team : String = ""
    var email : String = ""
    var role: String = ""
    var degree: String = ""
    var picture: String = ""
    var netid: String = ""
    var department: String = ""
    var id: String = ""
    override init() {
        super.init()
    }
    init(firstName: String, lastName: String, whereFrom: String, gender: String, hobbies: [String], languages: [String], team: String, email: String, role: String, degree: String, image: String, NetID: String, Department: String, ID: String) {
        self.role = role
        self.degree = degree
        super.init()
        self.firstname = firstName
        self.lastname = lastName
        self.wherefrom = whereFrom
        self.gender = gender
        self.hobbies = hobbies
        self.languages = languages
        self.team = team
        self.email = email
        self.picture = image
        self.netid = NetID
        self.department = Department
        self.id = ID
    }
    
   func stringArrayToString(array: [String]) -> String {
        var resultString: String = ""
        for i in 0..<array.count {
            if i < (array.count - 1){
                resultString += array[i]
                resultString += ", "
            } else {
                resultString += array[i]
            }
        }
        return resultString
    }
    
    static func saveToDoInfo(_ people: [[DukePerson]]) -> Bool {
        var outputData = Data()
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(people) {
            if let json = String(data: encoded, encoding: .utf8) {
                print(json)
                outputData = encoded
            }
            else { return false }
            
            do {
                    try outputData.write(to: ArchiveURL)
            } catch let error as NSError {
                print (error)
                return false
            }
            return true
        }
        else { return false }
    }
    
    static func loadToDoInfo() -> [[DukePerson]]? {
        let decoder = JSONDecoder()
        var people = [[DukePerson]]()
        let tempData: Data
        
        do {
            tempData = try Data(contentsOf: ArchiveURL)
        } catch let error as NSError {
            print(error)
            return nil
        }
        if let decoded = try? decoder.decode([[DukePerson]].self, from: tempData) {
            //print(decoded[0])
            people = decoded
        }
/*
 NOTE:  "xxx.self" evaluates to the value of the type. Use this form to access a type as a value. For example, because SomeClass.self evaluates to the SomeClass type itself, you can pass it to a function or method that accepts a type-level argument.  (From Swift Language Guide)
 */
        return people
    }
}
    


extension DukePerson {
    override var description: String {
        var personalPronoun: String
            if (gender) == "Male"{
                personalPronoun = "He"
            } else {
                personalPronoun = "She"
            }
        var adjPronoun: String
        if (gender) == "Male" {
            adjPronoun = "His"
        } else {
            adjPronoun = "Her"
        }
        var title: String
        if (role) == "Student" {
            title = "student"
        } else if (role) == "Professor" {
            title = "professor"
        } else {
            title = "TA"
        }
        return "\(firstname) \(lastname) is from \(wherefrom), " + personalPronoun + " is a " + title + ". \n"
            + adjPronoun + " hobby/hobbies: " + stringArrayToString(array: hobbies) + ". \n"
            + "Language/languages " + personalPronoun + " knows: " + stringArrayToString(array: languages) + ". \n"
            + personalPronoun + " belongs to team: " + (team) + ". \n"
            + adjPronoun + " email address is: " + (email) + ". \n"
            + adjPronoun + "NetID is: " + (netid) + ". \n"
            + adjPronoun + "Department is: " + (department) + ". \n"
            + adjPronoun + "ID is: " + (id) + "."
    }
}
