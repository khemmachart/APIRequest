//
//  APIRequestDebugger.swift
//  AlamofireRouter
//
//  Created by Khemmachart Chutapetch on 1/17/2560 BE.
//  Copyright © 2560 Khemmachart Chutapetch. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Log Request

extension DataRequest {
    
    public func logRequest() -> DataRequest {
        if let request = self.request {
            APIRequest.logDivider()
            APIRequest.logPath(URL: request.url, withKey: "Request")
            APIRequest.logHTTPMethod(request: request)
            APIRequest.logHeaders(headers: request.allHTTPHeaderFields)
            APIRequest.logJSON(data: request.httpBody)
            APIRequest.logDivider()
        }
        return self
    }
}

// MARK: - Log Response

extension APIRequest {
    
    public static func logResponse(_ aResponse: DataResponse<Any>) {
        if let response = aResponse.response {
            self.logDivider()
            self.logPath(URL: response.url, withKey: "Response")
            self.logStatus(httpResponse: response)
            self.logHeaders(headers: response.allHeaderFields)
            self.logJSON(data: aResponse.data)
            self.logDivider()
        }
        
        /*
         if let startDate = Timberjack.propertyForKey(TimberjackRequestTimeKey, inRequest: newRequest!) as? NSDate {
         let difference = fabs(startDate.timeIntervalSinceNow)
         print("Duration: \(difference)s")
         }
         */
    }
    
}

// MARK: - Utiles

extension APIRequest {

    public static func logPath(URL: URL?, withKey key: String) {
        if let URL = URL {
            print("\(key): \(URL.absoluteString)")
        }
    }
    
    public static func logStatus(httpResponse: HTTPURLResponse) {
        let localisedStatus = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode).capitalized
        print("Status: \(httpResponse.statusCode) - \(localisedStatus)")
    }
    
    public static func logHeaders(headers: Any?) {
        if let headers = headers as? [String: AnyObject] {
            print("Headers: [")
            for (key, value) in headers {
                print("  \(key): \(value)")
            }
            print("]")
        }
    }
    
    public static func logJSON(data: Data?) {
        guard let data = data else { return }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let pretty = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            if let string = NSString(data: pretty, encoding: String.Encoding.utf8.rawValue) {
                print("JSON: \(string)")
            }
        }
        catch {
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                print("Data: \(string)")
            }
        }
    }
    
    public static func logHTTPMethod(request: URLRequest) {
        if let method = request.httpMethod {
            print("Method: \(method)")
        }
    }
    
    public static func logDivider() {
        print("-------------------------------------------------------------------------------------------------")
    }
}
