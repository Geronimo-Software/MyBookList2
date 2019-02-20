//
//  DetailDisplayViewController.swift
//  MyBookList
//
//  Created by Kio on 28/01/2019.
//  Copyright © 2019 geronimo.software. All rights reserved.
//

import Foundation
import UIKit


class DetailDisplayViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionText: UITextView!
    @IBOutlet weak var detailTitleText: UITextField!
    @IBOutlet weak var detailAuthorText: UITextField!
    @IBOutlet weak var detailISBNText: UITextField!
    @IBOutlet weak var detailPriceText: UITextField!
    @IBOutlet weak var detailTitleLabel: UILabel!
    
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonDone: UIButton!
    
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var labeltitle: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelISBN: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    var inBookEditMode:Bool = false
    
    let notificationClear = Notification.Name(rawValue: NotificationConstants.clearDisplayScreen)
    let notificationDisplay = Notification.Name(rawValue: NotificationConstants.displayBookDetails)
    
    var bookID: Int? {
        didSet {
            if let bookID = bookID {
                print("test method" + String(bookID))
                //updateDisplayText(book)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JSONCalls.sharedInstance.bookDetailJSONDelegate = self
        
        // Do any additional setup after loading the view
        createObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func clearDisplayText () {
        DispatchQueue.main.async { //always on main now
            self.inBookEditMode = false
            self.enableDisplayText(self.inBookEditMode)
            self.setButtons(bookEditMode:self.inBookEditMode)
            
            self.detailDescriptionText.setContentOffset(CGPoint.zero, animated: false)
            self.detailDescriptionText.text = ""
            
            self.detailTitleText.text = ""
            self.detailTitleLabel.text = ""
            
            self.detailAuthorText.text = ""
            self.detailISBNText.text = ""
            self.detailPriceText.text = ""
        }
    }
    
    func updateDisplayText (_ book: Book) {
        DispatchQueue.main.async { //always on main now
            self.buttonEdit.isEnabled = true
            
            self.detailDescriptionText.text = book.description
            self.detailDescriptionText.setContentOffset(CGPoint.zero, animated: false)
            
            //detailTitleText.text = book.title
            self.detailTitleLabel.text = book.title
            
            self.detailAuthorText.text = book.author
            self.detailISBNText.text = book.isbn
            self.detailPriceText.text = book.toCurrencyFormat()
            
            DisplayView.sharedInstance.removeLoader()
        }
    }
    
    private func enableDisplayText (_ onOff: BooleanLiteralType) {
        detailDescriptionText.isEditable = onOff
        
        detailTitleText.isEnabled = onOff
        detailTitleText.isEnabled = onOff
        detailTitleLabel.isHidden = onOff
        
        detailAuthorText.isEnabled = onOff
        detailISBNText.isEnabled = onOff
        detailPriceText.isEnabled = onOff
        
        let clearColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        let whiteColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        let orangeColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        detailDescriptionText.backgroundColor = (onOff ? whiteColor:clearColor)
        detailTitleText.backgroundColor = (onOff ? whiteColor:clearColor)
        detailAuthorText.backgroundColor = (onOff ? whiteColor:clearColor)
        detailISBNText.backgroundColor = (onOff ? whiteColor:clearColor)
        detailPriceText.backgroundColor = (onOff ? whiteColor:clearColor)
        
        labelDesc.textColor = (onOff ? orangeColor:whiteColor)
        labeltitle.textColor = (onOff ? orangeColor:whiteColor)
        labelAuthor.textColor = (onOff ? orangeColor:whiteColor)
        labelISBN.textColor = (onOff ? orangeColor:whiteColor)
        labelPrice.textColor = (onOff ? orangeColor:whiteColor)
    }
    
    @IBAction func doneBookDetails(_ sender: Any) {
 //this feature isnt enabled on server so wont implement
        //but itd go as follows
        //grab details into book object
        //do some validation
        //attach to json func to send post request
        //have delegate respond succes or not
        DisplayView.sharedInstance.callAlert("AlertErrorFeatureNotInOperation".localized())
    }
    @IBAction func editBookDetails(_ sender: Any) {
        //not fully set out. would need to call the post API which isnt implement yet so cant fully execute this feature anyway :(
        self.inBookEditMode = (self.inBookEditMode ? false:true)
        setButtons(bookEditMode:inBookEditMode)
    }
    func setButtons(bookEditMode:Bool) {
        
        enableDisplayText(self.inBookEditMode)
        let tempText = (self.inBookEditMode ? "ButtonCancel".localized():"ButtonEdit".localized())
        buttonEdit.setTitle(tempText, for: .normal)
        buttonDone.isHidden = (self.inBookEditMode ? false:true)
    }
}


//calls from delegate with new book details
extension DetailDisplayViewController: BookDetailJSONDelegate {
    func fetchedBookDetialJSON(bookDetails: Book) {

        self.updateDisplayText(bookDetails)
    }
}

//catch all notifications
extension DetailDisplayViewController {
    
    func createObservers() {

        NotificationCenter.default.addObserver(self, selector: #selector(DetailDisplayViewController.observerClearNotification(clearNotification:)), name: notificationClear, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailDisplayViewController.observerDisplayBookNotification(displayNotification:)), name: notificationDisplay, object: nil)
        
    }
    
    @objc func observerClearNotification(clearNotification: NSNotification) {
        self.clearDisplayText()
    }
    
    
    @objc func observerDisplayBookNotification(displayNotification: NSNotification) {
        let knownBookWithDesc:Book = displayNotification.object as! Book
        self.updateDisplayText(knownBookWithDesc)
    }
    
}

