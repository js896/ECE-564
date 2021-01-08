//
//  InformationViewController.swift
//  ECE564_HW
//
//  Created by Jiawei Sun on 9/5/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {
    @IBOutlet weak var First: UITextField!
    @IBOutlet weak var Last: UITextField!
    @IBOutlet weak var From: UITextField!
    @IBOutlet weak var Degree: UITextField!
    @IBOutlet weak var Gender: UITextField!
    @IBOutlet weak var Role: UITextField!
    @IBOutlet weak var Hobbies: UITextField!
    @IBOutlet weak var Languages: UITextField!
    @IBOutlet weak var Team: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var editSaveButton: UIBarButtonItem!
    @IBOutlet weak var NetID: UITextField!
    @IBOutlet weak var Department: UITextField!
    @IBOutlet weak var ID: UITextField!
    
    let genders = ["Male", "Female"]
    let roles = ["Student", "TA", "Professor"]
    
    var genderPickerView = UIPickerView()
    var rolePickerView = UIPickerView()
    
    var person = DukePerson()
    
    var newPerson = DukePerson()
    
    var whichSegue = true
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        genderPickerView.tag = 0
        rolePickerView.tag = 1
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        rolePickerView.delegate = self
        rolePickerView.dataSource = self
        
        Gender.inputView = genderPickerView
        Role.inputView = rolePickerView
        
        
        if whichSegue == true {
            presentInfo()
            goToBackSide()
        } else {
            changeBarButtonItem()
            enableImagePicker()

        }
    }
    
    func goToBackSide() {
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(recognizer:)))
        recognizer.direction = .left
            self.view.addGestureRecognizer(recognizer)
    }
    
    @objc func swipeLeft(recognizer : UISwipeGestureRecognizer) {
        if person.firstname == "Jiawei" {
            self.performSegue(withIdentifier: "GoToMyBack", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "GoToBack", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "GoToBack" else {return}
        let backViewController = segue.destination as! BackViewController
        backViewController.selectedPerson = person
    }
    
    func enableImagePicker () {
        Image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        Image.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
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
    
    func presentInfo() {
        First.text = person.firstname
        First.isUserInteractionEnabled = false
        Last.text = person.lastname
        Last.isUserInteractionEnabled = false
        From.text = person.wherefrom
        From.isUserInteractionEnabled = false
        Degree.text = person.degree
        Degree.isUserInteractionEnabled = false
        Gender.text = "\(person.gender)"
        Gender.isUserInteractionEnabled = false
        Role.text = "\(person.role)"
        Role.isUserInteractionEnabled = false
        Hobbies.text = stringArrayToString(array: person.hobbies)
        Hobbies.isUserInteractionEnabled = false
        Languages.text = stringArrayToString(array: person.languages)
        Languages.isUserInteractionEnabled = false
        Team.text = person.team
        Team.isUserInteractionEnabled = false
        Email.text = person.email
        Email.isUserInteractionEnabled = false
        let imageData = Data(base64Encoded: person.picture)
        Image.image = UIImage(data: imageData! as Data)
        Image.isUserInteractionEnabled = false
        NetID.text = person.netid
        NetID.isUserInteractionEnabled = false
        Department.text = person.department
        Department.isUserInteractionEnabled = false
        ID.text = person.id
        ID.isUserInteractionEnabled = false
    }
    func changeBarButtonItem() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.backToTable))
        self.navigationItem.rightBarButtonItem = saveButton
    }

    
    @IBAction func editPressed(_ sender: Any) {
        enableImagePicker()
        From.isUserInteractionEnabled = true
        Degree.isUserInteractionEnabled = true
        Gender.isUserInteractionEnabled = true
        Role.isUserInteractionEnabled = true
        Hobbies.isUserInteractionEnabled = true
        Languages.isUserInteractionEnabled = true
        Team.isUserInteractionEnabled = true
        Email.isUserInteractionEnabled = true
        NetID.isUserInteractionEnabled = true
        Department.isUserInteractionEnabled = true
        ID.isUserInteractionEnabled = true
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.changeInfo))
        self.navigationItem.rightBarButtonItem = saveButton
        displayAlertMessage(title: "Notice", message: "Don't change name!")
    }
    
    @objc func backToTable() {
        if  First.text == "" || Last.text == "" || From.text == "" || Degree.text == "" || Gender.text == "" || Role.text == "" || Hobbies.text == "" || Languages.text == "" || Email.text == "" || NetID.text == "" || Department.text == "" || ID.text == ""{
        } else {
        makeNewPerson()
        performSegue(withIdentifier: "newPersonAdded", sender: nil)
        }
    }
    
    func stringToStringArray(string: String) ->[String] {
        let array = string.components(separatedBy:",")
        return array
    }
    
    func makeNewPerson() {
        newPerson.firstname = First.text!
        newPerson.lastname = Last.text!
        newPerson.wherefrom = From.text!
        newPerson.degree = Degree.text!
        if Gender.text == "Male" {
            newPerson.gender = "Male"
        } else {
            newPerson.gender = "Female"
        }
        switch Role.text {
        case "Professor":
            newPerson.role = "Professor"
        case "TA":
            newPerson.role = "TA"
        default:
            newPerson.role = "Student"
        }
        newPerson.hobbies = stringToStringArray(string: Hobbies.text!)
        newPerson.languages = stringToStringArray(string: Languages.text!)
        newPerson.team = Team.text!
        newPerson.email = Email.text!
        let compressed = resizeImage(image: Image.image!, targetSize: CGSize(width: 200.0, height: 200.0))
        let imageData: Data = compressed.jpegData(compressionQuality: 1)!
        let base64 = imageData.base64EncodedString()
        newPerson.picture = base64
        newPerson.netid = NetID.text!
        newPerson.department = Department.text!
        newPerson.id = ID.text!
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    @objc func changeInfo () {
        if  First.text == "" || Last.text == "" || From.text == "" || Degree.text == "" || Gender.text == "" || Role.text == "" || Hobbies.text == "" || Languages.text == "" || Email.text == "" || NetID.text == "" || Department.text == "" || ID.text == ""{
        } else {
            makeNewPerson()
            performSegue(withIdentifier: "backToTableView", sender: nil)
        }
    }

    @IBAction func Clear(_ sender: Any) {
        First.text = ""
        Last.text = ""
        From.text = ""
        Degree.text = ""
        Gender.text = ""
        Role.text = ""
        Hobbies.text = ""
        Languages.text = ""
        Team.text = ""
        Email.text = ""
        NetID.text = ""
        Department.text = ""
        ID.text = ""
        Image.image = UIImage(named: "BLM-678x381")
    }
    
   func displayAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func returnFromBack(segue: UIStoryboardSegue) {
        
    }
    @IBAction func returnFromMyBack(segue: UIStoryboardSegue) {
        
    }
}


// MARK: PickerView implementation roles and genders
extension InformationViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return genders.count
        } else {
            return roles.count
        }
        
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return genders[row]
        } else {
            return roles[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            Gender.text = genders[row]
            Gender.resignFirstResponder()
        } else {
            Role.text = roles[row]
            Role.resignFirstResponder()
        }
        
    }
}
    
// MARK: ImageViewPickerController
extension InformationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            Image.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            Image.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
