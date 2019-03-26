//
//  JSONCalls.swift
//  MyBookList
//
//  Created by Kio on 30/01/2019.
//  Copyright © 2019 geronimo.software. All rights reserved.
//

import Foundation

protocol BookListJSONDelegate: class {
    
    func fetchedBookListJSON(bookList:[Book])
    func updateBookWithDesc(bookDetails: Book?)
}

protocol BookDetailJSONDelegate: class {
    func fetchedBookDetialJSON(bookDetails: Book)
}

class JSONCalls  {
    //anything for the server api
    
    var bookListJSONDelegate:BookListJSONDelegate!
    var bookDetailJSONDelegate:BookDetailJSONDelegate!
    
    static let sharedInstance = JSONCalls()
    
    var bookCollectionJSON = [Book]()
    var newBookWithDesc:Book!
    
    func callBookListJSON() {
        
        let urlString =  URLConstants.urlGetBookList
        print("urlString : " + urlString)
        
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            //check err
            if (err != nil) {
                print("oops Error URLSession \(String(describing: err))")
                DisplayView.sharedInstance.callAlert("AlertErrorURLSession".localized())
                
                return }
            
            //also check response status 200 OK
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode != 200{
                    print("oops Error URLSession \(String(describing: httpResponse.statusCode))")
                    DisplayView.sharedInstance.callAlert("AlertErrorURLSession".localized())
                    return }
            }
            
            guard let data = data else { return }
            
            do {
                self.bookCollectionJSON = try JSONDecoder().decode([Book].self, from: data)
            } catch let jsonErr {
                print("oops Error serializing json:", jsonErr)
                DisplayView.sharedInstance.callAlert("AlertErrorURLSession".localized())
            }
            
            //now call delegate to passs back info
            self.bookListJSONDelegate.fetchedBookListJSON(bookList:self.bookCollectionJSON )
            
            }.resume()
    }
    
    func callBookdetailJSON(bookID: Int) {
        
        let urlString = URLConstants.urlGetSingleBook + String(bookID)
        print("urlString : " + urlString)
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            //check err
            if (err != nil) {
                print("opps Error URLSession \(String(describing: err))")
                DisplayView.sharedInstance.callAlert("AlertErrorURLSession".localized())
                return }
            //also check response status 200 OK
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 404 {
                    print("opps Error client \(String(describing: httpResponse.statusCode))") }
                else if httpResponse.statusCode == 500 {
                    print("opps Error server \(String(describing: httpResponse.statusCode))") }
                else if httpResponse.statusCode != 200 {
                    print("opps Error, the statusCode was \(String(describing: httpResponse.statusCode))") }
                
                
                if httpResponse.statusCode != 200 {
                    //maybe should have the dispay print what it knows even though we had a failed get for more information?
                    self.bookListJSONDelegate.updateBookWithDesc(bookDetails: nil) //it'll be empty tho so just refresh table
                    
                    DisplayView.sharedInstance.callAlert("AlertErrorURLSession".localized())
                    return
                }
            }
            
            guard let data = data else { return }
            
            do {
                self.newBookWithDesc = try JSONDecoder().decode(Book.self, from: data)
                
            } catch let jsonErr {
                DisplayView.sharedInstance.callAlert("AlertErrorURLSession".localized())
                print("opps Error serializing json:", jsonErr)
                return
            }
            
            self.bookDetailJSONDelegate.fetchedBookDetialJSON(bookDetails: self.newBookWithDesc)
            self.bookListJSONDelegate.updateBookWithDesc(bookDetails: self.newBookWithDesc)
            }.resume()
    }
    
    func knowBookDetail(knownBookWithDesc:Book) {
        self.bookDetailJSONDelegate.fetchedBookDetialJSON(bookDetails: knownBookWithDesc)
    }
    
    //func updateBookDetailJSON(updateBook:Book) {
    func updateBookDetailJSON() {
        //not implemented on server but this is how it'd look given more details
        
        let id:String = "101"//String(updateBook.id!)
        let url = URL(string: URLConstants.urlUpdateSingleBook + id)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        var params :[String: Any]?
        params = ["id" : "updateBook.id", "title" : "updateBook.title", "isbn" : "updateBook.isbn", "description" : "updateBook.description", "price" : "updateBook.price", "currencyCode" : "updateBook.currencyCode", "author" : "updateBook.author"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params!, options: [])
        //request.httpBody = """
       // {...}
       // """.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            //check err
            if (error != nil) {
                print("oops Error UPDATESession \(String(describing: error))")
                DisplayView.sharedInstance.callAlert("AlertErrorUPDATESession".localized())
                
                return }
            
            //also check response status 200 OK
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode != 200{
                    print("oops Error UPDATESession \(String(describing: httpResponse.statusCode))")
                    DisplayView.sharedInstance.callAlert("AlertErrorUPDATESession".localized())
                    return }
            }
            
            
            if let response = response {
                print(response)
                
                if let data = data, let body = String(data: data, encoding: .utf8) {
                    print(body)
                }
            } else {
                print(error ?? "Unknown error")
            }
        }
        
        
        //get book with id from server, this replaces the existing bok we have in record with the new book.
     //   callBookdetailJSON(bookID: updateBook.id!)
        
        task.resume()
    }
}
