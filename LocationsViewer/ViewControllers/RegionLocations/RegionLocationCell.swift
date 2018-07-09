import Foundation
import UIKit

class RegionLocationCell: UITableViewCell, TerminalCustomizationProtocol {
    // All cells on the provided design have the same height, so thats why I used 'static'
    static let cellHeight: CGFloat = 64
    
    @IBOutlet weak private var locationTitleLabel: UILabel!
    @IBOutlet weak private var locationAddressLabel: UILabel!
    @IBOutlet weak private var locationTypeLabel: UILabel!
    
    var locationTitle: String? {
        didSet {
            locationTitleLabel.text = locationTitle
        }
    }
    
    var locationAddress: String? {
        didSet {
            locationAddressLabel.text = locationAddress
        }
    }
    
    var locationType: TerminalType? {
        didSet {
            applyLocationType()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        locationTypeLabel.clipsToBounds = true
        locationTypeLabel.layer.cornerRadius = 26
        locationTypeLabel.textColor = UIColor.white
        
        locationAddressLabel.textColor = UIColor.gray
        
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        customizeWithTerminal(nil)
    }
    
    func customizeWithTerminal(_ terminal: Terminal?) {
        locationTitle = terminal?.name
        locationAddress = terminal?.address
        locationType = terminal?.getTerminalType()
    }
    
    private func applyLocationType() {
        if let t = locationType {
            locationTypeLabel.text = t.description
            switch t {
            case .Branch:
                locationTypeLabel.backgroundColor = UIColor.blue
            case .ATM:
                locationTypeLabel.backgroundColor = UIColor.orange
            case .BNA:
                locationTypeLabel.backgroundColor = UIColor.green
            }
            
        } else {
            locationTypeLabel.backgroundColor = UIColor.white
            locationTypeLabel.text = nil
        }
    }
    
}
