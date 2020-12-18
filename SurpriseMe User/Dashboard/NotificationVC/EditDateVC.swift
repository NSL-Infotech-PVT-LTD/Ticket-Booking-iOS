//
//  EditDateVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 31/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit
import Stripe

class EditDateVC: UIViewController {
    var first: Int = -1
    var second: Int = -1
    //MARK:- Outlets -
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var dateListCollectionView:UICollectionView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblArtistNotAvai: UILabel!
    @IBOutlet var lblMainTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnClearAll: UIButton!
    @IBOutlet var lblAvailable: UILabel!
    @IBOutlet var lblUnavailable: UILabel!
    @IBOutlet var btnProceed: UIButton!
    
    //MARK:- Variable -
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    
    
    var screenHeight: CGFloat!
    var indxArr = [Int]()
    var viewModelObject = BookingStoreViewModel()
    var aarayTime = ["12:00 AM - 01:00 AM","01:00 AM - 02:00 AM","02:00 AM - 03:00 AM","03:00 AM - 04:00 AM","04:00 AM - 05:00 AM","05:00 AM - 06:00 AM","06:00 AM - 07:00 AM","07:00 AM - 8:00 AM","8:00 AM - 9:00 AM","9:00 AM - 10:00 AM","10:00 AM - 11:00 AM","11:00 AM - 12:00 PM","12:00 PM - 01:00 PM","01:00 PM - 02:00 PM","02:00 PM - 03:00 PM","03:00 PM - 04:00 PM","04:00 PM - 05:00 PM","05:00 PM - 06:00 PM","06:00 PM - 07:00 PM","07:00 PM - 8:00 PM","8:00 PM - 9:00 PM","9:00 PM - 10:00 PM","10:00 PM - 11:00 PM","11:00 PM - 12:00 AM"]
    var aarayTimeSecond = ["00:00 - 01:00","01:00 - 02:00","02:00 - 03:00","03:00 - 04:00","04:00 - 05:00","05:00 - 06:00","06:00 - 07:00","07:00 - 08:00","08:00 - 09:00","09:00 - 10:00","10:00 - 11:00","11:00 - 12:00","12:00 - 13:00","13:00 - 14:00","14:00 - 15:00","15:00 - 16:00","16:00 - 17:00","17:00 - 18:00","18:00 - 19:00","19:00 - 20:00","20:00 - 21:00","21:00 - 22:00","22:00 - 23:00","23:00 - 00:00"]
    var aarayTimeSplitSecond = ["00:00:00","01:00:00","02:00:00","03:00:00","04:00:00","05:00:00","06:00:00","07:00:00","08:00:00","09:00:00","10:00:00","11:00:00","12:00:00","13:00:00","14:00:00","15:00:00","16:00:00","17:00:00","18:00:00","19:00:00","20:00:00","21:00:00","22:00:00","23:00:00"]
    
    var arrayInteger = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    var arrNotSelect = [Int]()
    var arrNotSelectCombine = [Int]()
    
    
    @IBOutlet weak var viewNoData: UIView!
    var firstTime = String()
    var secondTime = String()
    var arrayAvailTime = [String]()
    var arrayBookingSlot = [Int]()
    var arrayBookingSlotSelection = [Int]()
    var bookingID : Int?
    var arraySelectedIndex = [Int]()
    var arrayBookingSlotStatus = [Int:Int]()
    var arrayBookingSlotStatusValue = [Int]()
    var numsArray = [Int]()
    var numsArraySelection = [Int]()
    var arrayTestingData = [[String : [[String : Any]]]]()
    
    
   
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    func callApiGetStripeKey(){
        if  Reachability.isConnectedToNetwork() {
            let header = ["Authorization":"Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) as! String)"]
            ApiManeger.sharedInstance.callApiWithHeaderWithoutParam(url: Api.getStripeKey, method: .get, header: header) { (response, error) in
                if error == nil{
                    if let data = response["data"] as? [String:Any]{
                        if let key = data["public_key"] as? String{
                            print("Stripe Key \(key)")
                            STPAPIClient.shared().publishableKey = key
                        }
//                        if let clientID = data["client_id"] as? String{
//                            self.stripeClientKey = clientID
//                        }
                    }
                    
                }else{
                    if let error = response["error"] as? String{
                        Helper.showOKAlert(onVC: self, title: "Error", message: error)
                    }
                }
            }
        }else{
            Helper.showOKAlert(onVC: self, title: "Error", message: "Please check your internet Connection")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getCard()
        self.self.callApiGetStripeKey()
        lblArtistNotAvai.text = "choose_another_date".localized()
        btnBack.setTitle("back".localized(), for: .normal)
        lblMainTitle.text = "select_time_booking".localized()
        lblSubTitle.text = "multiple_slot".localized()
        lblAvailable.text = "available".localized()
        lblUnavailable.text = "unavailable".localized()
        btnClearAll.setTitle("clear_all".localized(), for: .normal)
        btnProceed.setTitle("proceed_checkout".localized(), for: .normal)
        
        self.setInitialSetup()
        print(aarayTime.count)
        print(aarayTimeSecond.count)
        print(aarayTimeSplitSecond.count)
        self.dateListCollectionView.isHidden = true
        self.viewNoData.isHidden = true
        btnProceed.backgroundColor = UIColor.init(red: 168/255, green: 168/255, blue: 168/255, alpha: 1)
        
    }
    
    
    func getCard() {
        
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        
        
        if Reachability.isConnectedToNetwork() {
            LoaderClass.shared.loadAnimation()
            
            let dict = ["search":"","limit":"20"]
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.customerCardList, method: .post, param: dict, header: headerToken) { (response, error) in
                print(response)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    
                    arrayCardListCommom.removeAll()
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            
                            
                            let dataDict = result["data"] as? [String : Any]
                            if let dataArray = dataDict?["data"] as? [[String : Any]]{
                                for index in dataArray{
                                    print("the index value is \(index)")
                                    let dataDict = GetCardModel.init(resposne: index)
                                    arrayCardListCommom.append(dataDict)
                                }
                            }
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
                }
                else {
                    //self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
            }
            
        }else{
            // self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
    }
    
    //MARK:- Set Initial Design -
    func setInitialSetup()  {
        self.viewBack.addBottomShadow()
        //Mark: CollectionView Delegate
        dateListCollectionView.delegate = self
        dateListCollectionView.dataSource = self
        self.dateListCollectionView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (screenWidth - 20)/2, height: 40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        dateListCollectionView!.collectionViewLayout = layout
        self.viewBack.addBottomShadow()
        self.viewModelObject.delegate = self
        
        let selectDate = self.convertDateToStringBook(profile: selectedDate)
        self.lblDate.text = selectDate
        let selectday = self.convertdayToStringBook(profile: selectedDate)
        self.lblDay.text = selectday
        let param = ["date":selectedDate,"artist_id":userArtistID] as [String : Any]
        self.getTimeAvail(param: param)
        
    }
    
    
    func getTimeAvail(param : [String:Any])  {
        
        LoaderClass.shared.loadAnimation()
        
        let header = ["Authorization":"Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) as! String)"]
        if Reachability.isConnectedToNetwork() {
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.artistbookslot, method: .post, param: param, header: header) { (response, error) in
                LoaderClass.shared.stopAnimation()
                
                print(response)
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            print(response)
                            if let arrayResponse = response["data"] as? [[String:Any]]
                            {
                                
                                for index in arrayResponse{
                                    let hour = index["hour"] as? String
                                    let booked = index["booked"] as? String
                                    self.arrayBookingSlotStatusValue.append(Int(booked ?? "0") ?? 0)
                                    self.arrayAvailTime.append(hour ?? "")
                                }
                            }
                            
                            if self.arrayAvailTime.count > 0{
                                for index in 0...self.arrayAvailTime.count - 1{
                                    let indexValuePath = self.arrayAvailTime[index]
                                    let indexValuePathStatus = self.arrayBookingSlotStatusValue[index]
                                    let index = self.aarayTimeSplitSecond.firstIndex(of: indexValuePath)
                                    self.arrayBookingSlotStatus[index ?? 0] = indexValuePathStatus
                                }
                                
                                for index in self.arrayAvailTime{
                                    
                                    
                                    
                                    
                                    let index = self.aarayTimeSplitSecond.firstIndex(of: index)
                                    self.arrayBookingSlot.append(index ?? 0)
                                }
                            }else{
                                
                            }
                            
                            if self.arrayBookingSlot.count > 0{
                                self.dateListCollectionView.isHidden = false
                                self.viewNoData.isHidden = true
                            }else{
                                self.dateListCollectionView.isHidden = true
                                self.viewNoData.isHidden = false
                            }
                            self.dateListCollectionView.reloadData()
                            
                        }else{
                            if let error = response["error"] as? String {
                                Helper.showOKAlertWithCompletion(onVC: self, title: "", message: "", btnOkTitle: "OK") {
                                    
                                }
                            }
                        }
                    }else{
                   
                    }
                }else{
                    
                }
            }}
        else
        {
            Helper.showOKAlertWithCompletion(onVC: self, title: "", message: "", btnOkTitle: "OK") {
                
            }
        }
    }
    
    
    
    func convertDateToStringBook(profile : String)-> String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"
        let myString =  profile // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd MMMM , yyyy"
        // again convert your date to string
        let bookDate = formatter.string(from: yourDate!)
        return bookDate
    }
    
    func convertdayToStringBook(profile : String)-> String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd"
        let myString =  profile // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "EEEE"
        // again convert your date to string
        let bookDate = formatter.string(from: yourDate!)
        return bookDate
    }
    
    
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Once booking confirmed by you, your booking will go on hold until payment received or click cancel to check slots again !", message: "", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (alert) in
            self.bookNow()
        }
        let cancel = UIAlertAction(title: "cancel", style: .default) { (alert) in
           
        }
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert,animated: true)
   }
    
    
    
    
    
    
    func bookNow(){
        if self.first != -1 && self.second == -1{
            let inputString = self.aarayTimeSecond[self.first]
            let splits = inputString.components(separatedBy: " - ")
            self.firstTime = splits[0]
            self.secondTime = splits[1]
            
        }else if self.first == -1 && self.second == -1{
            Helper.showOKAlertWithCompletion(onVC: self, title: "", message: "Please select Any Slot", btnOkTitle: "Done") {
            }
        }else{
            let inputString = self.aarayTimeSecond[self.first]
            let splits = inputString.components(separatedBy: " - ")
            self.firstTime = splits[0]
            let inputString2 = self.aarayTimeSecond[self.second]
            let splits2 = inputString2.components(separatedBy: " - ")
            self.secondTime = splits2[1]
            
        }
        
        print("the selected elemt is \(self.firstTime)")
        print("the selected secondTime is \(self.secondTime)")
        print("the selected secondTime is \(self.numsArraySelection)")
        
        if selectedType == "digital"{
            let dataParam = ["type":selectedType,"date":selectedDate,"from_time":self.firstTime,"to_time":self.secondTime,"artist_id":userArtistID] as [String : Any]
            print("the dict param is \(dataParam)")
            self.viewModelObject.getParamForBookingStore(param: dataParam)
            
        }else{
            let dataParam = ["type":selectedType,"date":selectedDate,"from_time":self.firstTime,"to_time":self.secondTime,"artist_id":userArtistID,"address":currentAddress] as [String : Any]
            self.viewModelObject.getParamForBookingStore(param: dataParam)
            print("the dict param is \(dataParam)")
            
        }
    }
    
    
    @IBAction func btnClearAllActtion(_ sender: UIButton) {
        
        first = -1
        second = -1
        numsArraySelection.removeAll()
        numsArray.removeAll()
        btnProceed.backgroundColor = UIColor.init(red: 168/255, green: 168/255, blue: 168/255, alpha: 1)
        self.dateListCollectionView.reloadData()
        
    }
    
   
    
    
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSaveOnPress(_ sender: UIButton) {
    }
    
    func getPaymentForBooking(param: [String: Any]) {
        let headerToken =  ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: UserdefaultKeys.token) ?? "")"]
        print("the token is \(headerToken)")
        
        if Reachability.isConnectedToNetwork() {
            // LoaderClass.shared.loadAnimation()
            
            ApiManeger.sharedInstance.callApiWithHeader(url: Api.changeBookingStatus, method: .post, param: param, header: headerToken) { (response, error) in
                print(response)
                self.dismiss(animated: true, completion: nil)
                LoaderClass.shared.stopAnimation()
                if error == nil {
                    let result = response
                    if let status = result["status"] as? Bool {
                        if status ==  true{
                            let storyboard1 = UIStoryboard(name: "Dashboard", bundle: nil)
                            let controller1 = storyboard1.instantiateViewController(withIdentifier: "SuccessPaymentVC") as! SuccessPaymentVC
                            idealPayment = true
                            self.navigationController?.pushViewController(controller1, animated: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                        else{
                            if let error_message = response["error"] as? String {
                                Helper.showOKAlert(onVC: self, title: error_message, message: "")
                            }
                        }
                    }
                    else {
                        Helper.showOKAlert(onVC: self, title: "Error", message: error?.localizedDescription ?? "")
                    }
                }
                else {
                    Helper.showOKAlert(onVC: self, title: "Error", message: error?.localizedDescription ?? "")
                    //                                                self.delegate?.errorAlert(errorTitle: "Error", errorMessage: error as? String ?? "")
                }
            }
            
        }else{
            //                            self.delegate?.errorAlert(errorTitle: "Internet Error", errorMessage: "Please Check your Internet Connection")
        }
        
    }

    
    
    
    func setSlotReservation(variable : Int ,  variable2 : Int){
        
        print("the first var is \(variable)")
        print("the variable2 var is \(variable2)")
     }
    
    
    func fizzinAndBuzzin(start: Int, end: Int) -> Bool
    {
        print("the array after before value last \(numsArray)")
        print("the array after start value last \(start)")
        print("the array after start value last \(first)")
        print("the array after start value last \(second)")
        print("the array end end value last \(end)")
        if second < first{
            return true
        }else{
            let sortArray = Set(numsArray)
            numsArray = sortArray.map({$0})
            numsArray = numsArray.sorted(by: <)
            var removeValue = Int()
            if numsArray.last == second{
                if numsArray.contains(end){
                  let last1 = numsArray.popLast()
                    if last1 == 0{
                    }else{
                        removeValue = last1 ?? -1
                    }
                }
                
            }else{
                numsArray.removeAll()
                for number in start...end
                {
                    numsArray.append(number)
                    
                }
                let sortArrayValue = Set(numsArray)
                numsArray = sortArrayValue.map({$0})
                numsArray = numsArray.sorted(by: <)
            }
            
            for number in start...end
            {
                numsArray.append(number)
            }
            let fruitsSet = Set(numsArray)
            let vegSet = Set(arrNotSelectCombine)
            let output = Array(fruitsSet.intersection(vegSet))
            let sortArrayValue = Set(numsArray)
            numsArray = sortArrayValue.map({$0})
            numsArray = numsArray.sorted(by: <)
            
            if output.count > 0{
                print("the value is numsArray sorted\(numsArray)")
                let element = numsArray.first ?? 0
                print("the value is sortArray sorted\(element)")
                numsArraySelection.append(element)
                let alert = UIAlertController(title: "", message: "You cannot book because slot is already book in this range", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                // change to desired number of seconds (in this case 5 seconds)
                let when = DispatchTime.now() + 3
                DispatchQueue.main.asyncAfter(deadline: when){
                    // your code with delay
                    alert.dismiss(animated: true, completion: nil)
                }
                second = -1
                return true
                
            }else {
                let indexValue = numsArray.firstIndex(of: removeValue) ?? -1
                print("the value is numsArray after removing\(indexValue)")
                if indexValue == 0 || indexValue == -1{
                    
                }else{
                numsArray.remove(at: indexValue)
                }
                let numArray = Set(numsArray)
                numsArray = numArray.map({$0})
                numsArray = numsArray.sorted(by: <)
                print("the value is sortArray sorted\(numsArray)")
                print("the num array is removing\(numsArray)")
                numsArraySelection = numsArray
                return false
            }
        }
    }
    
    
    func checkRange(num: Int) -> Bool {
        
        if first < second{
            if first...second ~= num && arrayBookingSlot.contains(num){
                if self.arrayBookingSlotStatus[num] == 1{
                    return false
                    
                }else{
                    return true
                }
            }else{
                return false
            }
        }else{
            if second...first ~= num && arrayBookingSlot.contains(num) {
                if self.arrayBookingSlotStatus[num] == 1{
                    return false
                    
                }else{
                    return true
                    
                }
            }else{
                return false
            }
        }
    }
}

extension EditDateVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aarayTime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateListCollectionViewCell", for: indexPath) as! dateListCollectionViewCell
        cell.lblTimeSelect.text = aarayTime[indexPath.row]
        cell.viewCell.borderColor = UIColor.init(red: 54/255, green: 57/255, blue: 110/255, alpha: 1)
        cell.viewCell.layer.masksToBounds = true
        
        if numsArraySelection.contains(indexPath.row){
            cell.viewCell.backgroundColor = UIColor.init(red: 11/255, green: 172/255, blue: 43/255, alpha: 1)
            cell.lblTimeSelect.textColor = UIColor.white
            
        }else{
            if arrayBookingSlot.contains(indexPath.item){
                print("the number is abhishek mishra3")
                
                if self.arrayBookingSlotStatus[indexPath.item] == 1{
                    arrayBookingSlotSelection.append(indexPath.item)
                    cell.viewCell.backgroundColor = UIColor.init(red: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1)
                    cell.lblTimeSelect.textColor = UIColor.init(red: 54/255, green: 57/255, blue: 110/255, alpha: 1)
                }else{
                    cell.viewCell.backgroundColor = UIColor.white
                    cell.lblTimeSelect.textColor = UIColor.init(red: 54/255, green: 57/255, blue: 110/255, alpha: 1)
                }
            }else{
                cell.viewCell.backgroundColor = UIColor.init(red: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1)
                cell.lblTimeSelect.textColor = UIColor.init(red: 54/255, green: 57/255, blue: 110/255, alpha: 1)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0...arrayInteger.count - 1{
            print(arrayInteger[i])
            if arrayBookingSlot.contains(arrayInteger[i]){
            }else{
                arrNotSelect.append(arrayInteger[i])
            }
        }
        
        print("the array is not is \(arrNotSelect)")
        let arrNotSelectSet = Set(arrNotSelect)
        arrNotSelect = arrNotSelectSet.map({$0})
        let dataItem = aarayTimeSecond[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateListCollectionViewCell", for: indexPath) as! dateListCollectionViewCell
        cell.lblTimeSelect.text = aarayTime[indexPath.row]
        let arraySelect = arrayBookingSlotSelection
        arrayBookingSlotSelection = arraySelect.map({$0})
        let arraySlotSelet = Set(arrayBookingSlotSelection)
        arrayBookingSlotSelection = arraySlotSelet.map({$0})
        arrNotSelectCombine = arrNotSelect + arrayBookingSlotSelection
        if arrayBookingSlot.contains(indexPath.item) {
            if self.arrayBookingSlotStatus[indexPath.item] == 1{
                let alert = UIAlertController(title: "", message: "Artist is already booked", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                // change to desired number of seconds (in this case 5 seconds)
                let when = DispatchTime.now() + 3
                DispatchQueue.main.asyncAfter(deadline: when){
                    // your code with delay
                    alert.dismiss(animated: true, completion: nil)
                }
            }else{
                if first == -1{
                    first = indexPath.row
                    numsArraySelection.append(indexPath.row)
                }else if first < indexPath.row{
                    second = indexPath.row
                }else if first == indexPath.row{
                    first = -1
                    numsArraySelection.removeAll()
                }else if first == second{
                    second = -1
                    first = -1
                }
                else{
                    let temp = first
                    first = indexPath.row
                    second = temp
                }
                
                if first != -1 && second != -1{
                    let boolValue =  self.fizzinAndBuzzin(start: first, end: second)
                    print("the bool value is \(boolValue)")
                    if boolValue == false{
                    }else{
                    }
                }
                
                if numsArraySelection.count > 0{
                    btnProceed.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255, alpha: 1)
                }else{
                    first = -1
                    second = -1
                    btnProceed.backgroundColor = UIColor.init(red: 168/255, green: 168/255, blue: 168/255, alpha: 1)
                }
            }
        }else{
            let alert = UIAlertController(title: "", message: "Artist is not available", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }
        self.dateListCollectionView.reloadData()
    }
}


extension EditDateVC : BookingStoreViewModelProtocol{
    func bookingStoreApiResponse(message: String, response: [String : Any], isError: Bool) {
        
        print("the respons is \(response)")
        let dictValue = response["data"] as? [String:Any]
        let dictAddress = response["address"] as? [String:Any]
        bookingID = dictAddress?["id"] as? Int
        bookingPaymentID = dictAddress?["id"] as? Int

        if isError == true{
            if let errorDict = response["message"] as? String{
                let alert = UIAlertController(title: "Error", message: errorDict, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ok", style: .default) { (alert) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert,animated: true)
            }
        }else{
            let currency =  UserDefaults.standard.value(forKey: UserdefaultKeys.userCurrency) as? String
            if currency != "EUR"{
             
//
                
//
                if arrayCardListCommom.count > 0{
                    let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "cardPaymentList") as! cardPaymentList
                    bookingID = dictAddress?["id"] as? Int
                    bookingPaymentID = dictAddress?["id"] as? Int
                    navigationController?.pushViewController(controller, animated: true)
                }else{
                    let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
                    bookingID = dictAddress?["id"] as? Int
                    bookingPaymentID = dictAddress?["id"] as? Int
                    controller.isMoreCount = true
                    navigationController?.pushViewController(controller, animated: true)
                }
            }else{
                let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "SelectPaymentVC") as! SelectPaymentVC
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: .default)
                transition.type = .fade
                transition.subtype = .fromRight
                print("the booking id is \(dictAddress?["id"])")
                bookingID = dictAddress?["id"] as? Int
                bookingPaymentID = dictAddress?["id"] as? Int
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.view.layer.add(transition, forKey: kCATransition)
                self.navigationController?.pushViewController(controller, animated: false)
            }
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default) { (alert) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert,animated: true)
    }
}
