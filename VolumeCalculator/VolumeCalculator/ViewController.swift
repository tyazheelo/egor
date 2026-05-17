//
//  ViewController.swift
//  VolumeCalculator
//
//  Author: [Твоё Имя Фамилия]
//  Group: [Твоя Группа]
//
//  MARK: - Task 5: Two-Scene App with Localization & AutoLayout
//  Variant 7: Cylinder & Cone Volume Calculator
//
//  Features:
//  - Scene 1: Input screen (radius, height, shape selection)
//  - Scene 2: Result screen with calculated volume
//  - Localization: Russian, English, Belarusian
//  - AutoLayout with StackView (adapts to portrait/landscape)
//
//  TODO: Add save history feature
//  FIXME: Fix layout for very small screens (iPhone SE)
//

import UIKit

// MARK: - String Extension for Localization
extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

// MARK: - Data Model
struct CalculationData {
    let radius: Double
    let height: Double
    let shape: Int  // 0 = cylinder, 1 = cone
}

// MARK: - Main View Controller (Manages Both Scenes)
class ViewController: UIViewController {
    
    // MARK: - Scene Properties
    private var currentScene: Scene = .input
    private var calculationData: CalculationData?
    
    // MARK: - Scene 1: Input Screen Views
    private let inputScrollView = UIScrollView()
    private let inputStackView = UIStackView()
    
    private let titleLabel = UILabel()
    private let shapeSegmentedControl = UISegmentedControl(items: ["cylinder".localized(), "cone".localized()])
    private let radiusTextField = UITextField()
    private let heightTextField = UITextField()
    private let calculateButton = UIButton(type: .system)
    private let clearButton = UIButton(type: .system)
    
    // MARK: - Scene 2: Result Screen Views
    private let resultView = UIView()
    private let resultStackView = UIStackView()
    
    private let resultShapeLabel = UILabel()
    private let resultParametersLabel = UILabel()
    private let volumeTitleLabel = UILabel()
    private let volumeValueLabel = UILabel()
    private let backButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateLocalization()
        showInputScene()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.adjustLayoutForOrientation()
        })
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupInputScene()
        setupResultScene()
    }
    
    // MARK: - Input Scene Setup
    private func setupInputScene() {
        // Setup ScrollView
        inputScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputScrollView)
        
        // Setup Main StackView
        inputStackView.axis = .vertical
        inputStackView.alignment = .fill
        inputStackView.distribution = .equalSpacing
        inputStackView.spacing = 20
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        inputScrollView.addSubview(inputStackView)
        
        // Title Label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        // Shape Segmented Control
        shapeSegmentedControl.selectedSegmentIndex = 0
        shapeSegmentedControl.addTarget(self, action: #selector(shapeChanged), for: .valueChanged)
        
        // Radius TextField
        radiusTextField.borderStyle = .roundedRect
        radiusTextField.keyboardType = .decimalPad
        radiusTextField.font = UIFont.systemFont(ofSize: 18)
        radiusTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addDoneButtonToTextField(radiusTextField)
        
        // Height TextField
        heightTextField.borderStyle = .roundedRect
        heightTextField.keyboardType = .decimalPad
        heightTextField.font = UIFont.systemFont(ofSize: 18)
        heightTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addDoneButtonToTextField(heightTextField)
        
        // Buttons Stack
        let buttonsStack = UIStackView()
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .fill
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 15
        
        calculateButton.setTitleColor(.white, for: .normal)
        calculateButton.backgroundColor = .systemBlue
        calculateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        calculateButton.layer.cornerRadius = 10
        calculateButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        calculateButton.addTarget(self, action: #selector(calculateTapped), for: .touchUpInside)
        
        clearButton.setTitleColor(.systemBlue, for: .normal)
        clearButton.backgroundColor = .systemGray6
        clearButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        clearButton.layer.cornerRadius = 10
        clearButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        buttonsStack.addArrangedSubview(calculateButton)
        buttonsStack.addArrangedSubview(clearButton)
        
        // Add all to stack
        inputStackView.addArrangedSubview(titleLabel)
        inputStackView.addArrangedSubview(shapeSegmentedControl)
        inputStackView.addArrangedSubview(radiusTextField)
        inputStackView.addArrangedSubview(heightTextField)
        inputStackView.addArrangedSubview(buttonsStack)
        
        // Add spacer at bottom
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        inputStackView.addArrangedSubview(spacer)
        
        // Set default values
        radiusTextField.text = "1"
        heightTextField.text = "2"
        
        setupConstraints()
    }
    
    // MARK: - Result Scene Setup
    private func setupResultScene() {
        resultView.translatesAutoresizingMaskIntoConstraints = false
        resultView.isHidden = true
        view.addSubview(resultView)
        
        // Result StackView
        resultStackView.axis = .vertical
        resultStackView.alignment = .center
        resultStackView.distribution = .equalSpacing
        resultStackView.spacing = 30
        resultStackView.translatesAutoresizingMaskIntoConstraints = false
        resultView.addSubview(resultStackView)
        
        // Shape Label
        resultShapeLabel.font = UIFont.boldSystemFont(ofSize: 24)
        resultShapeLabel.textAlignment = .center
        resultShapeLabel.numberOfLines = 0
        
        // Parameters Label
        resultParametersLabel.font = UIFont.systemFont(ofSize: 18)
        resultParametersLabel.textAlignment = .center
        resultParametersLabel.numberOfLines = 0
        resultParametersLabel.textColor = .secondaryLabel
        
        // Volume Title
        volumeTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        volumeTitleLabel.textAlignment = .center
        volumeTitleLabel.text = "result_volume_title".localized()
        
        // Volume Value Label
        volumeValueLabel.font = UIFont.boldSystemFont(ofSize: 48)
        volumeValueLabel.textAlignment = .center
        volumeValueLabel.numberOfLines = 0
        
        // Buttons Stack
        let buttonsStack = UIStackView()
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .fill
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 15
        
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = .systemBlue
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        backButton.layer.cornerRadius = 10
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        shareButton.setTitleColor(.systemBlue, for: .normal)
        shareButton.backgroundColor = .systemGray6
        shareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        shareButton.layer.cornerRadius = 10
        shareButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        shareButton.setTitle("result_share".localized(), for: .normal)
        
        buttonsStack.addArrangedSubview(backButton)
        buttonsStack.addArrangedSubview(shareButton)
        
        resultStackView.addArrangedSubview(resultShapeLabel)
        resultStackView.addArrangedSubview(resultParametersLabel)
        resultStackView.addArrangedSubview(volumeTitleLabel)
        resultStackView.addArrangedSubview(volumeValueLabel)
        resultStackView.addArrangedSubview(buttonsStack)
        
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        resultStackView.addArrangedSubview(spacer)
        
        setupResultConstraints()
    }
    
    // MARK: - Constraints Setup
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            inputScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            inputScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            inputStackView.topAnchor.constraint(equalTo: inputScrollView.topAnchor, constant: 20),
            inputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            inputStackView.bottomAnchor.constraint(equalTo: inputScrollView.bottomAnchor, constant: -20),
            inputStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
        
        radiusTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        heightTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shapeSegmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupResultConstraints() {
        NSLayoutConstraint.activate([
            resultView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            resultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            resultStackView.centerXAnchor.constraint(equalTo: resultView.centerXAnchor),
            resultStackView.centerYAnchor.constraint(equalTo: resultView.centerYAnchor),
            resultStackView.leadingAnchor.constraint(greaterThanOrEqualTo: resultView.leadingAnchor, constant: 20),
            resultStackView.trailingAnchor.constraint(lessThanOrEqualTo: resultView.trailingAnchor, constant: -20),
            resultStackView.widthAnchor.constraint(lessThanOrEqualTo: resultView.widthAnchor, constant: -40)
        ])
    }
    
    // MARK: - Scene Management
    private enum Scene {
        case input
        case result
    }
    
    private func showInputScene() {
        inputScrollView.isHidden = false
        resultView.isHidden = true
        currentScene = .input
        updateLocalization()
    }
    
    private func showResultScene() {
        inputScrollView.isHidden = true
        resultView.isHidden = false
        currentScene = .result
        updateLocalization()
        displayResult()
    }
    
    // MARK: - Localization
    private func updateLocalization() {
        switch currentScene {
        case .input:
            titleLabel.text = "main_title".localized()
            shapeSegmentedControl.setTitle("cylinder".localized(), forSegmentAt: 0)
            shapeSegmentedControl.setTitle("cone".localized(), forSegmentAt: 1)
            radiusTextField.placeholder = "radius_placeholder".localized()
            heightTextField.placeholder = "height_placeholder".localized()
            calculateButton.setTitle("calculate_button".localized(), for: .normal)
            clearButton.setTitle("clear_button".localized(), for: .normal)
            
        case .result:
            backButton.setTitle("back_button".localized(), for: .normal)
            volumeTitleLabel.text = "result_volume_title".localized()
            shareButton.setTitle("result_share".localized(), for: .normal)
            displayResult()
        }
        
        title = "app_name".localized()
    }
    
    // MARK: - Validation & Calculation
    private func validateInputs() -> (radius: Double, height: Double, isValid: Bool, errorMessage: String) {
        guard let radiusText = radiusTextField.text, !radiusText.isEmpty else {
            return (0, 0, false, "error_empty_radius".localized())
        }
        
        guard let heightText = heightTextField.text, !heightText.isEmpty else {
            return (0, 0, false, "error_empty_height".localized())
        }
        
        guard let radius = Double(radiusText) else {
            return (0, 0, false, "error_invalid_radius".localized())
        }
        
        guard let height = Double(heightText) else {
            return (0, 0, false, "error_invalid_height".localized())
        }
        
        guard radius > 0 else {
            return (0, 0, false, "error_radius_positive".localized())
        }
        
        guard height > 0 else {
            return (0, 0, false, "error_height_positive".localized())
        }
        
        return (radius, height, true, "")
    }
    
    private func calculateVolume(radius: Double, height: Double, shape: Int) -> Double {
        let pi = Double.pi
        
        if shape == 0 { // Cylinder
            return pi * pow(radius, 2) * height
        } else { // Cone
            return (1.0 / 3.0) * pi * pow(radius, 2) * height
        }
    }
    
    private func displayResult() {
        guard let data = calculationData else { return }
        
        let volume = calculateVolume(radius: data.radius, height: data.height, shape: data.shape)
        
        if data.shape == 0 {
            resultShapeLabel.text = "result_shape_cylinder".localized()
        } else {
            resultShapeLabel.text = "result_shape_cone".localized()
        }
        
        resultParametersLabel.text = String(
            format: "result_parameters".localized(),
            data.radius,
            data.height
        )
        
        volumeValueLabel.text = String(format: "%.3f m³", volume)
        
        // Color based on volume
        if volume > 100 {
            volumeValueLabel.textColor = .systemRed
        } else if volume > 50 {
            volumeValueLabel.textColor = .systemOrange
        } else if volume > 10 {
            volumeValueLabel.textColor = .systemGreen
        } else {
            volumeValueLabel.textColor = .systemBlue
        }
    }
    
    // MARK: - Helper Methods
    private func addDoneButtonToTextField(_ textField: UITextField) {
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
    
    @objc private func textFieldDidChange() {
        // Auto-clear error styling
        radiusTextField.backgroundColor = .systemBackground
        heightTextField.backgroundColor = .systemBackground
    }
    
    @objc private func shapeChanged() {
        // Update anything if needed
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "error_title".localized(),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default))
        present(alert, animated: true)
    }
    
    private func adjustLayoutForOrientation() {
        if UIDevice.current.orientation.isLandscape {
            inputStackView.spacing = 12
            resultStackView.spacing = 15
        } else {
            inputStackView.spacing = 20
            resultStackView.spacing = 30
        }
    }
    
    // MARK: - IBActions
    @objc private func calculateTapped() {
        dismissKeyboard()
        
        let validation = validateInputs()
        
        if !validation.isValid {
            showAlert(message: validation.errorMessage)
            return
        }
        
        calculationData = CalculationData(
            radius: validation.radius,
            height: validation.height,
            shape: shapeSegmentedControl.selectedSegmentIndex
        )
        
        showResultScene()
    }
    
    @objc private func clearTapped() {
        radiusTextField.text = ""
        heightTextField.text = ""
        shapeSegmentedControl.selectedSegmentIndex = 0
        dismissKeyboard()
    }
    
    @objc private func backTapped() {
        showInputScene()
    }
    
    @objc private func shareTapped() {
        guard let data = calculationData else { return }
        
        let volume = calculateVolume(radius: data.radius, height: data.height, shape: data.shape)
        let shapeName = data.shape == 0 ? "cylinder".localized() : "cone".localized()
        
        let shareText = String(format: "share_text".localized(), shapeName, data.radius, data.height, volume)
        
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
