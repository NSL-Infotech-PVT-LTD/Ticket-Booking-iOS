//
//  TermsProfileVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class TermsProfileVC: UIViewController {

    @IBOutlet var btnBack: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    
    
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblTitleDescription: UILabel!
    @IBOutlet weak var lblTitleHeader: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    
    var headerName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewHeader.addBottomShadow()
        
        
        if selectedIdentifier == "About Us"{
            lblTitleHeader.text = "About Us"
            imgTitle.image = UIImage.init(named: "Group 1399")
            self.getAboutUS()
            
        }else if selectedIdentifier == "Terms And Conditions"{
            lblTitleHeader.text = "Terms And Conditions"
            imgTitle.image = UIImage.init(named: "Term&Condition")

            self.getTermsAndConditions()
            
        }else{
            lblTitleHeader.text = "Privacy Policy"
//            lblTitleDescription.text = ""
            imgTitle.image = UIImage.init(named: "Group 1401")
            self.getPrivacyPolicy()
            
        }
        self.btnBack.setTitle("back".localized(), for: .normal)
      //  self.headerLbl.text = "terms_title".localized()
        
    }
    
    
    func getAboutUS()  {
        
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            
            ApiManeger.sharedInstance.callApiWithOutHeaderWithoutParam(url: Api.AboutUs, method: .get) { (response, error) in
                LoaderClass.shared.stopAnimation()

                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
                            
                            print("the response is \(response)")
                            
                            
                            let dictData = result["data"] as? [String:Any]
                            
                            let responseValue = dictData?["config"] as? String
                            
                            let attributedString = NSMutableAttributedString(string: responseValue ?? "")
                            self.textView.linkTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.blue] as [NSAttributedString.Key: Any]?
                           // self.textView.attributedText = attributedString
                            
                            self.textView.attributedText = responseValue?.htmlToAttributedString
                            //
//                            let dictData = result["data"] as? [String:Any]
//                            let userProfile = dictData?["user"] as? [String:Any]
//                            self.loginModelObject =    GetProfileModel.init(resposne: userProfile ?? [:])
//                            self.delegate?.getProfileApiResponse(message: "Success", response: self.loginModelObject, isError: false)
                            
                        }
                        else{
                             let error_message = response["error"] as? String
                            if error_message == "Invalid AUTH Token"{
//                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error_message as? String ?? "")
                            }else{
//                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error_message as? String ?? "")
                            }


                          

                            
                            
                        }
                    }
                    else {
                        if let error_message = response["error"] as? [String:Any] {
                            if (error_message["error_message"] as? String) != nil {
                            }
                        }
                    }
                }else {
//                    self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
                
            }
        }else{
            
        }
            
         
        
        
        
    }
    
    
    func getTermsAndConditions()  {

        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            
            ApiManeger.sharedInstance.callApiWithOutHeaderWithoutParam(url: Api.TermsAndCondi, method: .get) { (response, error) in
                LoaderClass.shared.stopAnimation()

                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
                            print("the response is \(response)")

                            //
                            let dictData = result["data"] as? [String:Any]
                            
                            let responseValue = dictData?["config"] as? String
                            
                            let attributedString = NSMutableAttributedString(string: responseValue ?? "")
                            self.textView.linkTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.blue] as [NSAttributedString.Key: Any]?
                          //  self.textView.attributedText = attributedString
                            
                            self.textView.attributedText = responseValue?.htmlToAttributedString
                            
//                            let userProfile = dictData?["user"] as? [String:Any]
//                            self.loginModelObject =    GetProfileModel.init(resposne: userProfile ?? [:])
//                            self.delegate?.getProfileApiResponse(message: "Success", response: self.loginModelObject, isError: false)
                            
                        }
                        else{
                             let error_message = response["error"] as? String
                            if error_message == "Invalid AUTH Token"{
//                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error_message as? String ?? "")
                            }else{
//                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error_message as? String ?? "")
                            }


                          

                            
                            
                        }
                    }
                    else {
                        if let error_message = response["error"] as? [String:Any] {
                            if (error_message["error_message"] as? String) != nil {
                            }
                        }
                    }
                }else {
//                    self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
                
            }
        }else{
            self.showSimpleAlert(Title: "Internet Error", message: "", inClass: self)
        }
            
        
    }
    
    func getPrivacyPolicy()  {
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            
            ApiManeger.sharedInstance.callApiWithOutHeaderWithoutParam(url: Api.PrivacyPolicyApi, method: .get) { (response, error) in
                LoaderClass.shared.stopAnimation()

                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
                            
                            print("the response is \(response)")
                            
                            let dictData = result["data"] as? [String:Any]
                            
                            let responseValue = dictData?["config"] as? String
                            
                            let attributedString = NSMutableAttributedString(string: responseValue ?? "")
                            self.textView.linkTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.blue] as [NSAttributedString.Key: Any]?
                            self.textView.attributedText = responseValue?.htmlToAttributedString
                            

                            //
//                            let dictData = result["data"] as? [String:Any]
//                            let userProfile = dictData?["user"] as? [String:Any]
//                            self.loginModelObject =    GetProfileModel.init(resposne: userProfile ?? [:])
//                            self.delegate?.getProfileApiResponse(message: "Success", response: self.loginModelObject, isError: false)
                            
                        }
                        else{
                             let error_message = response["error"] as? String
                            if error_message == "Invalid AUTH Token"{
//                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error_message as? String ?? "")
                            }else{
//                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error_message as? String ?? "")
                            }
}
                    }
                    else {
                        if let error_message = response["error"] as? [String:Any] {
                            if (error_message["error_message"] as? String) != nil {
                            }
                        }
                    }
                }else {
//                    self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
                
            }
        }else{
            
        }
            
    }
    
   
    
    
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
