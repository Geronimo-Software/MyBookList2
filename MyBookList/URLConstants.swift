//
//  URLConstants.swift
//  MyBookList
//
//  Created by Kio on 05/02/2019.
//  Copyright © 2019 geronimo.software. All rights reserved.
//

import Foundation

 let notificationClear = Notification.Name(rawValue: NotificationConstants.clearDisplayScreen)


struct URLConstants {

    static let urlGetBookList = "https://tpbookserver.herokuapp.com/books"
    static let urlGetSingleBook = "https://tpbookserver.herokuapp.com/book/"
    static let urlUpdateSingleBook = "http://tpbookserver.herokuapp.com/book/"
}

