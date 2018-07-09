import Foundation
import UIKit


class RegionHeader: UITableViewHeaderFooterView, RegionCustomizationProtocol {
    @IBOutlet weak private var titleView: UILabel!
    
    var title: String? {
        didSet {
            titleView.text = title
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        customizeWithRegion(nil)
    }
    
    func customizeWithRegion(_ region: Region?) {
        title = region?.country
    }
}
