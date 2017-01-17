//
//  APIRequest.swift
//  AlamofireRouter
//
//  Created by Khemmachart Chutapetch on 1/8/2560 BE.
//  Copyright © 2560 Khemmachart Chutapetch. All rights reserved.
//

import Foundation
import Alamofire

public class APIRequest {
    
    public typealias completionHandler = (_ Response: BaseResponse?, _ Error: BaseResponse?) -> Void
    
    // MARK: - API Request
    
    public static func request(withRouter router: AlamofireRouter,
                               withHandler handler: @escaping completionHandler) -> Request? {
        
        return Alamofire.request(router)
            .logRequest()
            .responseJSON { response in
                
                self.logResponse(response)
                
                switch response.result {
                case .success(let data):
                    guard let json = data as? [String: Any] else { return }
                    guard let statusCode = json["statusCode"] as? String else { return }
                    if self.validate(statusCode: statusCode) {
                        self.successHandler(json, router: router, completionHandler: handler)
                    } else {
                        let error = BaseResponse(withDictionary: json)
                        self.failureHandler(error, completionHandler: handler)
                    }
                    
                case .failure(let error):
                    let error = generateErrorResponse(error)
                    self.failureHandler(error, completionHandler: handler)
                }
        }
    }
    
    // MARK: - Completion Handler
    
    static func successHandler(_ json: [String: Any]?, router: AlamofireRouter, completionHandler: APIRequest.completionHandler) {
        if let json = json {
            let instance = router.responseClass.init(withDictionary: json)
            completionHandler(instance, nil)
        }
    }
    
    static func failureHandler(_ error: BaseResponse, completionHandler: APIRequest.completionHandler) {
        /*
        if  let error = error as? MyError {
            let sessionExpire = error.resultCode == MyAISResponseResultCode.UNAUTHORIZED
            let ignoreLogout  = !UserManager.sharedInstance.isLogginOut
            if sessionExpire && ignoreLogout {
                return
            }
        }
         */
        completionHandler(nil, error)
    }
    
    // MARK: - Utils
    
    static func validate(statusCode code: String) -> Bool {
        
        let sessionExpire = "HH101"
        let successCode = "HH200"
        
        if code == sessionExpire {
            // NSNotificationCenter.defaultCenter().postNotificationName(MyAISNotificationName.UNAUTHORIZED, object: nil)
            return false
        }
        return code == successCode
    }
    
    static func generateErrorResponse(_ error: Error) -> BaseResponse {
        return BaseResponse(withDictionary: generateErrorJSON(error))
    }
    
    static func generateErrorJSON(_ error: Error) -> [String: String] {
        let statusCode = "\(error._code)"
        let message = generateErrorMessage(error)
        return [
            "statusCode": statusCode,
            "message": message
        ]
    }
    
    static func generateErrorMessage(_ error: Error) -> String {
        
        if let error = error as? AFError {
            switch error {
            case .invalidURL(let url):
                return "Invalid URL: \(url) - \(error.localizedDescription)"
            case .parameterEncodingFailed(let reason):
                return "Parameter encoding failed: \(error.localizedDescription). Failure Reason: \(reason)"
            case .multipartEncodingFailed(let reason):
                return "Multipart encoding failed: \(error.localizedDescription). Failure Reason: \(reason)"
            case .responseValidationFailed(let reason):
                let prefix = "Response validation failed: \(error.localizedDescription). Failure Reason: \(reason)"
                
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    return prefix + "Downloaded file could not be read"
                case .missingContentType(let acceptableContentTypes):
                    return prefix + "Content Type Missing: \(acceptableContentTypes)"
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    return prefix + "Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)"
                case .unacceptableStatusCode(let code):
                    return prefix + "Response status code was unacceptable: \(code)"
                }
                
            case .responseSerializationFailed(let reason):
                return "Response serialization failed: \(error.localizedDescription). Failure Reason: \(reason)"
            }
        }
        else if let error = error as? URLError {
            return "URLError occurred: \(error)"
        }
        else {
            return "Unknown error: \(error)"
        }
    }
}
