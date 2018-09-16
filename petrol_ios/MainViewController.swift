import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    
    var items: [RowSection] = []
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Petrol"
        self.table.dataSource = self
        self.table.delegate = self
        self.table.register(Value1Cell.self, forCellReuseIdentifier: "cell")
        self.table.register(UINib(nibName: "RowRefillCell", bundle: nil), forCellReuseIdentifier: "refill")
        NotificationCenter.default.addObserver(self, selector: #selector(didSaveSettings), name: .didSaveSettings, object: nil)
        self.updateItems()
    }
    
    func updateItems() {
        self.items = []
        var refills: [Any] = []
        refills.append(RowRefill(header: true, leftLabel: "Bar left", rightLabel: "RM to fill"))
        let half = Int((Float(Config.bars) / 2.0).rounded(.up))
        for bar in 1...half {
            let volume = Float(Config.bars - bar) * (Float(Config.tankSize) / Float(Config.bars))
            let price = volume * Config.price
            refills.append(RowRefill(header: false, leftLabel: "\(bar)", rightLabel: String(format: "%.02f", price)))
        }
        self.items.append(RowSection(header: "Refills", footer: nil, items: refills))
        self.items.append(RowSection(header: "Settings", footer: nil, items: [RowPrice(), RowTankSize(), RowBars()]))
        self.table.reloadData()
    }
    
    @objc func didSaveSettings() {
        self.updateItems()
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.items[section].header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = self.items[indexPath.section].items?[indexPath.row] {
            if let row = item as? RowRefill {
                let cell = tableView.dequeueReusableCell(withIdentifier: "refill", for: indexPath) as! RowRefillCell
                cell.leftLabel.text = row.leftLabel
                cell.rightLabel.text = row.rightLabel
                cell.leftLabel.font = UIFont.systemFont(ofSize: cell.leftLabel.font.pointSize, weight: row.header ? .semibold : .regular)
                cell.rightLabel.font = UIFont.systemFont(ofSize: cell.rightLabel.font.pointSize, weight: row.header ? .semibold : .regular)
                return cell
            } else if item is RowPrice {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Value1Cell
                cell.textLabel?.text = "Price"
                cell.detailTextLabel?.text = String(format: "RM%.02f/L", Config.price)
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if item is RowTankSize {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Value1Cell
                cell.textLabel?.text = "Tank size"
                cell.detailTextLabel?.text = "\(Config.tankSize)L"
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if item is RowBars {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Value1Cell
                cell.textLabel?.text = "Bars"
                cell.detailTextLabel?.text = "\(Config.bars)"
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
        return UITableViewCell()
    }
 
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = self.items[indexPath.section].items?[indexPath.row] {
            if item is RowPrice {
                let vc = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
                vc.type = .price
                self.navigationController?.pushViewController(vc, animated: true)
            } else if item is RowTankSize {
                let vc = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
                vc.type = .tankSize
                self.navigationController?.pushViewController(vc, animated: true)
            } else if item is RowBars {
                let vc = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
                vc.type = .bars
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.table.deselectRow(at: indexPath, animated: true)
    }
}
