import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var backgroundSwitch: UISwitch!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Начальное состояние: фон bg2, выключатель выкл.
        backgroundSwitch.isOn = false
        updateBackground(isOn: false)
    }
    
    // MARK: - IBActions
    @IBAction func switchToggled(_ sender: UISwitch) {
        updateBackground(isOn: sender.isOn)
    }
    
    // MARK: - Private Methods
    private func updateBackground(isOn: Bool) {
        let imageName = isOn ? "bg1" : "bg2"
        let image = UIImage(named: imageName)
        view.backgroundColor = UIColor(patternImage: image!)
        statusLabel.text = "Background image: \(imageName).jpg"
    }
}
