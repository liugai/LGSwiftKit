//
//  LGDefine.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/9/24.
//

import Foundation

func debugPrint<T>(_ message: T, filePath: String = #file, function:String = #function, rowCount: Int = #line) {
    #if DEBUG
    let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
    print(fileName + "/ " + "\(rowCount)" + "/ " + "\(function)" + " ->: \(message)")
    #endif
}

