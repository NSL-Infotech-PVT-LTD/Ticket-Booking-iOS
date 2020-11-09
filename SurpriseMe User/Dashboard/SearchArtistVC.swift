//
//  SearchArtistVC.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 28/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import SDWebImage
import IQKeyboardManager


class SearchArtistVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var tblSearchArtist: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var searchFeild: UITextField!
    @IBOutlet weak var viewCover: UIView!
    
    //MARK:- Variables -
    var objectViewModel = SearchArtistViewModel()
    var arrayHomeArtistList = [SearchArtistModel]()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblSearchArtist.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblSearchArtist.estimatedRowHeight = 95
        tblSearchArtist.rowHeight = UITableView.automaticDimension
        tfSearch.delegate = self
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        self.objectViewModel.delegate = self
        self.tblSearchArtist.isHidden = true
    }
    
    //MARK:- Custom button action -
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.back()
        dismiss(animated: true, completion: nil)
 }
    
   
    


      /**
       * Called when the user click on the view (outside the UITextField).
       */
      
    
    @IBAction func btnFilterAction(_ sender: Any) {
        
       let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                         let controller = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
                         controller.hidesBottomBarWhenPushed = true
        controller.delegate = self
        
        self.addChild(controller)
                     controller.didMove(toParent: self)
                     self.view!.addSubview(controller.view!)

//              self.navigationController?.pushViewController(controller, animated: false)
        
//        self.presentViewController(viewController: "FilterViewController", value: "Dashboard")
    }
}

extension SearchArtistVC : SendDataPrevoius{
    
    
    func getFilterData(message: String, response: [SearchArtistModel]) {
                print("the data is \(response.count)")
                    arrayHomeArtistList = response.map({$0})
        
        if arrayHomeArtistList.count > 0{
            
        }else{
            
        }
        
        
        self.tblSearchArtist.isHidden = false
        self.tblSearchArtist.reloadData()

    }
    
    
    
    
}


extension SearchArtistVC :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayHomeArtistList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomSearchArtistCell
        
        let dataItem = arrayHomeArtistList[indexPath.row]
        cell.nameArtist.text = dataItem.name ?? ""
        cell.lblCat.text = "\(dataItem.category?.map({$0}) ?? [] )"
        var urlSting : String = "\(Api.imageURLArtist)\(dataItem.image ?? "")"
        let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
        print(urlStringaa)
        let urlImage = URL(string: urlStringaa)!
        cell.imgArtist.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgArtist.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.ScheduleBookingVC)
    }
  
}

extension SearchArtistVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //delegate method
        
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        
        print("the search is \(string)")
        print("the search is \(searchFeild.text!)\(string)")
        print("the search is value \(searchFeild.text!)")
        
        if string == ""{
            self.tblSearchArtist.isHidden = true
        }else{
            let dataParam = ["limit":"20","latitude":currentLat,"longitude":currentLong,"search": tfSearch.text! + string ] as [String : Any]
                   self.objectViewModel.getParamForGetProfile(param: dataParam)
        }

        
        
        return true
    }
}

extension SearchArtistVC : SearchArtistViewModelProtocol{
    func getProfileApiResponse(message: String, response: [SearchArtistModel], isError: Bool) {
        if isError == true{
            Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: message, btnOkTitle: "Done") {
            }
        }else{
            arrayHomeArtistList = response.map({$0})
            self.tblSearchArtist.isHidden = false
            self.view.endEditing(true)
            tfSearch.resignFirstResponder()
            self.tblSearchArtist.reloadData()
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        
    }
    
    
}
