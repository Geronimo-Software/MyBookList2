//
//  LocalizableExtension.swift
//  MyBookList
//
//  Created by Kio on 01/02/2019.
//  Copyright © 2019 geronimo.software. All rights reserved.
////https://medium.com/@marcosantadev/app-localization-tips-with-swift-4e9b2d9672c9

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
