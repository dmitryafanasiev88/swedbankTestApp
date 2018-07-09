import Foundation
import UIKit

class LocationDetailsCell: UITableViewCell {
    static let nameLabelWidth: CGFloat = 100
    static let minimumHeight: CGFloat = 40
    static let verticalPadding: CGFloat = 20
    static let horizontalPadding: CGFloat = 32
    static let valueLabelFont = UIFont.systemFont(ofSize: 15, weight: .regular)

    @IBOutlet weak private var fieldNameLabel: UILabel!
    @IBOutlet weak private var fieldValueLabel: UILabel!
    
    var fieldName: String? {
        didSet {
            fieldNameLabel.text = fieldName
        }
    }
    
    var fieldValue: String? {
        didSet {
            fieldValueLabel.text = fieldValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        fieldName = nil
        fieldValue = nil
    }
    
}
