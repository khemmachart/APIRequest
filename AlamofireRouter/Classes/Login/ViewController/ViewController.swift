//
//  ViewController.swift
//  AlamofireRouter
//
//  Created by Khemmachart Chutapetch on 1/8/2560 BE.
//  Copyright © 2560 Khemmachart Chutapetch. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        login(email: "Khemmachart", password: "kh3mm4ch42t")
    }
    
    func login(email: String, password: String) {
        let router = AlamofireRouter.login(email: email, password: password)
        let _ = APIRequest.request(withRouter: router, withHandler: { (response, error) in
            print("Response msg: \(response?.message)")
            print("Error msg: \(error?.message)")
        })
        
    }
}
