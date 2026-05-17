//
//  ViewController.swift
//  BodyCalculator
//
//
//  MARK: - Body Calculator App with Localization
//  Task 3: BMI + BMR (Harris-Benedict) + Volume Calculator (Cylinder & Cone)
//  Variant 7: Cylinder and Cone volume calculation
//  Localization: Russian, English, Belarusian
//
//  Formulas:
//  - BMI = weight / (height/100)^2
//  - BMR (Male) = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
//  - BMR (Female) = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age)
//  - Cylinder Volume = π * r² * h
//  - Cone Volume = (1/3) * π * r² * h
//
//  TODO: Add history feature to save previous calculations
//  FIXME: Handle empty text fields with proper error messages
//

import UIKit

// MARK: - Localized Strings Helper
extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

// MARK: - Main View Controller
class ViewController: UIViewController {

    // MARK: - IBOutlets (BMI & BMR Section)
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var activitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var bmiResultLabel: UILabel!
    @IBOutlet weak var bmrResultLabel: UILabel!
    @IBOutlet weak var caloriesResultLabel: UILabel!
    
    // MARK: - IBOutlets (Volume Calculator Section - Variant 7)
    @IBOutlet weak var volumeTitleLabel: UILabel!
    @IBOutlet weak var shapeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var heightVolumeTextField: UITextField!
    @IBOutlet weak var volumeResultLabel: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    // MARK: - Activity Multipliers (Harris-Benedict)
    let activityMultipliers: [Double] = [1.2, 1.375, 1.55, 1.725, 1.9]
    
    // MARK: - Activity Names for Localization
    let activityNames = [
        "sedentary",    // Little or no exercise
        "light",        // Light exercise 1-3 days/week
        "moderate",     // Moderate exercise 3-5 days/week
        "very_active",  // Hard exercise 6-7 days/week
        "extra_active"  // Very hard exercise + physical job
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        setupInitialValues()
        updateLocalizedTexts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLocalizedTexts()
    }
    
    // MARK: - Localization Setup
    private func updateLocalizedTexts() {
        // Update labels
        titleLabel.text = "app_title".localized()
        volumeTitleLabel.text = "volume_title".localized()
        
        // Update text fields placeholders
        ageTextField.placeholder = "age_placeholder".localized()
        heightTextField.placeholder = "height_placeholder".localized()
        weightTextField.placeholder = "weight_placeholder".localized()
        radiusTextField.placeholder = "radius_placeholder".localized()
        heightVolumeTextField.placeholder = "height_placeholder_volume".localized()
        
        // Update segmented controls
        sexSegmentedControl.setTitle("male".localized(), forSegmentAt: 0)
        sexSegmentedControl.setTitle("female".localized(), forSegmentAt: 1)
        
        for (index, activityName) in activityNames.enumerated() {
            if index < activitySegmentedControl.numberOfSegments {
                activitySegmentedControl.setTitle(activityName.localized(), forSegmentAt: index)
            }
        }
        
        shapeSegmentedControl.setTitle("cylinder".localized(), forSegmentAt: 0)
        shapeSegmentedControl.setTitle("cone".localized(), forSegmentAt: 1)
        
        // Update buttons
        calculateButton.setTitle("calculate_button".localized(), for: .normal)
        clearButton.setTitle("clear_button".localized(), for: .normal)
        
        // Update result labels if there are existing values
        if bmiResultLabel.text != "BMI: -" && bmiResultLabel.text != "ИМТ: -" && bmiResultLabel.text != "ІМТ: -" {
            updateAllResults()
        } else {
            resetResultLabels()
        }
    }
    
    private func resetResultLabels() {
        bmiResultLabel.text = "bmi_default".localized()
        bmrResultLabel.text = "bmr_default".localized()
        caloriesResultLabel.text = "calories_default".localized()
        volumeResultLabel.text = "volume_default".localized()
    }
    
    // MARK: - UI Setup
    private func setupTextFields() {
        ageTextField.keyboardType = .numberPad
        heightTextField.keyboardType = .decimalPad
        weightTextField.keyboardType = .decimalPad
        radiusTextField.keyboardType = .decimalPad
        heightVolumeTextField.keyboardType = .decimalPad
        
        addDoneButtonOnKeyboard(for: ageTextField)
        addDoneButtonOnKeyboard(for: heightTextField)
        addDoneButtonOnKeyboard(for: weightTextField)
        addDoneButtonOnKeyboard(for: radiusTextField)
        addDoneButtonOnKeyboard(for: heightVolumeTextField)
    }
    
    private func addDoneButtonOnKeyboard(for textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "done".localized(), style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [flexSpace, doneButton]
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupInitialValues() {
        ageTextField.text = "25"
        heightTextField.text = "175"
        weightTextField.text = "70"
        radiusTextField.text = "1"
        heightVolumeTextField.text = "2"
        
        sexSegmentedControl.selectedSegmentIndex = 0
        activitySegmentedControl.selectedSegmentIndex = 2
        shapeSegmentedControl.selectedSegmentIndex = 0
    }
    
    // MARK: - BMI Calculation
    private func calculateBMI(weight: Double, height: Double) -> Double? {
        guard height > 0 else { return nil }
        let heightInMeters = height / 100.0
        return weight / (heightInMeters * heightInMeters)
    }
    
    private func getBMICategory(bmi: Double) -> String {
        switch bmi {
        case ..<16:
            return "bmi_severe_thinness".localized()
        case 16..<17:
            return "bmi_moderate_thinness".localized()
        case 17..<18.5:
            return "bmi_mild_thinness".localized()
        case 18.5..<25:
            return "bmi_normal".localized()
        case 25..<30:
            return "bmi_overweight".localized()
        case 30..<35:
            return "bmi_obese_class1".localized()
        case 35..<40:
            return "bmi_obese_class2".localized()
        default:
            return "bmi_obese_class3".localized()
        }
    }
    
    // MARK: - BMR Calculation (Harris-Benedict)
    private func calculateBMR(weight: Double, height: Double, age: Double, isMale: Bool) -> Double {
        if isMale {
            return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
        } else {
            return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age)
        }
    }
    
    // MARK: - Daily Calories
    private func calculateDailyCalories(bmr: Double, activityIndex: Int) -> Double {
        guard activityIndex >= 0 && activityIndex < activityMultipliers.count else { return bmr }
        return bmr * activityMultipliers[activityIndex]
    }
    
    // MARK: - Volume Calculation (Variant 7)
    private func calculateVolume(radius: Double, height: Double, shape: Int) -> Double? {
        guard radius > 0, height > 0 else { return nil }
        let pi = Double.pi
        
        switch shape {
        case 0: // Cylinder
            return pi * pow(radius, 2) * height
        case 1: // Cone
            return (1.0 / 3.0) * pi * pow(radius, 2) * height
        default:
            return nil
        }
    }
    
    // MARK: - Update Results
    private func updateBodyResults() {
        guard let ageText = ageTextField.text, let age = Double(ageText),
              let heightText = heightTextField.text, let height = Double(heightText),
              let weightText = weightTextField.text, let weight = Double(weightText) else {
            bmiResultLabel.text = "bmi_error".localized()
            bmrResultLabel.text = "bmr_error".localized()
            caloriesResultLabel.text = "calories_error".localized()
            return
        }
        
        guard age > 0 && age < 120 else {
            bmiResultLabel.text = "bmi_error_age".localized()
            return
        }
        
        guard height > 0 && height < 300 else {
            bmiResultLabel.text = "bmi_error_height".localized()
            return
        }
        
        guard weight > 0 && weight < 500 else {
            bmiResultLabel.text = "bmi_error_weight".localized()
            return
        }
        
        let bmi = calculateBMI(weight: weight, height: height) ?? 0
        let bmiCategory = getBMICategory(bmi: bmi)
        
        let isMale = (sexSegmentedControl.selectedSegmentIndex == 0)
        let bmr = calculateBMR(weight: weight, height: height, age: age, isMale: isMale)
        
        let activityIndex = activitySegmentedControl.selectedSegmentIndex
        let dailyCalories = calculateDailyCalories(bmr: bmr, activityIndex: activityIndex)
        
        bmiResultLabel.text = String(format: "bmi_format".localized(), bmi, bmiCategory)
        bmrResultLabel.text = String(format: "bmr_format".localized(), bmr)
        caloriesResultLabel.text = String(format: "calories_format".localized(), dailyCalories)
    }
    
    private func updateVolumeResults() {
        guard let radiusText = radiusTextField.text, let radius = Double(radiusText),
              let heightText = heightVolumeTextField.text, let height = Double(heightText) else {
            volumeResultLabel.text = "volume_error".localized()
            return
        }
        
        guard radius > 0 else {
            volumeResultLabel.text = "volume_error_radius".localized()
            return
        }
        
        guard height > 0 else {
            volumeResultLabel.text = "volume_error_height".localized()
            return
        }
        
        let shape = shapeSegmentedControl.selectedSegmentIndex
        let shapeName = shape == 0 ? "cylinder".localized() : "cone".localized()
        let volume = calculateVolume(radius: radius, height: height, shape: shape) ?? 0
        
        volumeResultLabel.text = String(format: "volume_format".localized(), shapeName, volume)
    }
    
    private func updateAllResults() {
        updateBodyResults()
        updateVolumeResults()
    }
    
    // MARK: - IBActions
    @IBAction func calculateTapped(_ sender: UIButton) {
        dismissKeyboard()
        updateAllResults()
    }
    
    @IBAction func sexChanged(_ sender: UISegmentedControl) {
        updateBodyResults()
    }
    
    @IBAction func activityChanged(_ sender: UISegmentedControl) {
        updateBodyResults()
    }
    
    @IBAction func shapeChanged(_ sender: UISegmentedControl) {
        updateVolumeResults()
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        ageTextField.text = ""
        heightTextField.text = ""
        weightTextField.text = ""
        radiusTextField.text = ""
        heightVolumeTextField.text = ""
        
        resetResultLabels()
        
        sexSegmentedControl.selectedSegmentIndex = 0
        activitySegmentedControl.selectedSegmentIndex = 2
        shapeSegmentedControl.selectedSegmentIndex = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateAllResults()
        return true
    }
}
