//
//  SelectDateVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 13/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import FSCalendar


class SelectDateVC: UIViewController {
    //MARK:- Outlets -
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var calenderView: FSCalendar!
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewHeader.addBottomShadow()

    }
    
    //MARK:- Custom Button Action -
    @IBAction func backAction(_ sender: UIButton) {
        self.back()
    }
    
    func covertDate(date :Date)  -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"
        let myString = formatter.string(from: date) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "yyyy-MM-dd"
        // again convert your date to string
        let dateInString = formatter.string(from: yourDate!)
        print(dateInString)
        return dateInString
    }
}

extension SelectDateVC: FSCalendarDataSource, FSCalendarDelegate{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        let currentDate = self.covertDate(date :date)
        print(currentDate)
        selectedDate  = currentDate
         self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.EditDateVC)
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date .compare(Date()) == .orderedAscending {
            return false
        }
        else {
            return true
        }
    }
    
    
}
