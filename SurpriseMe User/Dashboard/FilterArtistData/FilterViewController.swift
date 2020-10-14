//
//  FilterViewController.swift
//  SwiftApp_Demo
//
//  Created by Apple on 27/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit



protocol SendDataPrevoius {
    func getFilterData(message:String,response:[SearchArtistModel])
}

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
    @IBOutlet weak var viewSelectArtist: UIView!
    
    @IBOutlet weak var lblArtistCategpry: UILabel!
    @IBOutlet weak var fromView_out: UIView!
    
    
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnFirst: UIButton!
    
    
    @IBOutlet weak var toView_out: UIView!
    
     var delegate :SendDataPrevoius?
    var objectViewModel = FilterArtistDataViewModel()
    var arrayHomeArtistList = [SearchArtistModel]()
    
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
        
        let tapviewChangePassword = UITapGestureRecognizer(target: self, action: #selector(self.handletapviewChangePassword(_:)))
                      viewSelectArtist.addGestureRecognizer(tapviewChangePassword)
        self.objectViewModel.delegate = self

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        btnFirst.setImage(UIImage(named: "tick_unselect"), for: .normal)
               btnSecond.setImage(UIImage(named: "tick_unselect"), for: .normal)
        if arrayCategorySelectedName.count > 0{
            lblArtistCategpry.font = lblArtistCategpry.font.withSize(12)
            lblArtistCategpry.text = arrayCategorySelectedName.joined(separator: ",")
        }else{
            lblArtistCategpry.font = lblArtistCategpry.font.withSize(16)
            lblArtistCategpry.text = "Click to choose category"

        }
        
        
    }
    
    
    @objc func handletapviewChangePassword(_ sender: UITapGestureRecognizer? = nil) {
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.GetArtistCategoryVC)
    }
    
    
    @IBAction func btnSecondAction(_ sender: UIButton) {
        btnFirst.setImage(UIImage(named: "tick_unselect"), for: .normal)
        btnSecond.setImage(UIImage(named: "Atoms- Selectors- Selected"), for: .normal)


    }
    
    
    @IBAction func toBtnTap(_ sender: Any) {
        
        Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: "Functionality is not available", btnOkTitle: StringFile.OK) {
        }
    }
    @IBAction func fromBtnTap(_ sender: Any) {
        Helper.showOKAlertWithCompletion(onVC: self, title: StringFile.Error, message: "Functionality is not available", btnOkTitle: StringFile.OK) {
        }
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
        
     let dataParam = ["limit":"20","latitude":currentLat,"longitude":currentLong,"search":"","category_ids":"\(arrayCategorySelected)","sort_by":"asc","show_type":"live"] as [String : Any]
        self.objectViewModel.getParamForGetProfile(param: dataParam)
        
        
    }
    
    
    @IBAction func btnFirstAction(_ sender: UIButton) {
        btnFirst.setImage(UIImage(named: "Atoms- Selectors- Selected"), for: .normal)
        btnSecond.setImage(UIImage(named: "tick_unselect"), for: .normal)

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
