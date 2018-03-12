//
//  KeypadChoiceViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 26/2/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol updateKeypad {
    func updateKeypad(alphaQty: Double, fiveTQty: Double, sevenTQty: Double, alphaPrice: Double, fiveTPrice: Double, sevenTPrice: Double)
}

class KeypadChoiceViewController: UIViewController {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var totalKeypadLabel: UILabel!
    @IBOutlet weak var alphaPriceLabel: UILabel!
    @IBOutlet weak var alphaQtyLabel: UITextField!
    @IBOutlet weak var alphaStepper: UIStepper!
    @IBOutlet weak var fiveTPriceLabel: UILabel!
    @IBOutlet weak var fiveTQtyLabel: UITextField!
    @IBOutlet weak var fiveTStepper: UIStepper!
    @IBOutlet weak var sevenTPriceLabel: UILabel!
    @IBOutlet weak var sevenTQtyLabel: UITextField!
    @IBOutlet weak var sevenTStepper: UIStepper!
    
    var fiveTPrice: Double!
    var seventTPrice: Double!
    var alphaPrice: Double!
    var totalKeypad: Int!
    var delegate: updateKeypad?
    
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
                    if let price = array.object(forKey: "5Touch") as? String{
                        self.fiveTPrice = Double(price)
                        self.fiveTPriceLabel.text = "+ $" + (Double(price)!).cleanValue
                    }
                    if let price = array.object(forKey: "7Touch") as? String{
                        self.seventTPrice = Double(price)
                        self.sevenTPriceLabel.text = "+ $" + (Double(price)!).cleanValue
                    }
                    
                    if let price = array.object(forKey: "Alpha") as? String {
                        self.alphaPrice = Double(price)
                        self.alphaPriceLabel.text = "+ $" + (Double(price)!).cleanValue
                    }
                    self.indicatorView.stopAnimating()
                }
            })
            print(user.email!)
        }
        
        totalKeypadLabel.text = "Total Keypad: \(totalKeypad!)"
        
        alphaStepper.stepValue = 1
        alphaStepper.minimumValue = 0
        alphaStepper.maximumValue = Double(totalKeypad)
        
        fiveTStepper.stepValue = 1
        fiveTStepper.minimumValue = 0
        fiveTStepper.maximumValue = Double(totalKeypad)
        
        sevenTStepper.stepValue = 1
        sevenTStepper.minimumValue = 0
        sevenTStepper.maximumValue = Double(totalKeypad)
        
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
        if alphaStepper.value + fiveTStepper.value + sevenTStepper.value > Double(totalKeypad) {
            alertControl(title: "Wrong Input", message: "Total of change keypad is greater than total of keypad included in Kit")
        } else {
            /////Save to alarm kit
            self.delegate?.updateKeypad(alphaQty: alphaStepper.value, fiveTQty: fiveTStepper.value, sevenTQty: sevenTStepper.value, alphaPrice: alphaPrice, fiveTPrice: fiveTPrice, sevenTPrice: seventTPrice)
            dismiss(animated: true, completion: nil)
        }
        
    }
    @IBAction func alphaStepperAction(_ sender: UIStepper) {
        alphaQtyLabel.text = alphaStepper.value.cleanValue
        if alphaStepper.value > 0 {
            alphaPriceLabel.text = "+ $" + (alphaStepper.value * alphaPrice).cleanValue
        } else {
            alphaPriceLabel.text = "+ $" + alphaPrice.cleanValue
        }
        
    }
    @IBAction func fiveTStepperAction(_ sender: UIStepper) {
        fiveTQtyLabel.text = fiveTStepper.value.cleanValue
        if fiveTStepper.value > 0 {
            fiveTPriceLabel.text = "+ $" + (fiveTStepper.value * fiveTPrice).cleanValue
        } else {
            fiveTPriceLabel.text = "+ $" + fiveTPrice.cleanValue
        }
    }
    @IBAction func sevenTStepperAction(_ sender: UIStepper) {
        sevenTQtyLabel.text = sevenTStepper.value.cleanValue
        if sevenTStepper.value > 0 {
            sevenTPriceLabel.text = "+ $" + (sevenTStepper.value * seventTPrice).cleanValue
        } else {
            sevenTPriceLabel.text = "+ $" + seventTPrice.cleanValue
        }
    }
    func alertControl(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
