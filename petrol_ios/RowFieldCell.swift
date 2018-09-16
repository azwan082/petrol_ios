import UIKit

class RowFieldCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var field: UITextField!
    
    var type: SettingsType = .unknown
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.field.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(vcDidAppear), name: .vcDidAppear, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveSettings), name: .saveSettings, object: nil)
    }
    
    func update(type: SettingsType) {
        self.type = type
        if type == .price {
            self.field.keyboardType = .decimalPad
        } else if type == .tankSize {
            self.field.keyboardType = .numberPad
        }
    }
    
    @objc func vcDidAppear() {
        self.field.becomeFirstResponder()
    }
    
    @objc func saveSettings() {
        if let text = self.field.text, !text.isEmpty {
            if type == .price {
                if let v = Float(text) {
                    Config.price = v
                }
            } else if type == .tankSize {
                if let v = Int(text) {
                    Config.tankSize = v
                }
            }
            NotificationCenter.default.post(name: .didSaveSettings, object: nil)
        }
    }

    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        let newText = oldText.replacingCharacters(in: r, with: string)
        do {
            let regex = try NSRegularExpression(pattern: "^([0-9]*)(\\.([0-9]{0,2})?)?$", options: .caseInsensitive)
            let matches = regex.numberOfMatches(in: newText, options: .init(rawValue: 0), range: NSRange(location: 0, length: newText.count))
            if matches == 0 {
                return false
            }
        } catch {
        }
        return true
    }
}
