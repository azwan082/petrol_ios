import Foundation

struct Config {
    
    static let defaultPrice = Float(2.2)
    static let defaultTankSize = 36
    static let defaultBars = 8
    
    static var price: Float {
        get {
            let pref = UserDefaults.standard
            let key = "ncp_price"
            if let _ = pref.object(forKey: key) {
                return pref.float(forKey: key)
            }
            return self.defaultPrice
        }
        set (value) {
            UserDefaults.standard.set(value, forKey: "ncp_price")
        }
    }
    
    static var tankSize: Int {
        get {
            let pref = UserDefaults.standard
            let key = "ncp_tank_size"
            if let _ = pref.object(forKey: key) {
                return pref.integer(forKey: key)
            }
            return self.defaultTankSize
        }
        set (value) {
            UserDefaults.standard.set(value, forKey: "ncp_tank_size")
        }
    }
    
    static var bars: Int {
        get {
            let pref = UserDefaults.standard
            let key = "ncp_bars"
            if let _ = pref.object(forKey: key) {
                return pref.integer(forKey: key)
            }
            return self.defaultBars
        }
        set (value) {
            UserDefaults.standard.set(value, forKey: "ncp_bars")
        }
    }
}

enum SettingsType {
    case price
    case tankSize
    case bars
    case unknown
}

extension Notification.Name {
    static let saveSettings = Notification.Name("saveSettings")
    static let didSaveSettings = Notification.Name("didSaveSettings")
    static let vcDidAppear = Notification.Name("vcDidAppear")
}
