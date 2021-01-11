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
    
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var lblUnvailable: UILabel!
    
    @IBOutlet weak var imgeTypeBooking: UIImageView!
    @IBOutlet weak var lblBookingType: UILabel!
    
    
    //MARK:- Variable -
    
    var arrayAvailDate = [GetArtistDateList]()
    var arrayAvailDate2 = [String]()
    var arrayNoOfEvent = [String]()
    
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMainTitle.text = "select_date_booking".localized()
        lblSubTitle.text = "check_availabilty".localized()
        lblAvailable.text = "AVAILABLE".localized()
        lblUnvailable.text = "UNAVAILABLE".localized()
        btnBack.setTitle("back".localized(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewHeader.addBottomShadow()
        
        let dict = ["artist_id":userArtistID]
        self.getAvailableSlot(dict: dict)
        calenderView.appearance.todaySelectionColor = UIColor.systemPink
        self.calenderView.placeholderType = .none
        
        
        if   whicShowTypeDigital == false{
            //self.imgeTypeBooking.image = UIImage.init(named: "dot.radiowaves.left.and.right")
            lblBookingType.text = "VIRTUAL".localized()
        }else{
            //self.imgeTypeBooking.image = UIImage.init(named: "person.fill")
            lblBookingType.text = "IN-PERSON".localized()
        }
        
    }
    
    
    func getAvailableSlot(dict : [String:Any])  {
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.artistAvailableSlot, method: .post, param: dict, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    
                    
                    //                        self.arrayCardList.removeAll()
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            self.arrayAvailDate2.removeAll()
                            if let dataArray = result["data"] as? [[String : Any]]{
                                for index in dataArray{
                                    print("the index value is \(index)")
                                    let date = index["date"] as? String
                                    
                                    let dataDict = GetArtistDateList.init(resposne: index)
                                    self.arrayAvailDate.append(dataDict)
                                    self.arrayAvailDate2.append(date ?? "")
                                    
                                    
                                }
                            }
                            //                                self.calenderView.reloadData()
                            
                            
                            
                            
                        }
                        else{
                        }
                    }
                    else {
                        if let error_message = response["error"] as? [String:Any] {
                            if (error_message["error_message"] as? String) != nil {
                            }
                        }
                    }
                    self.calenderView.reloadData()
                    
                }
                else {
                    //self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
            }
            
        }else{
            // self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
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

extension SelectDateVC: FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        let currentDate = self.covertDate(date :date)
        print(currentDate)
        selectedDate  = currentDate
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.EditDateVC)
    }
    
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool{
        
        let currentDate = self.covertDate(date :date)
        print(currentDate)
        
        if self.arrayAvailDate2.contains(currentDate) { //MARK:- SELECTED DATE
            
            return true
            
        }else if date .compare(Date()) == .orderedAscending {     //MARK:- PAST DATE
            return false
            
        }else {
            return false
        }
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print(date)
        let currentDate = self.covertDate(date :date)
        print(currentDate)
        
        //        if self.arrayDateSelect.contains(dateChoose) == true{
        //            let indexOfB = arrayDateSelect.firstIndex(of:dateChoose )
        //            self.arrayDateSelect.remove(at: indexOfB ?? 0)
        //
        //        }
    }
    
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance,  titleDefaultColorFor date: Date) -> UIColor? {
        
        print(date)
        
        
        calendar.appearance.todaySelectionColor = UIColor.systemPink
        
        let currentDate = self.covertDate(date :date)
        print(currentDate)
        if self.arrayAvailDate2.contains(currentDate)
        {
            return UIColor.white
        }else if date .compare(Date()) == .orderedAscending {     //MARK:- PAST DATE
            return UIColor.lightGray
        }
        else{
            return UIColor.lightGray
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        print(date)
        let currentDate = self.covertDate(date :date)
        print(currentDate)
        if self.arrayAvailDate2.contains(currentDate) {
            arrayNoOfEvent.append(currentDate)
            return 1
        }else{
            return 0
            
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        print(date)
        
        let currentDateValue = Date()
        let currentDate = self.covertDate(date :date)
        print(currentDate)
        
        
        if self.arrayAvailDate2.contains(currentDate) {
            return UIColor.systemPink
        }else if date .compare(Date()) == .orderedAscending {     //MARK:- PAST DATE
            return UIColor.clear
        }
        
        else{
            return UIColor.init(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        }
        return UIColor.clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let currentDate = self.covertDate(date :date)
        print(currentDate)
        if self.arrayAvailDate2.contains(currentDate) {
            return UIColor.systemPink
        }else if date .compare(Date()) == .orderedAscending {     //MARK:- PAST DATE
            return UIColor.clear
        }else{
            return UIColor.init(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
            
        }
        return appearance.subtitleWeekendColor
    }
    
    
}
