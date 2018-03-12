//
//  TransactionHistoryDetailViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 12/12/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import Firebase
import WebKit

class TransactionHistoryDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var printButton: UIBarButtonItem!
    var webView: WKWebView!
    var userEmail: String!
    var recordName: String!
    var pdfURL: URL!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        printButton.isEnabled = false
        loadWebView()
        if let user = Auth.auth().currentUser {
            userEmail = user.email
       
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loadingView)
            indicator.startAnimating()
            indicator.tag = 100

            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let transactionHistoryRef = storageRef.child("TransactionHistory/\(userEmail!)/\(recordName!).pdf")
            transactionHistoryRef.downloadURL { (url, error) in
                if let error = error {
                    print(error)
                }else
                {
                    let myRequest = URLRequest(url: url!)
                    self.pdfURL = url
                    self.webView.load(myRequest)
                }
            }
            
        }
        else {
            print("Login first")
        }
    }
    
//    func downLoadPDFFile(){
//        let urlString = "https://firebasestorage.googleapis.com/v0/b/trantech-64cdc.appspot.com/o/TransactionHistory%2FTest%2F2017ChristmasSale.pdf?alt=media&token=18d6e9b4-045f-41b1-bf59-a1823fcfbf5a"
//        let downLoadURL = URL(string: urlString)
//        Alamofire.request(downLoadURL!).response {response in
//            print(response.data)
//            let request = URLRequest(url: downLoadURL!)
//            self.webView.load(request)
//        }
//    }
    
    func loadWebView(){
        //webView.uiDelegate = self
        //webView.translatesAutoresizingMaskIntoConstraints = false
        webView = WKWebView(frame: self.view.frame)
        view.addSubview(webView)
//        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        webView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
//        webView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
//        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        let myURL = URL(string: "https://iosdevcenters.blogspot.com/")
//        let myRequest = URLRequest(url: myURL!)
//        self.webView.load(myRequest)
        webView.navigationDelegate = self
    }
    
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    

    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("WebView Start loading")
    }

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView Finish navigation")
        printButton.isEnabled = true
        indicator.hidesWhenStopped = true
        loadingView.isHidden = true
        indicator.stopAnimating()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func printAction(_ sender: UIBarButtonItem) {
//        if UIPrintInteractionController.canPrint(pdfURL){
//            print("Yes")
//            let printInfo = UIPrintInfo(dictionary: nil)
//            printInfo.jobName = pdfURL.lastPathComponent
//            printInfo.outputType = .general
//
//            let printController = UIPrintInteractionController.shared
//            printController.printInfo = printInfo
//            printController.showsNumberOfCopies = true
//            printController.showsPageRange = true
//            printController.printingItem = pdfURL
//            printController.present(animated: true, completionHandler: nil)
//        }else {
//            print("No")
//        }
        let pdfFile = NSData(contentsOf: pdfURL)!
        
        let activityVC = UIActivityViewController(activityItems: [pdfFile], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }

}
