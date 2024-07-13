//
//  SendFundOTPViewController.swift
//  Wind App
//
//  Created by RASHED on 7/13/24.
//

import UIKit

class SendFundOTPViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        
        
    }


}

