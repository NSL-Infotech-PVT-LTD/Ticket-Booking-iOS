//

//

import Foundation
import UIKit

class Helper: NSObject {
    
    //MARK:- set and get preferences for NSString
    /*!
     method getPreferenceValueForKey
     abstract To get the preference value for the key that has been passed
     */
    // NSUserDefaults methods which have been used in entire app.
    
    class func getPREF(_ key: String) -> String? {
        return Foundation.UserDefaults.standard.value(forKey: key) as? String
    }
    
    class func getUserPREF(_ key: String) -> Data? {
        return Foundation.UserDefaults.standard.value(forKey: key as String) as? Data
    }
    /*!
     method setPreferenceValueForKey for int value
     abstract To set the preference value for the key that has been passed
     */
    class func setPREF(_ sValue: String, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF for string
     abstract To delete the preference value for the key that has been passed
     */
    class func  delPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Integer
    /*!
     method getPreferenceValueForKey for array for int value
     abstract To get the preference value for the key that has been passed
     */
    class func getIntPREF(_ key: String) -> Int? {
        return Foundation.UserDefaults.standard.object(forKey: key as String) as? Int
    }
    /*!
     method setPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    class func setIntPREF(_ sValue: Int, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF for integer
     abstract To delete the preference value for the key that has been passed
     */
    class func  delIntPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Double
    /*!
     method getPreferenceValueForKey for array for int value
     abstract To get the preference value for the key that has been passed
     */
    class func getDoublePREF(_ key: String) -> Double? {
        return Foundation.UserDefaults.standard.object(forKey: key as String) as? Double
    }
    /*!
     method setPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    class func setDoublePREF(_ sValue: Double, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Array
    /*!
     method getPreferenceValueForKey for array
     abstract To get the preference value for the key that has been passed
     */
    class func getArrPREF(_ key: String) -> [String]? {
        return Foundation.UserDefaults.standard.object(forKey: key as String) as? [String]
    }
    /*!
     method setPreferenceValueForKey for array
     abstract To set the preference value for the key that has been passed
     */
    class func setArrPREF(_ sValue: [String], key: String) {
        Foundation.UserDefaults.standard.set(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF
     abstract To delete the preference value for the key that has been passed
     */
    class func  delArrPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Dictionary
    /*!
     method getPreferenceValueForKey for dictionary
     abstract To get the preference value for the key that has been passed
     */
    class func getDicPREF(_ key: String)-> NSDictionary {
        let data = Foundation.UserDefaults.standard.object(forKey: key as String) as! Data
        let object = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String: String]
        return object as NSDictionary
    }
    /*!
     method setPreferenceValueForKey for dictionary
     abstract To set the preference value for the key that has been passed
     */
    class func setDicPREF(_ sValue: NSDictionary, key: String) {
        Foundation.UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: sValue), forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Boolean
    /*!
     method getPreferenceValueForKey for boolean
     abstract To get the preference value for the key that has been passed
     */
    class func getBoolPREF(_ key: String) -> Bool {
        return Foundation.UserDefaults.standard.bool(forKey: key as String)
    }
    /*!
     method setBoolPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    class func setBoolPREF(_ sValue: Bool , key: String){
        Foundation.UserDefaults.standard.set(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF for boolean
     abstract To delete the preference value for the key that has been passed
     */
    class func  delBoolPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    
    
    
//    class func showLoader(onVC viewController: UIViewController, message: String) {
//        SKActivityIndicator.spinnerColor(UIColor.darkGray)
//        SKActivityIndicator.statusTextColor(UIColor.black)
//        SKActivityIndicator.statusLabelFont(TNotebookFonts.FONT_AVENIRLTST_BLACK_18 ?? UIFont.boldSystemFont(ofSize: 18))
//
//        SKActivityIndicator.spinnerStyle(.spinningFadeCircle)
//        SKActivityIndicator.show(message, userInteractionStatus: true)
//    }
    
//    class func hideLoader(onVC viewController: UIViewController) {
//        SKActivityIndicator.dismiss()
//    }
    
    class func showLoader(onVC viewController: UIViewController) {
        DispatchQueue.main.async {
//            IHProgressHUD.set(defaultStyle: .light)
//            IHProgressHUD.set(defaultMaskType: .black)
//            IHProgressHUD.set(foregroundColor: )
            //IHProgressHUD.show()
        }
    }
    
    class func hideLoader(onVC viewController: UIViewController) {
        DispatchQueue.main.async {
            //IHProgressHUD.dismiss()
        }
    }
    
    class func showOKAlert(onVC viewController:UIViewController,title:String,message:String) {
        DispatchQueue.main.async {
            let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
            //Alert.OK
            alert.view.tintColor = UIColor.black
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showOKAlertWithCompletion(onVC viewController: UIViewController, title: String, message: String, btnOkTitle: String, onOk: @escaping ()->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: btnOkTitle, style:.default, handler: { (action:UIAlertAction) in
                onOk()
            }))
            
            alert.view.tintColor = UIColor.black
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    
    class func showOKCancelAlertWithCancelCompletion(onVC viewController: UIViewController, title: String, message: String, btnOkTitle: String, btnCancelTitle: String, onOk: @escaping ()->(), onCancel:@escaping ()->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: btnOkTitle, style:.default, handler: { (action:UIAlertAction) in
//                onOk()
            }))
            alert.addAction(UIAlertAction(title: btnCancelTitle, style:.default, handler: { (action:UIAlertAction) in
                onCancel()
            }))
            alert.view.tintColor = UIColor.black
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showThreeButtonsAlertWithCompletion(onVC viewController: UIViewController, title: String?, message: String?, btnOneTitle: String, btnTwoTitle: String, btnThreeTitle: String, onBtnOneClick: @escaping ()->(), onBtnTwoClick: @escaping ()->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: btnOneTitle, style:.default, handler: { (action:UIAlertAction) in
                onBtnOneClick()
            }))
            alert.addAction(UIAlertAction(title: btnTwoTitle, style:.default, handler: { (action:UIAlertAction) in
                onBtnTwoClick()
            }))
            alert.addAction(UIAlertAction(title: btnThreeTitle, style:.default, handler: { (action:UIAlertAction) in
                
            }))
            alert.view.tintColor = UIColor.black
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showActionAlert(onVC viewController: UIViewController, onTakePhoto:@escaping ()->(), onChooseFromGallery:@escaping ()->()) {
        DispatchQueue.main.async {
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
            
            let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
                print("Take Photo")
                
                onTakePhoto()
            }
            actionSheetControllerIOS8.addAction(saveActionButton)
            
            let deleteActionButton: UIAlertAction = UIAlertAction(title: "Choose from library", style: .default) { action -> Void in
                print("Choose from library")
                
                onChooseFromGallery()
            }
            actionSheetControllerIOS8.addAction(deleteActionButton)
            
            if let popoverPresentationController = actionSheetControllerIOS8.popoverPresentationController {
                popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                
                var rect = viewController.view.frame;
                
                rect.origin.x = viewController.view.frame.size.width / 20;
                rect.origin.y = viewController.view.frame.size.height / 20;
                
                popoverPresentationController.sourceView = viewController.view
                popoverPresentationController.sourceRect = rect
            }
            
            actionSheetControllerIOS8.view.tintColor = UIColor.black
            viewController.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
    }
    
//    class func convertImageToBase64(image: UIImage) -> String {
//        if let imageData = UIImageJPEGRepresentation(image, 0.6) {
//            return imageData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
//        } else {
//            return ""
//        }
//    }
    
    class func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: Date())
    }
    
    class func calendarDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd, MMMM yyyy"
        return dateFormatter.string(from: Date())
    }
    
    class func sessionDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: Date())
    }
    
    class func convertSessionDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd, MMMM yyyy"
        let date = dateFormatter.date(from: dateString)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "dd-MM-yyyy"
        return newDateFormatter.string(from: date ?? Date())
    }
    
    class func convertMonthlyDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let newDate = dateFormatter.date(from: date)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "dd EEE"
        let dateString = newDateFormatter.string(from: newDate ?? Date())
        return dateString
    }
    
    class func currentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: Date())
    }
    
    class func convertCurrentDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd, MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    class func getBirthDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    class func convertDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let date = dateFormatter.date(from: dateString)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "dd-MM-yyyy"
        return newDateFormatter.string(from: date ?? Date())
    }
    
    class func convertProgramDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MM/dd/yyyy"
        return newDateFormatter.string(from: date ?? Date())
    }
    
    class func convertProfileDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: dateString)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MM/dd/yyyy"
        return newDateFormatter.string(from: date ?? Date())
    }
    
    class func calcAge(_ birthday: String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar = Calendar.init(identifier: .gregorian)
        let calcAge = calendar.dateComponents([.year], from: birthdayDate ?? Date(), to: Date())
        return String(calcAge.year ?? 0)
    }
}

func getDateFromString(string:String) -> Date{
    let isoDate = string

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    let date = dateFormatter.date(from:isoDate)!
    return date
}
// MARK:- UITextField Extension Dav..
extension UITextField {
    
}
