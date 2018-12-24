//
//  PopUpViewController.swift
//  TestTaskForSoftwareStation
//
//  Created by batozhnyi on 12/18/18.
//  Copyright © 2018 batozhnyi. All rights reserved.
//

import UIKit
import WebKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var image: UIImageView!

    let noInternetImage = "noInternet"
    let noInternetLabel = "Sorry"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 20
        popUpView.clipsToBounds = true

        if Reachability.isConnectedToNetwork(){
            webViewPopUp()
        }else{
            image.image = UIImage(named: noInternetImage)
            label.text = noInternetLabel
        }
    }

    // Close popup
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true,
                completion: nil)
    }

    // Opened web view
    func webViewPopUp() {
//        label.text = receipeTitle
//        guard let url = URL(string: href) else { return }
//        let request = URLRequest(url: url)
//        webView.load(request)
    }

}
