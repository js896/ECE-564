//
//  Basketball.swift
//  ECE564_HW
//
//  Created by Jiawei Sun on 10/16/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class Basketball: UIView {

    override func draw(_ rect: CGRect) {
        let image = UIImage(named: "basketball")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.addSubview(imageView)
    }
}
