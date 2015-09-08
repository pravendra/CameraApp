//
//  DPrint.swift
//  Camera_App
//
//  Created by Singh, Pravendra on 9/4/15.
//  Copyright © 2015 Praven. All rights reserved.
//

import Foundation

func DPrint<T>(@autoclosure object: () -> T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) {
    #if DEBUG
        let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
        let queue = NSThread.isMainThread() ? "UI" : "BG"
        
        print("<\(queue)> \(fileURL) \(function)[\(line)]: \(object())")
    #endif
}