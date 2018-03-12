//
//  TransactionHistoryViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 12/12/17.
//  Copyright © 2017 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import Firebase

class TransactionHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var transactionTableView: UITableView!
    var dateArray: [String] = [String]()
    var userEmail: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("---TRANSACTION HISTORY----")
        print(userEmail)
        getRecordInfo()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func getRecordInfo(){
        let getRecordsQueue = DispatchQueue(label: "GetRecordQueue")
        let getRecordQueueDispatchGroup = DispatchGroup()
        getRecordQueueDispatchGroup.enter()
        getRecordsQueue.async {
            self.dateArray = []
            let defaultStore = Firestore.firestore()
            defaultStore.collection("TransactionHistory").document("TransactionHistory").collection(self.userEmail).getDocuments(completion: { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        self.dateArray.append(document.documentID)
                    }
                    self.transactionTableView.reloadData()
                    getRecordQueueDispatchGroup.leave()
                }
            })
        }
        getRecordsQueue.async {
            getRecordQueueDispatchGroup.wait()
            getRecordQueueDispatchGroup.enter()
            if self.dateArray == [] {
                print("There are 0 in List --- ")
                self.AlertControl(title: "Empty", message: "Invoice List is Empty")
            }else {
                print("There are: \(self.dateArray.count) in list")
            }
            getRecordQueueDispatchGroup.leave()
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHistoryCell") as! TransactionHistoryCell
        cell.dateLabel.text = dateArray[indexPath.row]
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "TransactionDetailSegue" {
            let transactionDetailViewController: TransactionHistoryDetailViewController = segue.destination as! TransactionHistoryDetailViewController
            let indexPath =  transactionTableView.indexPathForSelectedRow
            let selectedCell = transactionTableView.cellForRow(at: indexPath!) as! TransactionHistoryCell
            transactionDetailViewController.recordName = selectedCell.dateLabel.text
        }
    }
    
    func AlertControl(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
