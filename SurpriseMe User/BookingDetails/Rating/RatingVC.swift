//
//  RatingVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 05/10/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import Cosmos

class RatingVC: UIViewController {
    
    //MARK:- Outlets -
    
    @IBOutlet weak var reviewTxtView: UITextView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgAgentPic: UIImageView!
    @IBOutlet weak var cosmoRating: CosmosView!
    @IBOutlet weak var viewHeader: UIView!
    
    
    @IBOutlet weak var btnSubmitAction: UIButton!
    
    
    //MARK:- Variables -
    var artistName : String?
    var userImg : String?
    var bookingID : Int?
    var objectViewModel = RatingViewModel()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.viewHeader.addBottomShadow()
        self.setInitial()
    }
    
    
    @IBAction func laterBtnAction(_ sender: UIButton) {
        self.back()
    }
    
    func setInitial()  {
        self.cosmoRating.rating = 1.0
        self.imgAgentPic.image = UIImage.init(named: "1")
        cosmoRating.didTouchCosmos = { rating in
            print("the rating is \(rating)")
            if rating == 1.0{
                self.imgAgentPic.image = UIImage.init(named: "1")
            }else if rating == 2.0{
                self.imgAgentPic.image = UIImage.init(named: "2")
            }else if rating == 3.0{
                self.imgAgentPic.image = UIImage.init(named: "3")

            }else if rating == 4.0{
                self.imgAgentPic.image = UIImage.init(named: "4")

            }else{
                self.imgAgentPic.image = UIImage.init(named: "5")
            }
        }

        
    }
    
    
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        if reviewTxtView.text == "" || reviewTxtView.text == "Write a review..."{
            
            self.showToast(message: "Write your review", font: .systemFont(ofSize: 12.0))

        }else if cosmoRating.rating == 0.0{
            self.showToast(message: "Give your Rating", font: .systemFont(ofSize: 12.0))
        }
        else{
            self.giveRatingToYourArtist()
        }
        
    }
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.back()
    }
    
    func giveRatingToYourArtist()  {
        self.objectViewModel.delegate = self
        let param = ["booking_id":bookingID ?? 0,"rate":self.cosmoRating.rating,"review":self.reviewTxtView.text!] as [String : Any]
        print("the param is \(param)")
        self.objectViewModel.getParamForRating(param: param)
    }
    
}

extension RatingVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write a review..."{
            textView.text = ""
        }}

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Write a review..."
        } }
    
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("chars \(textView.text.count) \( text)")

        if(textView.text.count > 35 && range.length == 0 ) {
            print("Please summarize in 20 characters or less")
            self.btnSubmitAction.isUserInteractionEnabled  = true
            self.btnSubmitAction.backgroundColor = UIColor.systemBlue
//            self.btnSubmitAction.backgroundColor = UIColor.init(red: 240/225, green: 0/255, blue: 87/255, alpha: 1)

        }else{
            self.btnSubmitAction.isUserInteractionEnabled  = false
            self.btnSubmitAction.backgroundColor = UIColor.init(red: 174/225, green: 174/255, blue: 174/255, alpha: 1)

        }
        return true
    }
    
}


extension RatingVC : RatingViewModelProtocol{
    func getCompletedRatedApiResponse(message: String, isError: Bool) {
        if isError == false{
            
            
            let vc = UIStoryboard(name: "Main", bundle: nil)
                   let vc1 = vc.instantiateViewController(withIdentifier: "DashboardTabBarController")
                   
                   
                   whicShowTypeDigital = false
                   let navigationController = UINavigationController(rootViewController: vc1)
                   navigationController.isNavigationBarHidden = true
                   UIApplication.shared.windows.first?.rootViewController = navigationController
                   UIApplication.shared.windows.first?.makeKeyAndVisible()
            
            
//            for controller in (self.navigationController?.viewControllers ?? []) as Array {
//                if controller.isKind(of: BookingVC.self) {
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }else{
//
//                    let vc = UIStoryboard(name: "Main", bundle: nil)
//                           let vc1 = vc.instantiateViewController(withIdentifier: "DashboardTabBarController")
//                           let navigationController = UINavigationController(rootViewController: vc1)
//                           navigationController.isNavigationBarHidden = true
//                           UIApplication.shared.windows.first?.rootViewController = navigationController
//                           UIApplication.shared.windows.first?.makeKeyAndVisible()
//
//
////                    self.navigationController?.popToRootViewController(animated: true)
//                }
//            }
        }
        
    }
    
    func getRatingApiResponse(message: String, isError: Bool) {
        
        
        
        if isError == false{
            let vc = UIStoryboard(name: "Main", bundle: nil)
                              let vc1 = vc.instantiateViewController(withIdentifier: "DashboardTabBarController")
                              
                              
                              whicShowTypeDigital = false
                              let navigationController = UINavigationController(rootViewController: vc1)
                              navigationController.isNavigationBarHidden = true
                              UIApplication.shared.windows.first?.rootViewController = navigationController
                              UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        
//        for controller in (self.navigationController?.viewControllers ?? []) as Array {
//            if controller.isKind(of: BookingVC.self) {
//                self.navigationController!.popToViewController(controller, animated: true)
//                break
//            }else{
//                self.navigationController?.popToRootViewController(animated: true)
//            }
//        }
//        
        let param = ["booking_id":bookingID ?? 0,"status":"completed_review"] as [String : Any]
              //self.objectViewModel.getCompletedBooking(param: param)
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        
    }
    

}
