import UIKit

class SettingsViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    var type: SettingsType = .unknown
    var items: [RowSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        switch self.type {
        case .price:
            self.title = "Price"
            break
        case .tankSize:
            self.title = "Tank size"
            break
        case .bars:
            self.title = "Bars"
            break
        case .unknown:
            break
        }
        self.table.dataSource = self
        self.table.delegate = self
        self.table.register(UINib(nibName: "RowFieldCell", bundle: nil), forCellReuseIdentifier: "field")
        self.table.register(Value1Cell.self, forCellReuseIdentifier: "bar")
        self.updateItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch self.type {
        case .price, .tankSize:
            NotificationCenter.default.post(name: .vcDidAppear, object: nil)
            break
        default:
            break
        }
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        if parent == nil {
            if self.type == .bars {
                NotificationCenter.default.post(name: .didSaveSettings, object: nil)
            } else {
                NotificationCenter.default.post(name: .saveSettings, object: nil)
            }
        }
    }
    
    func updateItems() {
        self.items = []
        switch self.type {
        case .price, .tankSize:
            var section = RowSection(header: nil, footer: nil, items: nil)
            var field = RowField(value: "")
            if self.type == .price {
                field.value = String(format: "%.02f", Config.price)
                section.footer = "in RM per liter"
            } else if self.type == .tankSize {
                field.value = "\(Config.tankSize)"
                section.footer = "in liter"
            }
            section.items = [field]
            self.items.append(section)
            break
        case .bars:
            self.items.append(RowSection(header: nil, footer: "number of bars inside the fuel gauge at the dashboard", items: [
                RowBar(value: 5),
                RowBar(value: 6),
                RowBar(value: 7),
                RowBar(value: 8),
                RowBar(value: 9),
                RowBar(value: 10)
            ]))
            break
        default:
            break
        }
        self.table.reloadData()
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.items[section].header
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.items[section].footer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = self.items[indexPath.section].items?[indexPath.row] {
            if let row = item as? RowField {
                let cell = tableView.dequeueReusableCell(withIdentifier: "field", for: indexPath) as! RowFieldCell
                cell.update(type: self.type)
                cell.field.text = row.value
                return cell
            } else if let row = item as? RowBar {
                let cell = tableView.dequeueReusableCell(withIdentifier: "bar", for: indexPath) as! Value1Cell
                if let v = row.value {
                    cell.textLabel?.text = "\(v)"
                    cell.accessoryType = Config.bars == v ? .checkmark : .none
                }
                return cell
            }
        }
        return UITableViewCell()
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = self.items[indexPath.section].items?[indexPath.row] {
            if let row = item as? RowBar, let v = row.value {
                Config.bars = v
                self.updateItems()
            }
        }
    }
}
