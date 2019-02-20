//
//  DisplayView.swift
//  MyBookList
//
//  Created by Kio on 30/01/2019.
//  Copyright © 2019 geronimo.software. All rights reserved.
//

import Foundation
import UIKit

class DisplayView: NSObject {
    
    static let sharedInstance = DisplayView()
    private var activityIndicator = UIActivityIndicatorView()
    private var activityView = UIView()
    private var activityBGView  = UIView()
    private var activityMainView  = UIView()
    
    let activityLabel = UILabel()
    var activityBannerView = UIView()
    
    private var alert = UIAlertController()
    private var holdingView = UIView()
    private var holdingViewController = UIViewController()
    
    @IBAction func closeContactModal(_ sender: Any) {
     //   dismiss(animated: false, completion: nil)
    }
    override init() {
        super.init()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        holdingViewController = appDel.window!.rootViewController!
        holdingView = appDel.window!.rootViewController!.view!
        
        self.setupLoader()
    }
    
    private func setupLoader() {        
        activityLabel.text = "ActivityLabelText".localized()
        activityLabel.frame = CGRect(x: 70, y: 0, width: holdingView.frame.width-90, height: 40)
        activityLabel.textColor = UIColor .white
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 30, y: 0, width: 40, height: 40))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.white
        //activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        
        activityBannerView = UIView(frame: CGRect(x: 0, y: 44, width: holdingView.frame.width, height: 44))
        activityBannerView.backgroundColor = UIColor .orange
        
        activityBGView = UIView(frame: CGRect(x: 0, y: 0, width: holdingView.frame.width, height: holdingView.frame.height))
        activityBGView.backgroundColor = UIColor .lightGray
        activityBGView.alpha = 0.5
        
        activityMainView = UIView(frame: CGRect(x: 0, y: 0, width: holdingView.frame.width, height: holdingView.frame.height))
        
        activityBannerView.addSubview(activityLabel)
        activityBannerView.addSubview(activityIndicator)
        activityMainView.addSubview(activityBGView)
        activityMainView.addSubview(activityBannerView)
    }
    
    func setWidthHeight() {
        activityLabel.frame = CGRect(x: 70, y: 0, width: holdingView.frame.width-90, height: 40)
        activityIndicator.frame = CGRect(x: 30, y: 0, width: 40, height: 40)
        activityBannerView.frame = CGRect(x: 0, y: 44, width: holdingView.frame.width, height: 44)
        activityBGView.frame = CGRect(x: 0, y: 0, width: holdingView.frame.width, height: holdingView.frame.height)
        activityMainView.frame = CGRect(x: 0, y: 0, width: holdingView.frame.width, height: holdingView.frame.height)
    }
    
    
    
    //MARK:  Public Methods
    
    //removes the please wait loading banner
    func removeLoader(){
        DispatchQueue.main.async {
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
            self.activityMainView.removeFromSuperview()
        }
    }
    
    //shows the please wait loading banner
    func showLoaderFullView() {
        DispatchQueue.main.async {
            if !(self.activityMainView.frame.width == self.holdingView.frame.width) {
                self.setWidthHeight()
            }
            //send notifcation to display book details
            NotificationCenter.default.post(name: notificationClear, object: nil)
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.activityIndicator.startAnimating()
            self.holdingView.addSubview(self.activityMainView)
        }
    }
    
    //just the normal display alert to user, no actions attached
    func callAlert(_ alertTitle: String) {
        removeLoader()
        DispatchQueue.main.async { //always on main now
            let alert = UIAlertController(title: nil, message: alertTitle, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ButtonOK".localized(), style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("Alert default")  //do nothing really
                case .cancel:
                    print("Alert cancel")  //do nothing really
                case .destructive:
                    print("Alert destructive")  //do nothing really
                }}))
            self.holdingViewController.present(alert, animated: true, completion: nil)
        }
    }
}
