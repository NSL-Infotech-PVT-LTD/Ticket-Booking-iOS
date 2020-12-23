//
//  FilterViewController.swift
//  SwiftApp_Demo
//
//  Created by Apple on 27/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import StepSlider
import FSCalendar


protocol SendDataPrevoius {
    func getFilterData(message:String,response:[SearchArtistModel])
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var priceHtoLOut: UILabel!
    @IBOutlet weak var priceLtoHLbl: UILabel!
    @IBOutlet weak var desendingNameOut: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var ascendingNameLblOut: UILabel!
    @IBOutlet weak var slider_out: UISlider!
    @IBOutlet weak var electronicBtn_out: UIButton!
    @IBOutlet weak var hiphop_out: UIButton!
    @IBOutlet weak var bollywoodBtn_out: UIButton!
    @IBOutlet weak var jazzBtn_out: UIButton!
    @IBOutlet weak var operaBtn_out: UIButton!
    @IBOutlet weak var classicalBtn_out: UIButton!
    @IBOutlet weak var hollywoodBtn_out: UIButton!
    @IBOutlet weak var viewSelectArtist: UIView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var secondDatePicker: UIDatePicker!
    @IBOutlet weak var lblArtistCategpry: UILabel!
    
    @IBOutlet weak var calenderView: FSCalendar!
    
    @IBOutlet var lblTOpVirtualConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fromView_out: UIView!
    @IBOutlet weak var viewSecondBtn: UIView!
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var viewFirstBtn: UIView!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var distanceLblTitle: UILabel!
    @IBOutlet weak var viewDateContainer: UIView!
    @IBOutlet weak var toView_out: UIView!
    @IBOutlet weak var ratingSlider: StepSlider!
    @IBOutlet weak var distanceSlider: UISlider!
    
    
    var delegate :SendDataPrevoius?
    var objectViewModel = FilterArtistDataViewModel()
    var arrayHomeArtistList = [SearchArtistModel]()
    var startDate = String()
    var endDate = String()
    var fromDate = false
    var selectedRating = 4.5
    var distance = 200
    var sortByValue = String()
    var isFirstSelected = false
    
    
    
    @IBOutlet weak var countLbl_OUt: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingSlider.labels = ["5","4.5","4.0","3.5","Any"]
//        self.headerView.roundCorners(corners: [.topLeft,.topRight], radius: 25.0)
        countLbl_OUt.layer.borderColor = UIColor.lightGray.cgColor
        countLbl_OUt.layer.borderWidth = 1
        countLbl_OUt.layer.cornerRadius = 6
        
        self.calenderView.placeholderType = .none

        
        let tapviewChangePassword = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewChangePassword(_:)))
        viewSelectArtist.addGestureRecognizer(tapviewChangePassword)
        self.objectViewModel.delegate = self
        
        
        let tapviewFirstBtn = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewFirstBtn(_:)))
        viewFirstBtn.addGestureRecognizer(tapviewFirstBtn)
        
        let tapviewSecondBtn = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewSecondBtn(_:)))
        viewSecondBtn.addGestureRecognizer(tapviewSecondBtn)
        
        
        
        
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        print(formatter.string(from: datePicker.date))
        startDate = formatter.string(from: datePicker.date)
        print(startDate)
        self.lblFromDate.text = startDate
        self.view.endEditing(true)
    }
    
    @objc func seconddateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        print(formatter.string(from: secondDatePicker.date))
        
        endDate = formatter.string(from: secondDatePicker.date)
        print(endDate)
        
        self.toDateLbl.text = endDate

        self.view.endEditing(true)
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDateContainer.isHidden = true
        
        
        if whicShowTypeDigital == true{
            distanceView.isHidden = false
            distanceLblTitle.isHidden = false
            lblTOpVirtualConstraint.constant = 160
       }else{
            distanceView.isHidden = true
            distanceLblTitle.isHidden = true
            lblTOpVirtualConstraint.constant = 28

        }
                
        if  dictFilter.count > 0{
            
            let distance = dictFilter["distance"] as? Int
            self.lblDistance.text = "\(distance ?? 0)km"
            distanceSlider.setValue(Float(distance ?? 0), animated: true)
            let sliderValue = dictFilter["rating"] as? Double
            
            
            if sliderValue == 4.5{
                ratingSlider.setIndex(1, animated: true)

            }else if sliderValue == 4.0{
                ratingSlider.setIndex(2, animated: true)

            }else if sliderValue == 3.5{
                ratingSlider.setIndex(3, animated: true)

            }else {
                ratingSlider.setIndex(4, animated: true)

            }
           let selectionValue = dictFilter["selection"] as? String
            if  selectionValue == "desc"{
                btnFirst.setImage(UIImage(named: "tick_unselect"), for: .normal)
                btnSecond.setImage(UIImage(named: "tick"), for: .normal)
                sortByValue = "desc"
            }else{
                btnSecond.setImage(UIImage(named: "tick_unselect"), for: .normal)
                btnFirst.setImage(UIImage(named: "tick"), for: .normal)
                sortByValue = "asc"
            }
       }else{
            ratingSlider.setIndex(4, animated: true)
        }
        
        
        
        
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: +1, to: Date())
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        secondDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: +1, to: Date())
        secondDatePicker.addTarget(self, action: #selector(seconddateChanged(_:)), for: .valueChanged)
        sortByValue = "asc"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchHappen(_:)))
        fromView_out.addGestureRecognizer(tap)
        fromView_out.isUserInteractionEnabled = true
//
//        btnFirst.setImage(UIImage(named: "tick_unselect"), for: .normal)
//        btnSecond.setImage(UIImage(named: "tick_unselect"), for: .normal)
        if arrayCategorySelectedName.count > 0{
            lblArtistCategpry.font = lblArtistCategpry.font.withSize(12)
            lblArtistCategpry.text = arrayCategorySelectedName.joined(separator: ",")
        }else{
            lblArtistCategpry.font = lblArtistCategpry.font.withSize(14)
            lblArtistCategpry.text = "Click to choose category"
        }
        
        
    }
    
    @objc func touchHappen(_ sender: UITapGestureRecognizer) {
        print("Hello Dear you are here")
   }
    
    
    
    @objc func handletapviewChangePassword(_ sender: UITapGestureRecognizer? = nil) {
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.GetArtistCategoryVC)
    }
    
    
    @objc func handletapviewFirstBtn(_ sender: UITapGestureRecognizer? = nil) {
         btnSecond.setImage(UIImage(named: "tick_unselect"), for: .normal)
           btnFirst.setImage(UIImage(named: "tick"), for: .normal)
       }
    
    
    @objc func handletapviewSecondBtn(_ sender: UITapGestureRecognizer? = nil) {
      btnFirst.setImage(UIImage(named: "tick_unselect"), for: .normal)
        btnSecond.setImage(UIImage(named: "tick"), for: .normal)
    }
    
    
    
    
    @IBAction func btnSecondAction(_ sender: UIButton) {
        btnFirst.setImage(UIImage(named: "tick_unselect"), for: .normal)
        btnSecond.setImage(UIImage(named: "tick"), for: .normal)
        sortByValue = "desc"

    }
    
    
    @IBAction func toBtnTap(_ sender: Any) {
        isFirstSelected = true
        self.viewDateContainer.isHidden = false
        self.secondDatePicker.isHidden = false
        self.datePicker.isHidden = true
    }
    
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        self.viewDateContainer.isHidden = true
    }
    
    @IBAction func fromBtnTap(_ sender: Any) {
        isFirstSelected = false
        self.viewDateContainer.isHidden = false
        self.secondDatePicker.isHidden = true
        self.datePicker.isHidden = false
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
    
    @IBAction func ratingSLiderOnSlide(_ sender: StepSlider) {
        print(sender.index)
        if sender.index == 0{
            
        }else if sender.index == 1{
            self.selectedRating = 4.5

        }else if sender.index == 2{
            self.selectedRating = 4.0

        }else if sender.index == 3{
            self.selectedRating = 3.5

        }else if sender.index == 4{
            self.selectedRating = 0.0

        }
        
        
    }
    
    @IBAction func distanceSliderOnSLide(_ sender: UISlider) {
        print(sender.value)

        self.lblDistance.text = "\(Int(sender.value))km"
        self.distance = Int(sender.value)
    }
    
    @IBAction func applySearchBtn(_ sender: Any) {
        
        
        pageForFilter = true
        
        if   whicShowTypeDigital == false{
//
            let dataParam = ["limit":"20","search":"","category_ids":"\(arrayCategorySelected)","sort_by":sortByValue,"show_type":"digital","from_date":startDate,"to_date":endDate,"rating":"\(selectedRating)","radius":"\(distance)"] as [String : Any]
            print(dataParam)
            
            
            self.objectViewModel.getParamForGetProfile(param: dataParam)
                                               
                                           }else{
            let dataParam = ["limit":"20","latitude":currentLat,"longitude":currentLong,"search":"","category_ids":"\(arrayCategorySelected)","sort_by":sortByValue,"show_type":"live","from_date":startDate,"to_date":endDate,"rating":"\(selectedRating)","radius":"\(distance)"] as [String : Any]
                   print(dataParam)
                   self.objectViewModel.getParamForGetProfile(param: dataParam)
            
               }
        
        dictFilter = ["distance":distance , "rating" : selectedRating , "selection":sortByValue ]

        
       
    }
    
    
    @IBAction func btnFirstAction(_ sender: UIButton) {
        btnFirst.setImage(UIImage(named: "tick"), for: .normal)
        btnSecond.setImage(UIImage(named: "tick_unselect"), for: .normal)
        sortByValue = "asc"
        
        
        
    }
    
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.view!.removeFromSuperview()
        self.removeFromParent()
    }
    
}
extension FilterViewController : FilterArtistDataViewModelProtocol{
    func getFilterArtistDataApiResponse(message: String, response: [SearchArtistModel], isError: Bool) {
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
            }
        }else{
            arrayHomeArtistList = response.map({$0})
            self.view!.removeFromSuperview()
            self.removeFromParent()
            self.delegate?.getFilterData(message: "success", response: arrayHomeArtistList)
            
            
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        
    }
    
    
}
extension FilterViewController: FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        let currentDate = self.covertDate(date :date)
        print(currentDate)
        
        
        if isFirstSelected == true{
            startDate = currentDate
        }else{
            endDate = currentDate

        }
        
//        selectedDate  = currentDate
//         self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.EditDateVC)
    }
   
    
  func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool{

      let currentDate = self.covertDate(date :date)
             print(currentDate)
    
     if date .compare(Date()) == .orderedAscending {     //MARK:- PAST DATE
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
}
