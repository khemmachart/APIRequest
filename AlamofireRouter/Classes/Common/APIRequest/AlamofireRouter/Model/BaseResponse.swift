//
//  BaseResponse.swift
//  AlamofireRouter
//
//  Created by Khemmachart Chutapetch on 1/8/2560 BE.
//  Copyright © 2560 Khemmachart Chutapetch. All rights reserved.
//

import Foundation

public class BaseResponse: NSObject {
    
    var statusCode: String?
    var message: String?
    
    required public init(withDictionary dict: [String: Any]) {
        super.init()
        statusCode = dict["statusCode"] as? String
        message = dict["message"] as? String
    }
}
