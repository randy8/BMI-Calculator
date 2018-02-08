//
//  ViewController.swift
//  BMI
//
//  Created by Randy Liang on 2/6/18.
//  Copyright © 2018 Randy Liang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /*
     --------------------------
     MARK: - Instance Variables
     --------------------------
     */
    // Instance variables holding the object references of the UI objects created in the storyboard
    @IBOutlet var bmiImage: UIImageView!
    @IBOutlet var bmiLabel: UILabel!
    @IBOutlet var weightSegmentedControl: UISegmentedControl!
    @IBOutlet var metersTextField: UITextField!
    @IBOutlet var inchesTextField: UITextField!
    @IBOutlet var feetTextField: UITextField!
    @IBOutlet var weightSliderLabel: UILabel!
    @IBOutlet var weightSlider: UISlider!
    
    /*
     --------------------------------------------------
     MARK: - Instance Methods Invoked by the UI Objects
     --------------------------------------------------
     */
    // This method is invoked when the user taps "done" and dimisses the keyboard after the user is finished entering a value in feetTextField
    @IBAction func feetKeyboardDone(_ sender: UITextField) {
    }
    
    // This method is invoked when the user taps "done" and dimisses the keyboard after the user is finished entering a value in inchesTextField
    @IBAction func inchesKeyboardDone(_ sender: UITextField) {
    }
    
    // This method is invoked when the user taps "done" and dimisses the keyboard after the user is finished entering a value in metersTextField
    @IBAction func metersKeyboardDone(_ sender: UITextField) {
    }
    
    // This method is invoked with the weight slider value is changed, formatting it to two decimal places
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        /*
         Slider's integer value is converted into a String value.
         The String value is assigned to be the slider's label text.
         */
        weightSliderLabel.text = String(format: "%.2f", sender.value)
    }
    
    // This method is invoked when the user taps the reset button
    @IBAction func resetTapped(_ sender: UIButton) {
        weightSliderLabel.text = "0.0"
        weightSlider.value = 0
        bmiImage.image = nil
        bmiLabel.text = nil
        metersTextField.text = nil
        inchesTextField.text = nil
        feetTextField.text = nil
        weightSegmentedControl.selectedSegmentIndex = -1
    }
    
    /*
     ----------------------------------------------
     MARK: - Helper Functions Used for Calculations
     ----------------------------------------------
     */
    
    // This function is called when a bmi is determined and passes it in to determine the user's BMI level
    private func changeStatus(bmi: Float) {
        if (bmi < 18.5) {
            bmiImage.image = UIImage(named: "Underweight")
            bmiLabel.text = "You are Underweight! BMI = " + String(format: "%.2f", bmi)
        }
        else if (bmi >= 18.5 && bmi < 25) {
            bmiImage.image = UIImage(named: "Normalweight")
            bmiLabel.text = "You are Normal weight! BMI = " + String(format: "%.2f", bmi)
        }
        else if (
            bmi >= 25 && bmi < 30) {
            bmiImage.image = UIImage(named: "Overweight")
            bmiLabel.text = "You are Overweight! BMI = " + String(format: "%.2f", bmi)
        }
        else {
            bmiImage.image = UIImage(named: "Obese")
            bmiLabel.text = "You are Obese! BMI = " + String(format: "%.2f", bmi)
        }
    }
    
    // This function is called when BMI is calculated with imperial units
    private func calculateImperialBMI (weight : Float, height : Float) -> Float {
        return Float(weight / (height * height)) * 703
    }
    
    // This function is called when BMI is calculated with imperial units
    private func calculateMetricBMI (weight : Float, height : Float) -> Float {
        return Float(weight / (height * height))
    }
    
    /*
     -----------------------------------------
     MARK: - Primary Logic Is Implemented Here
     -----------------------------------------
     */
    // This method is invoked when the user taps compute which then calculate BMI and alerts the user if input is invalid
    @IBAction func computeTapped(_ sender: UIButton) {
        // Checks to see if the weight text field input is a float which is used to validate inputs
        let weight : Float? = Float(weightSliderLabel.text!)
        // Default value of 0 is treated as a null weight
        if (weight == 0) {
            // Validation 2
            showAlertMessage(messageHeader: "Unknown Weight!",
                             messageBody: "Please select your weight by moving the slider knob to right or left!")
        }
        // When the pounds is selected from the segmented control
        else if (weightSegmentedControl.selectedSegmentIndex == 0) {
            // Checks to see if the feet and inches text field inputs are floats which is used to validate inputs
            let feetHeight : Float? = Float(feetTextField.text!)
            let inchesHeight : Float? = Float(inchesTextField.text!)
            if (feetTextField.text!.isEmpty || inchesTextField.text!.isEmpty) {
                // Validation 1
                showAlertMessage(messageHeader: "Height Value Missing!",
                                 messageBody: "Please enter your height either in feet and inches or just in meters (e.g., 1.75)!")
            }
            else if (feetHeight == nil || inchesHeight == nil) {
                // Validation 3
                showAlertMessage(messageHeader: "Unrecognized Data!",
                                 messageBody: "Please enter a valid value for Feet and Inches after selecting Pounds as the weight unit!")
            }
            else if (feetHeight! < 4.0 || feetHeight! > 7.0) {
                // Validation 4
                showAlertMessage(messageHeader: "Feet Out of Range!",
                                 messageBody: "Acceptable range of values for feet: 4.0 <= feet <= 7.0")
            }
            else if (inchesHeight! < 0.0 || inchesHeight! > 11.99) {
                // Validation 5
                showAlertMessage(messageHeader: "Inches Out of Range!",
                                 messageBody: "Acceptable range of values for inches: 0.0 <= inches <= 11.99")
            }
            else if (weight! < 50.00 || weight! > 400.00) {
                // Validation 6
                showAlertMessage(messageHeader: "Weight Out of Range!",
                                 messageBody: "Acceptable range of values for weight: 50.00 <= weight in pounds <= 400.00")
            }
            else {
                // Convert feet to inches to get totalHeight which is just total height in inches
                let totalHeight : Float = 12*feetHeight! + inchesHeight!
                let bmi = calculateImperialBMI(weight: weight!, height: totalHeight)
                // Pass in imperial BMI after the helper is done calculating
                changeStatus(bmi: bmi)
            }
        }
        // When the kilograms is selected from the segmented control
        else if (weightSegmentedControl.selectedSegmentIndex == 1) {
            // Checks to see if the meter text field input is a float which is used to validate inputs
            let metersHeight : Float? = Float(metersTextField.text!)
            if (metersTextField.text!.isEmpty) {
                // Validation 1
                showAlertMessage(messageHeader: "Height Value Missing!",
                                 messageBody: "Please enter your height either in feet and inches or just in meters (e.g., 1.75)!")
            }
            else if (metersHeight == nil) {
                // Validation 7
                showAlertMessage(messageHeader: "Unrecognized Data!",
                                 messageBody: "Please enter a valid value for Meters after selecting Kilograms as the weight unit!")
            }
            else if (metersHeight! < 1.5 || metersHeight! > 2.5) {
                // Validation 8
                showAlertMessage(messageHeader: "Meters Out of Range!",
                                 messageBody: "Acceptable range of values for meters: 1.5 <= meters <= 2.5")
            }
            else if (weight! < 23.00 || weight! > 181.00) {
                // Validation 9
                showAlertMessage(messageHeader: "Weight Out of Range!",
                                 messageBody: "Acceptable range of values for weight: 23.00 <= weight in kilograms <= 181.00")
            }
            else {
                let bmi = calculateMetricBMI(weight: weight!, height: metersHeight!)
                // Pass in metric BMI after the helper is done calculating
                changeStatus(bmi: bmi)
            }
        }
        else {
            // Validation 10
            showAlertMessage(messageHeader: "Weight Unit Missing!",
                             messageBody: "Please select a weight unit: Pounds or Kilograms!")
        }
    }
    
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertControllerStyle.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    /*
     -----------------------
     MARK: - View Life Cycle
     -----------------------
     */
    override func viewDidLoad() {
        // Initialize default values
        weightSliderLabel.text = "0.0"
        weightSlider.value = 0
        bmiImage.image = nil
        bmiLabel.text = nil
        metersTextField.text = nil
        inchesTextField.text = nil
        feetTextField.text = nil
        weightSegmentedControl.selectedSegmentIndex = -1
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
