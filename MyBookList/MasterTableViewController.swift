//
//  MasterTableViewController.swift
//  MyBookList
//
//  Created by Kio on 28/01/2019.
//  Copyright © 2019 geronimo.software. All rights reserved.
//

import Foundation
import UIKit

//class for custom cell
class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var cellBG: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellAuthor: UILabel!
}





class MasterTableViewController: UITableViewController {
    
    var bookCollection = [Book]()
    
    var filteredbookCollection = [Book]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedBook:Book? = nil
    
    let notificationClear = Notification.Name(rawValue: NotificationConstants.clearDisplayScreen)
    let notificationDisplay = Notification.Name(rawValue: NotificationConstants.displayBookDetails)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        configureSearchController()
        configureRefreshControl()
        
        JSONCalls.sharedInstance.bookListJSONDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        //go grab the data for table
        getBookList()
    }
    
    // MARK: table refresh
    func configureRefreshControl() {
        // Configure Refresh Control
        tableView.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(refreshBookData(_:)), for: .valueChanged)
        refreshControl?.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        
        let attributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)]
        refreshControl?.attributedTitle = NSAttributedString(string: "RefreshControlTitle".localized(), attributes: attributes)
    }
    
    @objc private func refreshBookData(_ sender: Any) {
        if isSearchBarActive() == false {
            // Fetch book list Data
            getBookList()
            self.refreshControl?.beginRefreshing()
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: table view data source and delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredbookCollection.count
        }

        if self.bookCollection.count == 0 {
            return self.bookCollection.count + 2
        } else {
        return self.bookCollection.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(" ")
        print("indexPath.row: ")
        print(indexPath.row)
        print("self.bookCollection.count: ")
        print(self.bookCollection.count)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let selectedView = UIView()
        selectedView.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0.4)
        cell.selectedBackgroundView = selectedView
        
        if isFiltering() {
            cell.detailTextLabel?.text = self.filteredbookCollection[indexPath.row].author
            cell.textLabel?.text = self.filteredbookCollection[indexPath.row].title
            cell.cellTitle?.text = self.filteredbookCollection[indexPath.row].title
            cell.cellAuthor?.text = self.filteredbookCollection[indexPath.row].author
            
            let isSelected:Bool = (selectedBook?.id == self.filteredbookCollection[indexPath.row].id ? true:false)
            if isSelected {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                //post notifcation to clear book details
                NotificationCenter.default.post(name: notificationDisplay, object: self.filteredbookCollection[indexPath.row])
            }
        } else {
            
            if ((self.bookCollection.count == 0 && indexPath.row == 0) ) {
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "AppleTop", for: indexPath)
                print("cell AppleTop")
                return cell2
            }
            else if (self.bookCollection.count == 0 && indexPath.row == 1) {
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "Table", for: indexPath)
                print("cell Table")
                return cell2
            }  else if (indexPath.row == self.bookCollection.count ) {
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "Table", for: indexPath)
                print("cell Table")
                return cell2
            }
            
            print("cell Cell")
            
            let cellBook:Book = self.bookCollection[indexPath.row]
            cell.detailTextLabel?.text = cellBook.author
            cell.textLabel?.text = cellBook.title
            
            let tmp = whichBookCover(initalOfAuthor: String(cellBook.author!.prefix(1)))
   //         cell.cellBG.image = UIImage(named: tmp)// "bookStack" + String(Int.random(in: 1 ... 8)) + ".png")

            
            let cellSelectedBackgroundView = UIImageView(image: UIImage(named: tmp))
            cell.backgroundView  = cellSelectedBackgroundView

            
          //  cell.backgroundView = UIImageView(named: tmp)// setBackgroundView:urBgImgView
            
            let isSelected:Bool = (selectedBook?.id == cellBook.id ? true:false)
            if isSelected {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                //post notifcation to clear book details
                NotificationCenter.default.post(name: notificationDisplay, object: cellBook)
            }
        }
        
        return cell
    }
    
    func whichBookCover(initalOfAuthor: String) -> String {
        
        let book1 = "an"
        let book2 = "bo"
        let book3 = "cp"
        let book4 = "dq"
        let book5 = "er"
        let book6 = "fs"
        let book7 = "gt"
        let book8 = "hu"
        let book9 = "iv"
        let book10 = "jw"
        let book11 = "kx"
        let book12 = "ly"
        let book13 = "mz"
        
        if book1.contains(initalOfAuthor) { return "bookSpine_1.png" }
        else if book2.contains(initalOfAuthor.lowercased()) { return "bookSpine_2.png" }
        else if book3.contains(initalOfAuthor.lowercased()) { return "bookSpine_3.png" }
        else if book4.contains(initalOfAuthor.lowercased()) { return "bookSpine_4.png" }
        else if book5.contains(initalOfAuthor.lowercased()) { return "bookSpine_5.png" }
        else if book6.contains(initalOfAuthor.lowercased()) { return "bookSpine_6.png" }
        else if book7.contains(initalOfAuthor.lowercased()) { return "bookSpine_7.png" }
        else if book8.contains(initalOfAuthor.lowercased()) { return "bookSpine_8.png" }
        else if book9.contains(initalOfAuthor.lowercased()) { return "bookSpine_9.png" }
        else if book10.contains(initalOfAuthor.lowercased()) { return "bookSpine_10.png" }
        else if book11.contains(initalOfAuthor.lowercased()) { return "bookSpine_11.png" }
        else if book12.contains(initalOfAuthor.lowercased()) { return "bookSpine_12.png" }
        else if book13.contains(initalOfAuthor.lowercased()) { return "bookSpine_13.png" }
        return "bookSpine_8.png"
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            if (self.filteredbookCollection[indexPath.row].description == nil){
                DisplayView.sharedInstance.showLoaderFullView()
                JSONCalls.sharedInstance.callBookdetailJSON(bookID: self.filteredbookCollection[indexPath.row].id!)
            } else {
                //post notifcation to clear book details
                NotificationCenter.default.post(name: notificationDisplay, object: self.filteredbookCollection[indexPath.row])
            }
            selectedBook = self.filteredbookCollection[indexPath.row]
        } else {
            let cellBook:Book = self.bookCollection[indexPath.row]
            if (cellBook.description == nil){
                DisplayView.sharedInstance.showLoaderFullView()
                JSONCalls.sharedInstance.callBookdetailJSON(bookID: cellBook.id!)
            } else {
                //post notifcation to clear book details
                NotificationCenter.default.post(name: notificationDisplay, object: cellBook)
            }
            selectedBook = self.bookCollection[indexPath.row]
        }
    }
    
    func updateTable() {
        DispatchQueue.main.async { //always on main now
            self.tableView.reloadData()
            DisplayView.sharedInstance.removeLoader()
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    // MARK: JSON calls
    //one call on viewDidLoad/tablePullToRefresh to entire grab list via this func
    func getBookList() {
        //view will appear, could ask if we have a book list already loaded from last app visit but not knowing the full extent of the apps use that feature would be npointless. for now treat as it should be a always online app, no offline mode.
        
        selectedBook = nil
        //show "please wait" loader on network tasks
        DisplayView.sharedInstance.showLoaderFullView()
        JSONCalls.sharedInstance.callBookListJSON()
    }
    
    // MARK: seach bar calls
    func configureSearchController() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "SearchBarPlaceHolder".localized()
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredbookCollection = bookCollection.filter({( book : Book) -> Bool in
            return (book.author?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func isFilteringEmpty() -> Bool {
        return searchController.isActive && searchBarIsEmpty()
    }
    
    func isSearchBarActive () -> Bool {
        return searchController.isActive
    }
    

    
    

    
    
    
}

extension MasterTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        if (isFiltering()) && !((self.filteredbookCollection.filter{ $0.id == selectedBook?.id }.first) != nil) {
            //post notifcation to clear book details
            NotificationCenter.default.post(name: notificationClear, object: nil)
        }
    }
}

extension MasterTableViewController: BookListJSONDelegate {
    
    func updateBookWithDesc(bookDetails: Book?) {
        //idea here is we should always go online for "new book list" but for just one book desc save it as we go. then check if we have it next time. wouldnt need to be called here if you had of mad e a dataManager class. next time as its a messy long drawn out way
        //then again if we failed request from server then we should still display the data we have in our own table.
        if (bookDetails?.description == nil) {
            updateTable()
        } else {
            self.bookCollection.filter{ $0.id == bookDetails!.id }.first?.description = bookDetails!.description
        }
    }
    
    func fetchedBookListJSON(bookList: [Book]) {
        //callback from delgate with new book list array
        bookCollection = bookList
        updateTable()
    }
}

