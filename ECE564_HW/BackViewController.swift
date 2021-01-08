//
//  BackViewController.swift
//  ECE564_HW
//
//  Created by Jiawei Sun on 9/28/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class BackViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var selectedPerson = DukePerson()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedPerson)
        backToFront()
        
       setUpContent()
    }
    
    func setUpContent() {
        textView.text = selectedPerson.firstname + " " + selectedPerson.lastname
        textView.textColor = .systemRed
        textView.textAlignment = .center
        textView.font = .monospacedDigitSystemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 10))
    }
    
    func backToFront() {
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(recognizer:)))
        recognizer.direction = .right
            self.view.addGestureRecognizer(recognizer)
    }
    
    @objc func swipeRight(recognizer : UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "BackToFront", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let informationVC = segue.destination as! InformationViewController
        informationVC.whichSegue = true
        
    }
    
    

    
}
