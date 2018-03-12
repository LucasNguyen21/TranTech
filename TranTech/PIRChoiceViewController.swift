//
//  PIRChoiceViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 26/2/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol updatePir {
    func updatePir(noPir: Double, quadPir: Double, tritech: Double, wireless: Double, noPirprice: Double, quadPirPrice: Double, tritechPirPrice: Double, wirelessPirPrice: Double)
}

class PIRChoiceViewController: UIViewController {
    @IBOutlet weak var totalPirLabel: UILabel!
    @IBOutlet weak var noPIRPriceLabel: UILabel!
    @IBOutlet weak var quadPriceLabel: UILabel!
    @IBOutlet weak var tritechPriceLabel: UILabel!
    @IBOutlet weak var noPIRQtyTextField: UITextField!
    @IBOutlet weak var quadQtyTextField: UITextField!
    @IBOutlet weak var tritechQtyTextField: UITextField!
    @IBOutlet weak var noPIRStepper: UIStepper!
    @IBOutlet weak var quadStepper: UIStepper!
    @IBOutlet weak var tritechStepper: UIStepper!
    @IBOutlet weak var noPirLabel: UILabel!
    @IBOutlet weak var wirelessLabel: UILabel!
    @IBOutlet weak var wirelessPriceLabel: UILabel!
    @IBOutlet weak var wirelessQtyTextField: UITextField!
    @IBOutlet weak var wirelessStepper: UIStepper!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var qtyStep: Double!
    var totalQty: Int!
    var modelName: String!
    var delegate: updatePir?
    var totalPrice: Double!
    
    var noPir2000Price: Double! = 0
    var quadPir2000Price: Double! = 0
    var triPir2000Price: Double! = 0
    
    var noPir30006000Price: Double! = 0
    var quadPir30006000Price: Double! = 0
    var triPir30006000Price: Double! = 0
    
    var stdPirWirelessPrice: Double! = 0
    var quadPirWirelessPrice: Double! = 0
    var triPirWirelessPrice: Double! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        
        view.isUserInteractionEnabled = false
        
        if let user = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let docRef = db.collection("AlarmUpgradePrice").document("AlarmUpgradePrice")
            docRef.getDocument(completion: { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    let array = snapshot!.data() as NSDictionary
                    
                    if let price = array.object(forKey: "NoPir2000") as? String {
                        self.noPir2000Price = Double(price)
                    }
                    
                    if let price = array.object(forKey: "QuadPir2000") as? String {
                        self.quadPir2000Price = Double(price)
                    }
                    
                    if let price = array.object(forKey: "TriPir2000") as? String {
                        self.triPir2000Price = Double(price)
                    }
                    
                    if let price = array.object(forKey: "NoPir30006000") as? String {
                        self.noPir30006000Price = Double(price)
                    }
                    
                    if let price = array.object(forKey: "QuadPir30006000") as? String {
                        self.quadPir30006000Price = Double(price)
                    }
                    
                    if let price = array.object(forKey: "TriPir30006000") as? String {
                        self.triPir30006000Price = Double(price)
                    }
                    
                    if let price = array.object(forKey: "StdPirWireless") as? String {
                        self.stdPirWirelessPrice = Double(price)
                    }
                    
                    if let price = array.object(forKey: "QuadPirWireless") as? String {
                        self.quadPirWirelessPrice = Double(price)
                    }
                    
                    if let price = array.object(forKey: "TriPirWireless") as? String {
                        self.triPirWirelessPrice = Double(price)
                    }
                    
                    if self.modelName == "BOSCH 2000 KIT" {
                        self.noPIRPriceLabel.text = "- $" + (-self.noPir2000Price * 2).cleanValue
                        self.quadPriceLabel.text = "+ $" + (self.quadPir2000Price * 2).cleanValue
                        self.tritechPriceLabel.text = "+ $" + (self.triPir2000Price * 2).cleanValue
                    }
                    
                    if self.modelName == "BOSCH 6000 KIT" || self.modelName == "BOSCH 3000 KIT" {
                        self.noPIRPriceLabel.text = "- $" + (-self.noPir30006000Price * 3).cleanValue
                        self.quadPriceLabel.text = "+ $" + (self.quadPir30006000Price * 3).cleanValue
                        self.tritechPriceLabel.text = "+ $" + (self.triPir30006000Price * 3).cleanValue
                    }
                    
                    if self.modelName == "BOSCH 6000 WIRELESS KIT" || self.modelName == "BOSCH 3000 WIRELESS KIT" {
                        self.wirelessPriceLabel.text = "- $" + (-self.stdPirWirelessPrice * 2).cleanValue
                        self.quadPriceLabel.text = "+ $" + (self.quadPirWirelessPrice * 2).cleanValue
                        self.tritechPriceLabel.text = "+ $" + (self.triPirWirelessPrice * 2).cleanValue
                    }
                }
                self.indicatorView.stopAnimating()
            })
            print(user.email!)
        }
        
        
        if modelName == "BOSCH 3000 WIRELESS KIT" || modelName == "BOSCH 6000 WIRELESS KIT" {
            noPirLabel.isHidden = true
            noPIRStepper.isHidden = true
            noPIRQtyTextField.isHidden = true
            noPIRPriceLabel.isHidden = true
        }
        else {
            wirelessLabel.isHidden = true
            wirelessStepper.isHidden = true
            wirelessPriceLabel.isHidden = true
            wirelessQtyTextField.isHidden = true
        }
        totalPirLabel.text = "Total PIRs: " + String(totalQty)
        
        noPIRStepper.value = 0
        noPIRStepper.minimumValue = 0
        noPIRStepper.maximumValue = Double(totalQty)
        
        quadStepper.value = 0
        quadStepper.minimumValue = 0
        quadStepper.maximumValue = Double(totalQty)
        
        tritechStepper.value = 0
        tritechStepper.minimumValue = 0
        tritechStepper.maximumValue = Double(totalQty)
        
        wirelessStepper.value = 0
        wirelessStepper.minimumValue = 0
        wirelessStepper.maximumValue = Double(totalQty)
        
        if modelName == "BOSCH 3000 KIT" || modelName == "BOSCH 6000 KIT" {
            noPIRStepper.stepValue = 3
            quadStepper.stepValue = 3
            tritechStepper.stepValue = 3
            wirelessStepper.stepValue = 3
        }
        else {
            noPIRStepper.stepValue = 2
            quadStepper.stepValue = 2
            tritechStepper.stepValue = 2
            wirelessStepper.stepValue = 2
        }
        // Do any additional setup after loading the view.
        
        view.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    @IBAction func saveAction(_ sender: UIButton) {
        if quadStepper.value + tritechStepper.value + wirelessStepper.value + noPIRStepper.value > Double(totalQty) {
            alertControl(title: "Wrong Input", message: "Total of changed pirs is greater than the total of pirs in kits")
        } else {
            ////add to Alarm list
            if self.modelName == "BOSCH 2000 KIT" {
                self.delegate?.updatePir(noPir: noPIRStepper.value, quadPir: quadStepper.value, tritech: tritechStepper.value, wireless: wirelessStepper.value, noPirprice: noPir2000Price, quadPirPrice: quadPir2000Price, tritechPirPrice: triPir2000Price, wirelessPirPrice: stdPirWirelessPrice)
            }
            
            if self.modelName == "BOSCH 6000 KIT" || self.modelName == "BOSCH 3000 KIT" {
                self.delegate?.updatePir(noPir: noPIRStepper.value, quadPir: quadStepper.value, tritech: tritechStepper.value, wireless: wirelessStepper.value, noPirprice: noPir30006000Price, quadPirPrice: quadPir30006000Price, tritechPirPrice: triPir30006000Price, wirelessPirPrice: stdPirWirelessPrice)
            }
            
            if self.modelName == "BOSCH 6000 WIRELESS KIT" || self.modelName == "BOSCH 3000 WIRELESS KIT" {
                self.delegate?.updatePir(noPir: noPIRStepper.value, quadPir: quadStepper.value, tritech: tritechStepper.value, wireless: wirelessStepper.value, noPirprice: noPir2000Price, quadPirPrice: quadPirWirelessPrice, tritechPirPrice: triPirWirelessPrice, wirelessPirPrice: stdPirWirelessPrice)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func wirelessStepperAction(_ sender: UIStepper) {
        wirelessQtyTextField.text = wirelessStepper.value.cleanValue
        updatePriceLabel()
    }
    @IBAction func noPIRStepperAction(_ sender: UIStepper) {
        noPIRQtyTextField.text = noPIRStepper.value.cleanValue
        updatePriceLabel()
    }
    @IBAction func quadPIRStepperAction(_ sender: UIStepper) {
        quadQtyTextField.text = quadStepper.value.cleanValue
        updatePriceLabel()
    }
    @IBAction func tritechStepperAction(_ sender: UIStepper) {
        tritechQtyTextField.text = tritechStepper.value.cleanValue
        updatePriceLabel()
    }
    
    func alertControl(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
           
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updatePriceLabel(){
        if modelName == "BOSCH 2000 KIT" {
            if noPIRStepper.value > 0 {
                noPIRPriceLabel.text = "- $" + (noPIRStepper.value * -noPir2000Price).cleanValue
            } else {
                noPIRPriceLabel.text = "- $" + (-noPir2000Price * 2).cleanValue
            }
            
            if quadStepper.value > 0 {
                quadPriceLabel.text = "+ $" + (quadStepper.value * quadPir2000Price).cleanValue
            } else {
                quadPriceLabel.text = "+ $" + (quadPir2000Price * 2).cleanValue
            }
            
            if tritechStepper.value > 0 {
                tritechPriceLabel.text = "+ $" + (tritechStepper.value * triPir2000Price).cleanValue
            } else {
                tritechPriceLabel.text = "+ $" + (triPir2000Price * 2).cleanValue
            }
            
        }
        
        if modelName == "BOSCH 6000 KIT" || modelName == "BOSCH 3000 KIT" {
            if noPIRStepper.value > 0 {
                noPIRPriceLabel.text = "- $" + (noPIRStepper.value * -noPir30006000Price).cleanValue
            } else {
                noPIRPriceLabel.text = "- $" + (-noPir30006000Price * 2).cleanValue
            }
            
            if quadStepper.value > 0 {
                quadPriceLabel.text = "+ $" + (quadStepper.value * quadPir30006000Price).cleanValue
            } else {
                quadPriceLabel.text = "+ $" + (quadPir30006000Price * 2).cleanValue
            }
            
            if tritechStepper.value > 0 {
                tritechPriceLabel.text = "+ $" + (tritechStepper.value * triPir30006000Price).cleanValue
            } else {
                tritechPriceLabel.text = "+ $" + (triPir30006000Price * 2).cleanValue
            }
        }
    }
}
