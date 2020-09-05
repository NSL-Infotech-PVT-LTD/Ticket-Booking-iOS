//
//  FilterViewController.swift
//  SwiftApp_Demo
//
//  Created by Apple on 27/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var priceHtoLOut: UILabel!
    @IBOutlet weak var priceLtoHLbl: UILabel!
    @IBOutlet weak var desendingNameOut: UILabel!
    @IBOutlet weak var ascendingNameLblOut: UILabel!
    @IBOutlet weak var slider_out: UISlider!
    @IBOutlet weak var electronicBtn_out: UIButton!
    @IBOutlet weak var hiphop_out: UIButton!
    @IBOutlet weak var bollywoodBtn_out: UIButton!
    @IBOutlet weak var jazzBtn_out: UIButton!
    @IBOutlet weak var operaBtn_out: UIButton!
    @IBOutlet weak var classicalBtn_out: UIButton!
    @IBOutlet weak var hollywoodBtn_out: UIButton!
    
    @IBOutlet weak var fromView_out: UIView!
    @IBOutlet weak var toView_out: UIView!
    
    @IBOutlet weak var countLbl_OUt: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Buttons Border Colors and Width
        electronicBtn_out.layer.borderColor = UIColor.lightGray.cgColor
        electronicBtn_out.layer.borderWidth = 1
        electronicBtn_out.layer.cornerRadius = 10
        hiphop_out.layer.borderColor = UIColor.lightGray.cgColor
        hiphop_out.layer.borderWidth = 1
        hiphop_out.layer.cornerRadius = 10
        bollywoodBtn_out.layer.borderColor = UIColor.lightGray.cgColor
        bollywoodBtn_out.layer.borderWidth = 1
        bollywoodBtn_out.layer.cornerRadius = 10
        jazzBtn_out.layer.borderColor = UIColor.lightGray.cgColor
        jazzBtn_out.layer.borderWidth = 1
        jazzBtn_out.layer.cornerRadius = 10
        operaBtn_out.layer.borderColor = UIColor.lightGray.cgColor
        operaBtn_out.layer.borderWidth = 1
        operaBtn_out.layer.cornerRadius = 10
        classicalBtn_out.layer.borderColor = UIColor.lightGray.cgColor
        classicalBtn_out.layer.borderWidth = 1
        classicalBtn_out.layer.cornerRadius = 10
        hollywoodBtn_out.layer.borderColor = UIColor.lightGray.cgColor
        hollywoodBtn_out.layer.borderWidth = 1
        hollywoodBtn_out.layer.cornerRadius = 10
        
        
        
        
       //View Setup
        fromView_out.layer.borderColor = UIColor.lightGray.cgColor
        fromView_out.layer.borderWidth = 1
        fromView_out.layer.cornerRadius = 6
        toView_out.layer.borderColor = UIColor.lightGray.cgColor
        toView_out.layer.borderWidth = 1
        toView_out.layer.cornerRadius = 6
        
        countLbl_OUt.layer.borderColor = UIColor.lightGray.cgColor
        countLbl_OUt.layer.borderWidth = 1
        countLbl_OUt.layer.cornerRadius = 6
        
    }
    
    @IBAction func toBtnTap(_ sender: Any) {
    }
    @IBAction func fromBtnTap(_ sender: Any) {
    }
    
    @IBAction func electronicTapBtn(_ sender: Any) {
    }
    
    @IBAction func hihopTapBtn(_ sender: Any) {
    }
    
    @IBAction func bollywoodTapBtn(_ sender: Any) {
    }
    
    @IBAction func jazzTapBtn(_ sender: Any) {
    }
    
    @IBAction func operaTapBtn(_ sender: Any) {
    }
    
    @IBAction func classicalTapBtn(_ sender: Any) {
    }
    
    @IBAction func hollywoodTapBtn(_ sender: Any) {
    }
    
    @IBAction func applySearchBtn(_ sender: Any) {
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
    }
    
}
