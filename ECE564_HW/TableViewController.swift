//
//  TableViewController.swift
//  ECE564_HW
//
//  Created by Jiawei Sun on 9/15/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import shibauthframework2019

class TableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var sectionHeaderList = [String]()
    var personInfoList = [DukePerson]()
    var teamSet = Set<String>()
    
    var DukePeopleArray = [[DukePerson]] ()
    var filteredData = [[DukePerson]] ()
    var selectedPerson: DukePerson?
    
    @IBOutlet var peopleTableView: UITableView!
    
    func InitData() {
        

        var profSection = [DukePerson]()
        var taSection = [DukePerson]()
        var stuSection = [DukePerson]()
        
        for i in 0..<personInfoList.count {
            
            switch personInfoList[i].role {
            case "Professor":
                profSection.append(personInfoList[i])
            case "TA":
                taSection.append(personInfoList[i])
            default:
                stuSection.append(personInfoList[i])
            }
 
        }
        DukePeopleArray.append(profSection)
        DukePeopleArray.append(taSection)
        DukePeopleArray.append(stuSection)
    }
    
    func jpegToBase64 (_ image: UIImage) -> String {
        let compressed = resizeImage(image: image, targetSize: CGSize(width: 50.0, height: 100.0))
        let imageData: Data = compressed.jpegData(compressionQuality: 1)!
        let base64 = imageData.base64EncodedString()
        return base64
    }
    
    func pngToBase64 (_ image: UIImage) -> String {
        let compressed = resizeImage(image: image, targetSize: CGSize(width: 200.0, height: 200.0))
        let imageData: Data = compressed.pngData()!
        let base64 = imageData.base64EncodedString()
        return base64
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
    override func viewDidLoad() {
        super.viewDidLoad()
        loadList()
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
        searchBar.delegate = self
        showFramework()
        postMyEntry()
        getAllEntries(completionHandler: loadInitialData)
    }

    func checkTeam() {
        DukePeopleArray[2].forEach{ item in
            handleTeam(item)
        }
    }
    
    // MARK: - post my entry to server
    func postMyEntry() {
        let url = URL(string: "https://rt113-dt01.egr.duke.edu:5640/b64entries")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let username = "js896"
        let password = "21F1ABC655E5AA4AE548090D84B12543"
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        // JSON body
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonDict = [
            "id": "js896" as Any,
            "netid": "js896" as Any,
            "firstname": "Jiawei" as Any,
            "lastname": "Sun" as Any,
            "wherefrom": "China" as Any,
            "gender": "Male" as Any,
            "role": "Student" as Any,
            "degree": "Graduate" as Any,
            "team": "A mobile application that allows for video/audio calls and SMS messaging" as Any,
            "hobbies": ["Basketball", "Video Games"] as Any,
            "languages": ["Cpp", "Java", "Python"] as Any,
            "department": "ECE",
            "email": "jiawei.sun@duke.edu",
            "picture": jpegToBase64(UIImage(named: "Jiawei Sun")!)
        ] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        //print("-----------------------------------------")
        //print(String(data: jsonData, encoding: String.Encoding.utf8) as Any)
        request.httpBody = jsonData
        
        // Make POST request and catch any errors
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                print("error: ", error)
                return
            }
            do {
                print("data: \(data!)")
                print("response: \(response!)")
                guard let data = data else {return}
                guard (try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject])
                        != nil else {return}
            }
            catch {
                print("error: ", error)
            }
        }
        task.resume()
    }
    
    // MARK: - post updated me entry to server
    func postUpdatedMe(_ updatedMe: DukePerson) {
        let url = URL(string: "https://rt113-dt01.egr.duke.edu:5640/b64entries")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let username = "js896"
        let password = "21F1ABC655E5AA4AE548090D84B12543"
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        // JSON body
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonDict = [
            "id": updatedMe.id as Any,
            "netid": updatedMe.netid as Any,
            "firstname": "Jiawei" as Any,
            "lastname": "Sun" as Any,
            "wherefrom": updatedMe.wherefrom as Any,
            "gender": updatedMe.gender as Any,
            "role": updatedMe.role as Any,
            "degree": updatedMe.degree as Any,
            "team": updatedMe.team as Any,
            "hobbies": updatedMe.hobbies as Any,
            "languages": updatedMe.languages as Any,
            "department": updatedMe.department,
            "email": updatedMe.email,
            "picture": updatedMe.picture
        ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        //print("-----------------------------------------")
        //print(String(data: jsonData, encoding: String.Encoding.utf8) as Any)
        request.httpBody = jsonData
        
        // Make POST request and catch any errors
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                print("error: ", error)
                return
            }
            do {
                print("data: \(data!)")
                print("response: \(response!)")
                guard let data = data else {return}
                guard (try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject])
                        != nil else {return}
            }
            catch {
                print("error: ", error)
            }
        }
        task.resume()
    }
    
    // MARK: - get from server
    func getAllEntries(completionHandler: @escaping () -> Void) {
        let url = URL(string: "https://rt113-dt01.egr.duke.edu:5640/b64entries")!
        DispatchQueue.main.async {
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as?
                    HTTPURLResponse{
                    print("This statusCode is: \(response.statusCode)")
                }
                if let data = data, let _ = String(data: data, encoding: .utf8) {
                    let decoder = JSONDecoder()
                    if let decoded = try?
                        decoder.decode([DukePerson].self, from: data) {
                        self.personInfoList = decoded
                        completionHandler()
                    }
                }
            }
        }
        task.resume()
      }
    }
    
    func showFramework() {
        let alertController = LoginAlert(title: "Authenticate", message: nil, preferredStyle: .alert)
        alertController.delegate = self
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadList() {
        sectionHeaderList.append("Professor")
        sectionHeaderList.append("TA")
        sectionHeaderList.append("Student")
    }
    
    func loadInitialData() {
        if let tempToDos = DukePerson.loadToDoInfo() {
            DukePeopleArray = tempToDos
        } else {
            InitData()
            let _ = DukePerson.saveToDoInfo(DukePeopleArray)
        }
        checkTeam()
        filteredData = DukePeopleArray
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPerson = filteredData[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "showInformation", sender: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showInformation" {
            let informationVC = segue.destination as! InformationViewController
            informationVC.person = selectedPerson!
            informationVC.whichSegue = true
        } else {
            let navigationController = segue.destination as! UINavigationController
            let informationVC = navigationController.viewControllers.first as! InformationViewController
            informationVC.whichSegue = false
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
           
        header.text = sectionHeaderList[section]
                
        header.backgroundColor = UIColor.lightGray
        return header
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return filteredData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = filteredData[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell") as! PersonCell
        cell.setPeople(person: person)
        return cell
    }
    //right swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            DukePeopleArray[indexPath.section].remove(at: indexPath.row)
            filteredData = DukePeopleArray
            self.tableView.reloadData()
            
        }
    }
    
    @IBAction func returnByCancell(segue: UIStoryboardSegue) {}
    
    @IBAction func returnFromEdit(segue: UIStoryboardSegue) {
    
    let source: InformationViewController = segue.source as! InformationViewController
    let updatedPerson: DukePerson = source.newPerson
    var  entry: Int
    switch updatedPerson.role {
    case "Professor":
        entry = 0
    case "TA":
        entry = 1
    default:
        entry = 2
    }
    //didn't change role
    if let targetOffset = DukePeopleArray[entry].firstIndex(where: {$0.firstname == updatedPerson.firstname && $0.lastname == updatedPerson.lastname}) {
        DukePeopleArray[entry].remove(at: targetOffset)
        DukePeopleArray[entry].append(updatedPerson)
    }
    //role changed
    else {
        for i in 0..<DukePeopleArray.count {
            if let targetOffset = DukePeopleArray[i].firstIndex(where: {$0.firstname == updatedPerson.firstname && $0.lastname == updatedPerson.lastname}) {
                DukePeopleArray[i].remove(at: targetOffset)
            }
        }
        DukePeopleArray[entry].append(updatedPerson)
    }
    if entry == 2 && updatedPerson.team != ""{
        if updatedPerson.firstname == "Jiawei" {
            postUpdatedMe(updatedPerson)
        }
        handleTeam(updatedPerson)
    }
        filteredData = DukePeopleArray
        self.tableView.reloadData()
    }
    // MARK: handle new team added
    //handle new team added
    func handleTeam(_ updatedPerson: DukePerson) {
        if !teamSet.contains(updatedPerson.team) {
            teamSet.insert(updatedPerson.team)
            sectionHeaderList.append(updatedPerson.team)
            var newSection = [DukePerson]()
            newSection.append(updatedPerson)
            DukePeopleArray.append(newSection)
        }
        else {
            DukePeopleArray[sectionHeaderList.firstIndex(of: updatedPerson.team)!].append(updatedPerson)
        }
        if let targetOffset = DukePeopleArray[2].firstIndex(where: {$0.firstname == updatedPerson.firstname && $0.lastname == updatedPerson.lastname}) {
            DukePeopleArray[2].remove(at: targetOffset)
        }
    }
    
    @IBAction func returnFromAddNew(segue: UIStoryboardSegue) {
        let source: InformationViewController = segue.source as! InformationViewController
        let newPerson: DukePerson = source.newPerson
        var role: String
        switch newPerson.role {
        case "Professor":
            role = "Professor"
        case "TA":
            role = "TA"
        default:
            role = "Student"
        }
        
        if role != "Student" || newPerson.team == "" {
            DukePeopleArray[sectionHeaderList.firstIndex(of: role)!].append(newPerson)
        }
        else {
            if teamSet.contains(newPerson.team) {
                DukePeopleArray[sectionHeaderList.firstIndex(of: newPerson.team)!].append(newPerson)
            }
            else {
                teamSet.insert(newPerson.team)
                sectionHeaderList.append(newPerson.team)
                var newSection = [DukePerson]()
                newSection.append(newPerson)
                DukePeopleArray.append(newSection)
            }
        }
        filteredData = DukePeopleArray
        self.tableView.reloadData()
    }

// MARK: Search Bar Config
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = [[],[],[]]
        if searchText == "" {
            filteredData = DukePeopleArray
        } else {
        for i in 0..<DukePeopleArray.count {
        for person in DukePeopleArray[i] {
            if person.description.lowercased().contains(searchText.lowercased()) {
                switch person.role {
                case "Professor":
                    filteredData[0].append(person)
                case "TA":
                    filteredData[1].append(person)
                default:
                    filteredData[2].append(person)
                }
            }
        }
        }
    }
        self.tableView.reloadData()
    }
    
}
// MARK: Login
extension TableViewController: LoginAlertDelegate {
    
    func onSuccess(_ loginAlertController: LoginAlert, didFinishSucceededWith status: LoginResults, netidLookupResult: NetidLookupResultData?, netidLookupResultRawData: Data?, cookies: [HTTPCookie]?, lastLoginTime: Date) {
        // succeeded, extract netidLookupResult.id and netidLookupResult.password for your server credential
        // other properties needed for homework are also in netidLookupResult
        alertStatus(status)
        print("success")
        
    }
    
    func onFail(_ loginAlertController: LoginAlert, didFinishFailedWith reason: LoginResults) {
        // when authentication fails, this method will be called.
        // default implementation provided
        alertStatus(reason)
        print("Fail")
    }
    
    func inProgress(_ loginAlertController: LoginAlert, didSubmittedWith status: LoginResults) {
        // this method will get called for each step in progress.
        // default implementation provided
        alertStatus(status)
        print("in progress")
    }
    
    func alertStatus(_ status: LoginResults) {
        switch status {
        case .ShibURLNotAccessible:
            displayAlertMessage(title: "Status", message: "ShibURLNotAccessible")
        case .MultiFactorRequired:
            displayAlertMessage(title: "Status", message: "MultiFactorRequired")
        case .UsernamePasswordEmpty:
            displayAlertMessage(title: "Status", message: "UsernamePasswordEmpty")
        case .UsernamePasswordWrong:
            displayAlertMessage(title: "Status", message: "UsernamePasswordWrong")
        case .LoginSucceeded:
            displayAlertMessage(title: "Status", message: "LoginSucceeded")
        case .UsernamePasswordSubmitted:
            displayAlertMessage(title: "Status", message: "UsernamePasswordSubmitted")
        case .IllegalNavigation:
            displayAlertMessage(title: "Status", message: "IllegalNavigation")
        default:
            displayAlertMessage(title: "Status", message: "UnknownNavigation")
        }
    }
    
    func displayAlertMessage(title: String, message: String) {
         let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          alert.dismiss(animated: true, completion: nil)
        }
     }
    
    func onLoginButtonTapped(_ loginAlertController: LoginAlert) {
        // the login button on the alert is tapped
        // default implementation provided
        print("on tapped")
        DispatchQueue.main.async {
            self.displayAlertMessage(title: "Notice", message: "Login Button tapped")
        let when = DispatchTime.now() + 20
            DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
            self.timeoutAlertMessage(title: "Notice", message: "The request time out, using hard-coded token instead")
        }
        }
    }
    
    func timeoutAlertMessage(title: String, message: String) {
         let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
     }

    func onCancelButtonTapped(_ loginAlertController: LoginAlert) {
        // the cancel button on the alert is tapped
        // default implementation provided
        print("cancell")
    }
}


