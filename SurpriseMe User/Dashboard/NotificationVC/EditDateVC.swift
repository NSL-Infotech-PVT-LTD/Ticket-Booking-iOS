//
//  EditDateVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 31/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit

class EditDateVC: UIViewController {
    var first: Int = -1
    var second: Int = -1
    //MARK:- Outlets -
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var dateListCollectionView:
    UICollectionView!
    
    //MARK:- Variable -
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var indxArr = [Int]()
    var viewModelObject = BookingStoreViewModel()
    var aarayTime = ["12:00 AM - 01:00 AM","01:00 AM - 02:00 AM","02:00 AM - 03:00 AM","03:00 AM - 04:00 AM","04:00 AM - 05:00 AM","05:00 AM - 06:00 AM","06:00 AM - 07:00 AM","07:00 AM - 8:00 AM","8:00 AM - 9:00 AM","9:00 AM - 10:00 AM","10:00 AM - 11:00 AM","11:00 AM - 12:00 PM","12:00 PM - 01:00 PM","01:00 PM - 02:00 PM","02:00 PM - 03:00 PM","03:00 PM - 04:00 PM","04:00 PM - 05:00 PM","05:00 PM - 06:00 PM","06:00 PM - 07:00 PM","07:00 PM - 8:00 PM","8:00 PM - 9:00 PM","9:00 PM - 10:00 PM","10:00 PM - 11:00 PM","11:00 PM - 12:00 AM"]
    var aarayTimeSecond = ["00:00 - 01:00","01:00 - 02:00","02:00 - 03:00","03:00 - 04:00","04:00 - 05:00","05:00 - 06:00","06:00 - 07:00","07:00 - 08:00","08:00 - 09:00","09:00 - 10:00","10:00 - 11:00","11:00 - 12:00","12:00 - 13:00","13:00 - 14:00","14:00 - 15:00","15:00 - 16:00","16:00 - 17:00","17:00 - 18:00","18:00 - 19:00","19:00 - 20:00","20:00 - 21:00","21:00 - 22:00","22:00 - 23:00","23:00 - 00:00"]
    var aarayTimeSplitSecond = ["00:00:00","01:00:00","02:00:00","03:00:00","04:00:00","05:00:00","06:00:00","07:00:00","08:00:00","09:00:00","10:00:00","11:00:00","12:00:00","13:00:00","14:00:00","15:00:00","16:00:00","17:00:00","18:00:00","19:00:00","20:00:00","21:00:00","22:00:00","23:00:00"]
    
    
    @IBOutlet var btnProceed: UIButton!
    @IBOutlet weak var viewNoData: UIView!
    var firstTime = String()
    var secondTime = String()
    var arrayAvailTime = [String]()
    var arrayBookingSlot = [Int]()
    var arraySelectedIndex = [Int]()

    var arrayBookingSlotStatus = [Int:Int]()
    var arrayBookingSlotStatusValue = [Int]()
    
    
    
    var arrayTestingData = [[String : [[String : Any]]]]()
    
    //MARK:- View's Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setInitialSetup()
        print(aarayTime.count)
        print(aarayTimeSecond.count)
        print(aarayTimeSplitSecond.count)
        self.dateListCollectionView.isHidden = true
        self.viewNoData.isHidden = true
        btnProceed.backgroundColor = UIColor.init(red: 168/255, green: 168/255, blue: 168/255, alpha: 1)
        
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
                        //
                        
                        //                                    Helper.showOKAlertWithCompletion(onVC: self, title: Alerts.Alert, message: AlertMessage.internetConn, btnOkTitle: "OK") {
                        
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
        
//
//        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
//                  let controller = storyboard.instantiateViewController(withIdentifier: "SelectPayMentTypeVC") as! SelectPayMentTypeVC
//                  controller.hidesBottomBarWhenPushed = true
//                  navigationController?.pushViewController(controller, animated: true)
        
        
        
//         create the alert
        let alert = UIAlertController(title: "", message: "Do you want to book this Artist", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { action in
            
            // do something like...
            
            
            
            
            if self.first != -1 && self.second == -1{
                
                let inputString = self.aarayTimeSecond[self.first]
                let splits = inputString.components(separatedBy: " - ")
                self.firstTime = splits[0]
                self.secondTime = splits[1]
                let dataParam = ["type":selectedType,"date":selectedDate,"from_time":self.firstTime,"to_time":self.secondTime,"artist_id":userArtistID,"address":currentAddress] as [String : Any]
                
                print("the dict param is \(dataParam)")
                
                self.viewModelObject.getParamForBookingStore(param: dataParam)
                
            }else if self.first == -1 && self.second == -1{
                Helper.showOKAlertWithCompletion(onVC: self, title: "", message: "Please select Any Slot", btnOkTitle: "Done") {
                }
            }
                
            else   {
                
                let inputString = self.aarayTimeSecond[self.first]
                let splits = inputString.components(separatedBy: " - ")
                self.firstTime = splits[0]
                
                
                let inputString2 = self.aarayTimeSecond[self.second]
                let splits2 = inputString2.components(separatedBy: " - ")
                self.secondTime = splits2[1]
                let dataParam = ["type":selectedType,"date":selectedDate,"from_time":self.firstTime,"to_time":self.secondTime,"artist_id":userArtistID,"address":currentAddress] as [String : Any]
                
                print("the dict param is \(dataParam)")
                
                self.viewModelObject.getParamForBookingStore(param: dataParam)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
//        
        
        
        
    }
    
    
    
    @IBAction func btnClearAllActtion(_ sender: UIButton) {
        
        first = -1
        second = -1
        
        
        
        
        
        
        self.dateListCollectionView.reloadData()
        
    }
    
    
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSaveOnPress(_ sender: UIButton) {
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
        
                
        if first != -1 && second != -1{
            if checkRange(num: indexPath.row){
                cell.viewCell.backgroundColor = UIColor.init(red: 11/255, green: 172/255, blue: 43/255, alpha: 1)
                cell.lblTimeSelect.textColor = UIColor.white
            }else{
                if arrayBookingSlot.contains(indexPath.item){
                    if self.arrayBookingSlotStatus[indexPath.item] == 1{
                        cell.viewCell.borderColor = UIColor.clear
                                       cell.viewCell.layer.masksToBounds = true
                                       cell.viewCell.backgroundColor = UIColor.init(red: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1)
                                       cell.lblTimeSelect.textColor = UIColor.init(red: 54/255, green: 57/255, blue: 110/255, alpha: 1)
                    }else{
//
                        
                        
                        cell.viewCell.backgroundColor = UIColor.white
                                          cell.viewCell.borderColor = UIColor.clear
                                           cell.viewCell.layer.masksToBounds = true
                                           
                                           cell.lblTimeSelect.textColor = UIColor.init(red: 54/255, green: 57/255, blue: 110/255, alpha: 1)
                        
                        
                        
                    }
                    
                    
                }else{
//
                    
                    cell.viewCell.borderColor = UIColor.clear
                                  
                                  cell.viewCell.layer.masksToBounds = true

                                  cell.viewCell.backgroundColor = UIColor.init(red: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1)
                                  cell.lblTimeSelect.textColor = UIColor.init(red: 54/255, green: 57/255, blue: 110/255, alpha: 1)
                    
                }
                
            }
        }else if first != -1 && first == indexPath.row{
            cell.viewCell.backgroundColor = UIColor.init(red: 11/255, green: 172/255, blue: 43/255, alpha: 1)
            cell.lblTimeSelect.textColor = UIColor.white
        }else{
            if arrayBookingSlot.contains(indexPath.item){
                
                if self.arrayBookingSlotStatus[indexPath.item] == 1{
                    cell.viewCell.borderColor = UIColor.clear
                                   cell.viewCell.layer.masksToBounds = true
                                   cell.viewCell.backgroundColor = UIColor.init(red: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1)
                                   cell.lblTimeSelect.textColor = UIColor.init(red: 54/255, green: 57/255, blue: 110/255, alpha: 1)


                }else{
                    cell.viewCell.backgroundColor = UIColor.white
                   cell.viewCell.borderColor = UIColor.clear
                    cell.viewCell.layer.masksToBounds = true
                    
                    cell.lblTimeSelect.textColor = UIColor.init(red: 54/255, green: 57/255, blue: 110/255, alpha: 1)
                }
                
            }else{
                cell.viewCell.borderColor = UIColor.clear
                cell.viewCell.layer.masksToBounds = true
                cell.viewCell.backgroundColor = UIColor.init(red: 228/255.0, green: 228/255.0, blue: 228/255.0, alpha: 1)
                cell.lblTimeSelect.textColor = UIColor.init(red: 54/255, green: 57/255, blue: 110/255, alpha: 1)
            }
            
        }
        //
        //
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dataItem = aarayTimeSecond[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateListCollectionViewCell", for: indexPath) as! dateListCollectionViewCell
        cell.lblTimeSelect.text = aarayTime[indexPath.row]
        
        
       
        
        
//
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
//                 if arraySelectedIndex.count > 0{
//
//                    if arraySelectedIndex.contains(indexPath.row){
//
//                        let indexOfElement = arraySelectedIndex.firstIndex(of: arraySelectedIndex[indexPath.row]) ?? 0
//                        arraySelectedIndex.remove(at: indexOfElement)
//
//                    }else{
//                        arraySelectedIndex =  arraySelectedIndex.sorted{ $0 < $1 }
//                                                 let min = arraySelectedIndex.first ?? 0
//                                                 let max = arraySelectedIndex.last ?? 0
//                                                 if min + 1 == indexPath.row {
//                                                   arraySelectedIndex.append(indexPath.row)
//                                                 }
//                                                 else if min - 1 == indexPath.row {
//                                                     arraySelectedIndex.append(indexPath.row)
//                                                 }else if max - 1 == indexPath.row{
//                                                     arraySelectedIndex.append(indexPath.row)
//
//                                                 }else if max + 1 == indexPath.row{
//                                                     arraySelectedIndex.append(indexPath.row)
//                                                 }
//                    }
//
//
//                        }else{
//                            arraySelectedIndex.append(indexPath.row)
//
//                        }
//                        print("not valid array index\(arraySelectedIndex)")

                if first == -1{
                    first = indexPath.row
                }else if first < indexPath.row{
                    second = indexPath.row
                }else if first == indexPath.row{
                    first = -1
                }
                else{
                    let temp = first
                    first = indexPath.row
                    second = temp
                }
                btnProceed.backgroundColor = UIColor.init(red: 234/255, green: 10/255, blue: 97/255, alpha: 1)
            }
        }else{


            let alert = UIAlertController(title: "", message: "Artist is not available", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)

            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
        }
        print("the index array is \(indxArr)")
        self.dateListCollectionView.reloadData()
    }
}


extension EditDateVC : BookingStoreViewModelProtocol{
    func bookingStoreApiResponse(message: String, response: [String : Any], isError: Bool) {
        if isError == true{
            
            print("the respons is \(response)")
            
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                      self.present(alert, animated: true, completion: nil)
                      
                      // change to desired number of seconds (in this case 5 seconds)
                      let when = DispatchTime.now() + 5
                      DispatchQueue.main.asyncAfter(deadline: when){
                          // your code with delay
                          alert.dismiss(animated: true, completion: nil)
                      }
            
//        
        }else{
            Helper.showOKAlertWithCompletion(onVC: self, title: "", message: "Booking Successfull", btnOkTitle: "Done") {
                userArtistID = 0
                for controller in (self.navigationController?.viewControllers ?? []) as Array {
                    if controller.isKind(of: HOmeViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }else{
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        
    }
    
    
}
