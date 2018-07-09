import Foundation
import CoreGraphics

class RegionLocationsViewModel: ControllerViewModel, CellHeightProtocol, FooterHeaderProtocol {
    
    var cellHeight: CGFloat = RegionLocationCell.cellHeight
    var headerHeight: CGFloat = 1.0
    var footerHeight: CGFloat = 1.0
    
    var region: Region? {
        didSet {
            prepareFetchRequest()
        }
    }
    
    override init(_ cellReuseIdentifier: String) {
        super.init(cellReuseIdentifier)
        
        segueId = .RegionLocationsToLocationDetails
        
        prepareFetchRequest()
    }
    
    private func prepareFetchRequest() {
        let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        var predicate: NSPredicate?
        if let region = self.region {
            let predicate1 = NSPredicate(format: "region == '\(region.name)'")
            let predicate2 = NSPredicate(format: "country == '\(region.country)'")
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        }
        self.fetchRequest = Terminal.fetchRequestFromDefaultContextWithPredicate(predicate, sortDescriptors: sortDescriptors)
    }
    
}
