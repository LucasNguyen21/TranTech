//
//  SirenChoiceViewController.swift
//  TranTech
//
//  Created by Nguyen Dinh Thang on 26/2/18.
//  Copyright © 2018 Nguyen Dinh Thang. All rights reserved.
//

import UIKit
protocol updateSiren {
    func updateSiren(slimQty: Double, squareQty: Double)
}

class SirenChoiceViewController: UIViewController {

    @IBOutlet weak var slimQtyLabel: UITextField!
    @IBOutlet weak var squareQtyLabel: UITextField!
    @IBOutlet weak var slimStepper: UIStepper!
    @IBOutlet weak var squareStepper: UIStepper!
    
    var totalQty: Int!
    var slimQty: Int!
    var squareQty: Int!
    var delegate: updateSiren?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false
        totalQty = slimQty
        slimQtyLabel.text = String(slimQty)
        slimStepper.value = Double(slimQty)
        squareStepper.value = 0
        slimStepper.maximumValue = Double(slimQty)
        slimStepper.minimumValue = 0
        squareStepper.maximumValue = Double(slimQty)
        squareStepper.minimumValue = 0
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
    
    @IBAction func squareStepperAction(_ sender: UIStepper) {
        slimQtyLabel.text = String(format: "%.0f", Double(totalQty) - squareStepper.value)
        squareQtyLabel.text = String(format: "%.0f", squareStepper.value)
        slimStepper.value = Double(totalQty) - squareStepper.value
    }
    @IBAction func slimStepperAction(_ sender: UIStepper) {
        slimQtyLabel.text = String(format: "%.0f", slimStepper.value)
        squareQtyLabel.text = String(format: "%.0f", Double(totalQty) - slimStepper.value)
        squareStepper.value = Double(totalQty) - slimStepper.value
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    @IBAction func saveAction(_ sender: UIButton) {
        if slimStepper.value < 0 || slimStepper.value > Double(totalQty) || squareStepper.value < 0 || squareStepper.value > Double(totalQty) {
            alertControl(title: "Wrong Input" , message: "Quantity must not be a negative number")
        }
        else {
            self.delegate?.updateSiren(slimQty: slimStepper.value, squareQty: squareStepper.value)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func alertControl(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
