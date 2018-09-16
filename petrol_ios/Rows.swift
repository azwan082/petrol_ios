import UIKit

struct RowSection {
    var header: String?
    var footer: String?
    var items: [Any]?
}

struct RowRefill {
    var header = false
    var leftLabel: String?
    var rightLabel: String?
}

struct RowPrice {
}

struct RowTankSize {
}

struct RowBars {
}

struct RowField {
    var value: String?
}

struct RowBar {
    var value: Int?
}

class Value1Cell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
