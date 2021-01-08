//
//  PersonCell.swift
//  ECE564_HW
//
//  Created by Jiawei Sun on 9/15/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personDescriptionLabel: UILabel!
    

    
    func setPeople(person: DukePerson) {
        let imageData = Data(base64Encoded: person.picture, options: .ignoreUnknownCharacters)
        personImageView.image = UIImage(data: imageData! as Data)
        personNameLabel.text = person.firstname + " " + person.lastname
        personDescriptionLabel.text = person.description
        personNameLabel.adjustsFontSizeToFitWidth = true;
        personNameLabel.minimumScaleFactor = 0.5;
        personDescriptionLabel.adjustsFontSizeToFitWidth = true;
        personDescriptionLabel.minimumScaleFactor = 0.5;
        personNameLabel.sizeToFit()
        personDescriptionLabel.sizeToFit()
    }
}
