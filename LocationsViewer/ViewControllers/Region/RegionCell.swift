import Foundation
import UIKit

class RegionCell: UITableViewCell, RegionCustomizationProtocol {
    // All cells on the provided design have the same height, so thats why I used 'static'
    static let cellHeight: CGFloat = 44
    
    @IBOutlet weak private var regionNameLabel: UILabel?
    
    var regionTitle: String? {
        didSet {
            regionNameLabel?.text = regionTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.customizeWithRegion(nil)
    }
    
    func customizeWithRegion(_ region: Region?) {
        regionTitle = region?.name
    }
}
