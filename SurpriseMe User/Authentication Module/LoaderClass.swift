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
    
    //MARK:- Variable -
    static let shared = LoaderClass()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white
    }
    
    //MARK:- Load Animation -
    func loadAnimation() {
        let array = ["MUSICIANS_HEARTS".localized(), "MUSIC_UNIVERSAL_LANG".localized(), "MUSIC_IS_PLACE".localized(), "ROCK_RODE".localized(),"MUSIC_EMOTION".localized(),"MUSIC_LANGUAGE".localized(),"MUSIC_IS_ART".localized(),"ONE_GOOD_THING".localized(),"WORDFAIL_MUSICSPEAK".localized()]
        let randomColor = arc4random() % UInt32(array.count)
        let myDinner = array[Int(randomColor)]
        self.startAnimating(CGSize(width: 50, height: 50), message: myDinner, messageFont: UIFont(name: "Poppins-Regular",size: 3), type: .lineScalePulseOut, color: UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1), padding: 5, displayTimeThreshold: 5, minimumDisplayTime: 5, backgroundColor: UIColor.white, textColor: .darkGray, fadeInAnimation: nil)
    }
    
    //MARK:- Stop Animation -
    func stopAnimation(){
        self.stopAnimating()
    }
}
