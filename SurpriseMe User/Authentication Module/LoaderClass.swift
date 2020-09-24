//
//  LoaderClass.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 02/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class LoaderClass: UIViewController , NVActivityIndicatorViewable{
    
    static let shared = LoaderClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadAnimation() {
        self.startAnimating(CGSize(width: 50, height: 50), message: "", messageFont: UIFont(name: "Quicksand-Medium",size: 8), type: .lineScalePulseOut, color: UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1), padding: 2, displayTimeThreshold: 5, minimumDisplayTime: 5, backgroundColor: UIColor.init(red: 53/255.0, green: 50/255.0, blue: 50/255.0, alpha: 0.3), textColor: .darkGray, fadeInAnimation: nil)
    }
    
    func stopAnimation(){
    self.stopAnimating()
    }
}
