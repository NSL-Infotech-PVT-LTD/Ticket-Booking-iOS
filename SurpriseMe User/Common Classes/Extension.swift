//
//  Extension.swift
//  AllNewProject
//    com.omninos.Teksie-Driver
//  Created by Infosif Solutions on 1/18/19.
//  Copyright © 2019 Omninos Solutions . All rights reserved.
//

import UIKit
import Foundation

class Extension: NSObject{
    
    func msg(message: String){
        
        let alertView = UIAlertController(title: "Login", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Cancle", style: .default, handler: nil))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
        
        let alertView2 = UIAlertController(title:"Register", message: message, preferredStyle: .alert)
        alertView2.addAction(UIAlertAction(title: "Register", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertView2, animated: true, completion: nil)
        
    }


}

extension Bundle {
    private static var bundle: Bundle!

    public static func localizedBundle() -> Bundle! {
        if bundle == nil {
            let appLang = UserDefaults.standard.string(forKey: "app_lang") ?? "en"
            let path = Bundle.main.path(forResource: appLang, ofType: "lproj")
            bundle = Bundle(path: path!)
        }

        return bundle;
    }

    public static func setLanguage(lang: String) {
        UserDefaults.standard.set(lang, forKey: "app_lang")
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        bundle = Bundle(path: path!)
    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle(), value: "", comment: "")
    }

    func localizeWithFormat(arguments: CVarArg...) -> String{
        return String(format: self.localized(), arguments: arguments)
    }
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = String(t?.prefix(maxLength) ?? "")
    }
}




//MARK: customTrasition 
func customTransitionOn(View: UIView, withDirection:String)
{
    let transition = CATransition()
    transition.duration = 0.3
    transition.type = CATransitionType.push
    if withDirection == "R"{
        transition.subtype = CATransitionSubtype.fromRight
    }else if withDirection == "L"{
        transition.subtype = CATransitionSubtype.fromLeft
    }else if withDirection == "T"{
        transition.subtype = CATransitionSubtype.fromTop
    }else{
        transition.subtype = CATransitionSubtype.fromBottom
    }
    transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
    View.layer.add(transition, forKey: kCATransition)

}


//MARK:- UITextfield extention
extension UITextField
{
    @IBInspectable var placeHolderColor: UIColor?
        {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}



//MARK:- UIButton extention
extension UIButton
{
    func roundedButton(){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,byRoundingCorners: [.topLeft , .topRight],cornerRadii:CGSize(width:8.0, height:8.0))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
}

//MARK:- UIViewController extention
extension UIViewController{
    
    func navigate(identifier: String){
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc1!, animated: true)
    }
    
    
    
    func navigationHome()  {
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "CustomtabBarProVC")
               self.navigationController?.pushViewController(vc1!, animated: true)
    }
    
    
    func presentViewController(viewController : String , value : String)  {
      
        let storyboard = UIStoryboard(name: value, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: viewController)
        let navController = UINavigationController(rootViewController: controller)
         navController.modalPresentationStyle = .overCurrentContext
        navController.isNavigationBarHidden = true
        controller.hidesBottomBarWhenPushed = true
        self.present(navController, animated:true, completion: nil)
    }
    
    func pushWithAnimate(StoryName :String,Controller : String)  {
            let storyboard = UIStoryboard(name: StoryName, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: Controller)
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: .default)
            transition.type = .reveal
            transition.subtype = .fromLeft
            navigationController?.view.layer.add(transition, forKey: kCATransition)
            navigationController?.pushViewController(controller, animated: false)
    }
    
    func pushWithAnimateDirectly(StoryName :String,Controller : String)  {
               let storyboard = UIStoryboard(name: StoryName, bundle: nil)
               let controller = storyboard.instantiateViewController(withIdentifier: Controller)
               let transition = CATransition()
               transition.duration = 0.5
               transition.timingFunction = CAMediaTimingFunction(name: .default)
               transition.type = .fade
               transition.subtype = .fromRight
               controller.hidesBottomBarWhenPushed = true
               navigationController?.view.layer.add(transition, forKey: kCATransition)
               navigationController?.pushViewController(controller, animated: false)
     }
    
  
    
  
    
    
    func goToDashBoard()  {
           let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           let viewController = mainStoryboard.instantiateViewController(withIdentifier: "DashboardTabBarController") as! DashboardTabBarController
           UIApplication.shared.keyWindow?.rootViewController = viewController;
       }
    
    func goToLogin()  {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        UIApplication.shared.keyWindow?.rootViewController = viewController;
    }

    
    
    func back(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func showSimpleAlert( Title : String, message: String , inClass : UIViewController){
        let alertController = UIAlertController(title: Title, message:message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
        inClass.present(alertController, animated: true) {
        }
    }
}

//SearchBar Font Size and style:-
extension UISearchBar {

    func change(textFont : UIFont?) {

        for view : UIView in (self.subviews[0]).subviews {

            if let textField = view as? UITextField {
                textField.font = textFont
            }
            
        }
    }
}


struct Font {
    enum Style: String {
        case PoppinsRegular = "Poppins-Regular"
    }
    static func create(style: Style, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: style.rawValue, size: size) else { return UIFont() }
        return font
    }
}

//searchBar Font And color set
extension UIViewController {
    
    func searchFontSets(searchBar: UISearchBar) {
        // SearchBar text
        searchBar.setImage(UIImage(named: "search-icon"), for: .search, state: .normal)
        searchBar.backgroundImage = UIImage.init(named: "seaechBack")
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(12)

        // SearchBar placeholder
        let labelInsideUISearchBar = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        labelInsideUISearchBar?.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        _ = UISearchBar(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 44))
        
    }
}

//Set Tab Bar Custom Height from storyboard:-
class CustomHeightTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 0.0
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height
        }
        return sizeThatFits
    }
}

extension UIDevice {

    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
           return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
   }
}
extension UIView {
    
    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        self.layer.addSublayer(shadowLayer)
    }
    
    func addShadowWithCornerRadius(viewObject : UIView)  {
        viewObject.layer.cornerRadius = 8
        viewObject.layer.shadowColor = UIColor.darkGray.cgColor
        viewObject.layer.shadowOpacity = 1
        viewObject.layer.shadowRadius = 3
        //MARK:- Shade a view
        viewObject.layer.shadowOpacity = 0.5
        viewObject.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        viewObject.layer.masksToBounds = false
    }
    
}
