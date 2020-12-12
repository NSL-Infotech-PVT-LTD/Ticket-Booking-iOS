//
//  ChooseCurrencyVC.swift
//  SurpriseMe User
//
//  Created by Apple on 11/12/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit

protocol updateCurrancy {
    func isCurrancyUpdated(bool:Bool)
}

class ChooseCurrencyVC: UIViewController {

    @IBOutlet weak var inrCheckImage: UIImageView!
    @IBOutlet weak var usdCheckImage: UIImageView!
    @IBOutlet weak var eurCheckImage: UIImageView!
    @IBOutlet weak var angCheckImage: UIImageView!
    @IBOutlet weak var gbpCheckImage: UIImageView!
    var currency = ""
    var delegate : updateCurrancy?
    var objectViewModel = ProfileViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.inrCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.usdCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.eurCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.angCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.gbpCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        objectViewModel.delegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
  
    @IBAction func btnINRonPress(_ sender: UIButton) {
        self.inrCheckImage.image = #imageLiteral(resourceName: "CheckRound")
        self.usdCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.eurCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.angCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.gbpCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        currency = "INR"
    }
    @IBAction func btnUSDonPress(_ sender: UIButton) {
        self.usdCheckImage.image = #imageLiteral(resourceName: "CheckRound")
        self.inrCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.eurCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.angCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.gbpCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        currency = "USD"
    }
    @IBAction func btnEURonPress(_ sender: UIButton) {
        self.eurCheckImage.image = #imageLiteral(resourceName: "CheckRound")
        self.usdCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.inrCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.angCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.gbpCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        currency = "EUR"
    }
    @IBAction func btnANGonPress(_ sender: UIButton) {
        self.angCheckImage.image = #imageLiteral(resourceName: "CheckRound")
        self.usdCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.eurCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.inrCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.gbpCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        currency = "ANG"
    }
    @IBAction func btnGBPonPress(_ sender: UIButton) {
        self.gbpCheckImage.image = #imageLiteral(resourceName: "CheckRound")
        self.usdCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.eurCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.angCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        self.inrCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        currency = "GBP"
    }
    
    @IBAction func btnProcessOnPress(_ sender: UIButton) {
        if currency == ""{
            Helper.showOKAlert(onVC: self, title: "Alert", message: "Please choose your Currency")
        }else{

            LoaderClass.shared.loadAnimation()
            let param = ["currency":currency]
            objectViewModel.updataCurrancy(param: param)
        }
    }
    
}


extension ChooseCurrencyVC:ProfileViewModelProtocol{
    func getProfileApiResponse(message: String, response: GetProfileModel?, isError: Bool) {
        
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        
        if errorMessage == "Invalid AUTH Token"{
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                
                // do something like...
                UserDefaults.standard.set(nil, forKey: UserdefaultKeys.token)
                UserDefaults.standard.removeObject(forKey: UserdefaultKeys.token)
                UserDefaults.standard.set(false, forKey: UserdefaultKeys.isLogin)
                self.goToLogin()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }else{
            Helper.showOKAlert(onVC: self, title: errorTitle, message: errorMessage)
            
        }
        
    }
    
    func logoutResponse(isError: Bool, errorMessage: String) {
        
    }
    
    func getUpdateProfileApiResponse(message: String, isError: Bool) {
        LoaderClass.shared.stopAnimating()
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Ok") {
            }
        }else{
            if let del = delegate{
                UserDefaults.standard.setValue(currency, forKey: UserdefaultKeys.userCurrency)
                del.isCurrancyUpdated(bool: true)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
}
