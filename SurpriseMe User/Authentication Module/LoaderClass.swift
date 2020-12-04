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
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white
    }
    
    func loadAnimation() {
        
        let array = ["Musicians want to be the loud voice for so many quiet hearts", "Music is the universal language of mankind", "If Music is a Place — then Jazz is the City", "Rock is the Road, Classical is a Temple","Music is the shorthand of emotion.","Music is the only language in which you cannot say a mean or sarcastic thing","Music is the art which is most nigh to tears and memory.","One good thing about music, when it hits you, you feel no pain","Where words fail, music speaks"]
               
               let randomColor = arc4random() % UInt32(array.count)


               let myDinner = array[Int(randomColor)]

               print("the random number is \(myDinner)")
        
              self.startAnimating(CGSize(width: 50, height: 50), message: myDinner, messageFont: UIFont(name: "Quicksand-Regular",size: 5), type: .lineScalePulseOut, color: UIColor.init(red: 212/255.0, green: 20/255.0, blue: 90/255.0, alpha: 1), padding: 5, displayTimeThreshold: 5, minimumDisplayTime: 5, backgroundColor: UIColor.white, textColor: .darkGray, fadeInAnimation: nil)
    }
    
    func stopAnimation(){
    self.stopAnimating()
    }
}
