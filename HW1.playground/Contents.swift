//: This is the playground file to use for submitting HW1.  You will add your code where noted below.  Make sure you only put the code required at load time in the ``loadView()`` method.  Other code should be set up as additional methods (such as the code called when a button is pressed).
  
import UIKit
import PlaygroundSupport

enum Gender : String {
    case Male = "Male"
    case Female = "Female"
}

class Person {
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
}

enum DukeRole : String {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "Teaching Assistant"
}

enum DukeProgram : String {
    case Undergrad = "Undergrad"
    case Grad = "Grad"
    case NA = "Not Applicable"
}

// You can add code here

class DukePerson : Person{
    var role: DukeRole
    var program: DukeProgram
    init(firstName: String, lastName: String, whereFrom: String, gender: Gender, role: DukeRole, program: DukeProgram) {
        self.role = role
        self.program = program
        super.init()
        self.firstName = firstName
        self.lastName = lastName
        self.whereFrom = whereFrom
        self.gender = gender
    }
}

extension DukePerson: CustomStringConvertible {
    var description: String {
        var personalPronoun: String
            if (gender) == .Male{
                personalPronoun = "he"
            } else {
                personalPronoun = "she"
            }
        var title: String
        if (role) == .Student {
            title = "student"
        } else if (role) == .Professor {
            title = "professor"
        } else {
            title = "TA"
        }
        return "\(firstName) \(lastName) is from \(whereFrom), " + personalPronoun + " is a " + title + "."
    }
}

//original data
var DukePeople: [DukePerson] = [
    .init(firstName: "Ric", lastName: "Telford", whereFrom: "Chatham County, NC", gender: .Male, role: .Professor, program: .NA),
    .init(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: .Male, role: .TA, program: .Grad),
    .init(firstName: "Yuchen", lastName: "Yang", whereFrom: "China", gender: .Female, role: .TA, program: .Grad),
    .init(firstName: "Jiawei", lastName: "Sun", whereFrom: "China", gender: .Male, role: .Student, program: .Grad),
]


class HW1ViewController : UIViewController {
    var firstName: UITextField!
    var lastName: UITextField!
    var from: UITextField!
    var outPut: UITextField!
    var gender: UISegmentedControl!
    var role: UISegmentedControl!
    var program: UISegmentedControl!
    var addUpdateButton: UIButton!
    var findButton: UIButton!
    let genderItems = ["Male", "Female"]
    let roleItems = ["Prof", "TA", "Student"]
    let programItems = ["Undergrad", "Grad", "Not Applicable"]
    override func loadView() {
// You can change color scheme if you wish
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect(x: 100, y: 10, width: 200, height: 20)
        label.text = "ECE 564 Homework 1"
        label.textColor = .black
        view.addSubview(label)
        self.view = view
        
        firstName = UITextField()
        firstName.borderStyle = .roundedRect
        firstName.text = ""
        firstName.frame = CGRect(x: 100, y: 50, width: 200, height: 20)
        view.addSubview(firstName)
        
        lastName = UITextField()
        lastName.borderStyle = .roundedRect
        lastName.text = ""
        lastName.frame = CGRect(x: 100, y: 80, width: 200, height: 20)
        view.addSubview(lastName)
        
        from = UITextField()
        from.borderStyle = .roundedRect
        from.text = ""
        from.frame = CGRect(x: 100, y: 110, width: 200, height: 20)
        view.addSubview(from)
        
        let firstNameLabel = UILabel()
        firstNameLabel.frame = CGRect(x: 10, y: 50, width: 100, height: 20)
        firstNameLabel.text = "First Name"
        firstNameLabel.textColor = .black
        view.addSubview(firstNameLabel)
        
        let lastNameLabel = UILabel()
        lastNameLabel.frame = CGRect(x: 10, y:80, width: 100, height: 20)
        lastNameLabel.text = "Last Name"
        lastNameLabel.textColor = .black
        view.addSubview(lastNameLabel)
        
        let fromLabel = UILabel()
        fromLabel.frame = CGRect(x: 10, y: 110, width: 100, height: 20)
        fromLabel.text = "From"
        fromLabel.textColor = .black
        view.addSubview(fromLabel)
        
        addUpdateButton = UIButton(type: .system)
        addUpdateButton.setTitle("Add/Update", for: .normal)
        addUpdateButton.frame = CGRect(x: 20, y:350, width: 150, height: 40)
        addUpdateButton.tintColor = UIColor.black
        addUpdateButton.backgroundColor = UIColor.lightGray
        view.addSubview(addUpdateButton)
        addUpdateButton.addTarget(self, action: #selector(executeAandU), for: .touchUpInside)
        
        findButton = UIButton(type: .system)
        findButton.setTitle("Find", for: .normal)
        findButton.frame = CGRect(x: 200, y:350, width: 150, height: 40)
        findButton.tintColor = UIColor.black
        findButton.backgroundColor = UIColor.lightGray
        view.addSubview(findButton)
        findButton.addTarget(self, action: #selector(executeFind), for: .touchUpInside)
        
        outPut = UITextField()
        outPut.borderStyle = .none
        outPut.text = ""
        outPut.frame = CGRect(x: 5, y: 420, width: 400, height: 100)
        outPut.textColor = .black
        outPut.adjustsFontSizeToFitWidth = true;
        outPut.minimumFontSize = 8
        view.addSubview(outPut)
        
        gender = UISegmentedControl(items: genderItems)
        gender.addTarget(self, action: #selector(updateGender), for: .valueChanged)
        gender.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gender)
        
        role = UISegmentedControl(items: roleItems)
        role.addTarget(self, action: #selector(updateRole), for: .valueChanged)
        role.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(role)
        
        program = UISegmentedControl(items: programItems)
        program.addTarget(self, action: #selector(updateProgram), for: .valueChanged)
        program.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(program)
        
        NSLayoutConstraint.activate([
           gender.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           gender.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
           role.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           role.topAnchor.constraint(equalTo: view.topAnchor, constant: 190),
           program.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           program.topAnchor.constraint(equalTo: view.topAnchor, constant: 240),
        ])
    }
    
    //The three functions below are placeholders
    @objc func updateGender() {}
    @objc func updateRole() {}
    @objc func updateProgram() {}
    
    //This method deals with the "Find" Button
    @objc func executeFind(_ sender:UIButton!) {
        
        if let targetOffset = DukePeople.firstIndex(where: {$0.firstName == firstName.text! && $0.lastName == lastName.text! && $0.whereFrom == from.text!}) {
            outPut.text = "\(DukePeople[targetOffset])"
            //decide gender
            if DukePeople[targetOffset].gender == .Male{
                gender.selectedSegmentIndex = 0
            } else {
                gender.selectedSegmentIndex = 1
            }
            //decide program
            switch DukePeople[targetOffset].program {
            case .Undergrad:
                program.selectedSegmentIndex = 0
     
            case .Grad:
                program.selectedSegmentIndex = 1
            
            default:
                program.selectedSegmentIndex = 2
            }
            //decide role
            switch DukePeople[targetOffset].role {
            case .Professor:
                role.selectedSegmentIndex = 0
            
            case .TA:
                role.selectedSegmentIndex = 1
            
            default:
                role.selectedSegmentIndex = 2
            }
        } else {
            outPut.text = "The person was not found"
        }
    }
    
    //This function deals with the "Add/Update" button
    @objc func executeAandU (_sender:UIButton!) {
        var genderNew: Gender
        var roleNew: DukeRole
        var programNew: DukeProgram
        //decide new gender
        let genderSelected = gender.titleForSegment(at: gender.selectedSegmentIndex)
        if genderSelected == "Male" {
            genderNew = .Male
        } else {
            genderNew = .Female
        }
        //decide new role
        let roleSelected = role.titleForSegment(at: role.selectedSegmentIndex)
        switch roleSelected {
        case "Prof":
            roleNew = .Professor
        case "TA":
            roleNew = .TA
        default:
            roleNew = .Student
        }
        //decide new program
        let programSelected = program.titleForSegment(at: program.selectedSegmentIndex)
        switch programSelected {
        case "Undergrad":
            programNew = .Undergrad
        case "Grad":
            programNew = .Grad
        default:
            programNew = .NA
        }

        if let targetOffset = DukePeople.firstIndex(where: {$0.firstName == firstName.text! && $0.lastName == lastName.text!}) {
            //remove outdated object from the array
            DukePeople.remove(at: targetOffset)
            outPut.text = "The person has been updated"
        } else {
            outPut.text = "The person has been added"
        }
        //add new DukePersion object to array
        let newPerson = DukePerson(firstName: firstName.text!, lastName: lastName.text!, whereFrom: from.text!, gender: genderNew, role: roleNew, program: programNew)
        DukePeople.append(newPerson)
        //outPut.text = "The person has been added"
    }
}
// Don't change the following line - it is what allowsthe view controller to show in the Live View window
PlaygroundPage.current.liveView = HW1ViewController()
