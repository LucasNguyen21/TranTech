//
//  PromotionViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 28/11/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import WebKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class PromotionViewController: UIViewController, WKUIDelegate, WKNavigationDelegate{
    var webView: WKWebView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        indicator.startAnimating()
        indicator.tag = 100
        
        webView.navigationDelegate = self
        getPromotionFile()
        
        let homeButton: UIBarButtonItem = UIBarButtonItem(title: "Home",style: .plain,target: self,action: #selector(homeAction))
        self.navigationItem.rightBarButtonItem = homeButton
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.isHidden = true
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
    }

    
    func homeAction(){
        navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadWebView(){
        webView = WKWebView(frame: self.view.frame)
        view.addSubview(webView)
        webView.navigationDelegate = self
    }
    
    func getPromotionFile(){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let transactionHistoryRef: StorageReference
        if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "DEFAULT" {
            transactionHistoryRef = storageRef.child("PromotionPDF/PromotionDefault.pdf")
        }else if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "TYPE1"{
            transactionHistoryRef = storageRef.child("PromotionPDF/PromotionType1.pdf")
        } else if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "TYPE2"{
            transactionHistoryRef = storageRef.child("PromotionPDF/PromotionType2.pdf")
        } else if UserDefaults.standard.value(forKey: userTypeStandard) as! String == "TYPE3"{
            transactionHistoryRef = storageRef.child("PromotionPDF/PromotionType3.pdf")
        }else {
            transactionHistoryRef = storageRef.child("PromotionPDF/PromotionDefault.pdf")
        }
        transactionHistoryRef.downloadURL { (url, error) in
            if let error = error {
                print(error)
            }else
            {
                let myRequest = URLRequest(url: url!)
                self.webView.load(myRequest)
            }
        }
    }
    
}
