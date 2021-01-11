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

class ChooseCurrencyCell :UITableViewCell{
    @IBOutlet weak var lblCurrancy: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
}


class ChooseCurrencyVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inrCheckImage: UIImageView!
    @IBOutlet weak var usdCheckImage: UIImageView!
    @IBOutlet weak var eurCheckImage: UIImageView!
    @IBOutlet weak var angCheckImage: UIImageView!
    @IBOutlet weak var gbpCheckImage: UIImageView!
    @IBOutlet weak var btnProcess: UIButton!
    @IBOutlet weak var lblChooseCurrency: UILabel!
    var currency = ""
    var delegate : updateCurrancy?
    var objectViewModel = ProfileViewModel()
    var currancyData = [[String:Any]]()
    var selectedIndex = Int()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnProcess.setTitle("Proceed".localized(), for: .normal)
        lblChooseCurrency.text = "CHOOSE_CURRENCY".localized()
        
        
        self.getCurrancyData()
//        self.inrCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
//        self.usdCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
//        self.eurCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
//        self.angCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
//        self.gbpCheckImage.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        objectViewModel.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
    func getCurrancyData() {
        LoaderClass.shared.loadAnimation()
        if Reachability.isConnectedToNetwork() {

            ApiManeger.sharedInstance.callApiWithOutHeaderWithoutParam(url: Api.currencies, method: .get) { (reponse, error) in
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    print(reponse)
                    if let staus = reponse["status"] as? Bool {
                        if staus == true{
                            if let data = reponse["data"] as? [String:Any]{
                                if let list = data["list"] as? [[String:Any]]{
                                    self.currancyData = list
                                    if list.count > 0{
                                        self.currency = list[0]["currency"] as? String ?? ""
                                    }
                                }
                            }
                        }else{
                            
                        }
                    }
                    self.tableView.reloadData()
                }else{
                    LoaderClass.shared.stopAnimation()
                    if let error = reponse["error"] as? String{
                        Helper.showOKAlert(onVC: self, title: "Error", message: error)
                    }
                    
                }
            }
        }
        else
        {
//            self.delegate?.errorAlert(errorTitle: Alerts.Alert, errorMessage: AlertMessage.internetConn)
        }
    }
    
}


extension ChooseCurrencyVC:ProfileViewModelProtocol{
    func getProfileApiResponse(message: String, response: GetProfileModel?, isError: Bool) {
        
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        
        if errorMessage == "Invalid AUTH Token"{
            LoaderClass.shared.stopAnimation()
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
            LoaderClass.shared.stopAnimation()
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


extension ChooseCurrencyVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currancyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCurrencyCell", for: indexPath) as! ChooseCurrencyCell
        let indexData = self.currancyData[indexPath.row]
        if selectedIndex == indexPath.row{
            cell.imgCheck.image = #imageLiteral(resourceName: "CheckRound")
        }else{
            cell.imgCheck.image = #imageLiteral(resourceName: "Atoms- Selectors- Selected-1")
        }
        cell.lblCurrancy.text = indexData["currency"] as? String ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        let currency = currancyData[indexPath.row]
        self.currency = currency["currency"] as? String ?? ""
        self.tableView.reloadData()
    }
    
}
