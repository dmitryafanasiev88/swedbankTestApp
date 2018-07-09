import Foundation
import CoreGraphics
import CoreData

class LocationsViewModel: ControllerViewModel, FooterHeaderProtocol, CellHeightProtocol {
    
    var cellHeight: CGFloat  = RegionCell.cellHeight
    var headerHeight: CGFloat = 33
    var footerHeight: CGFloat = 1
    let filesDownloader = FilesDownloader()
    var downloadCallback: (() -> (Void))?
    private var timer: Timer?
    
    override init(_ cellReuseIdentifier: String) {
        super.init(cellReuseIdentifier)
        
        self.segueId = .RegionLocationsListToLocations
        self.fetchRequest = Region.fetchRequestFromDefaultContextWithPredicate(nil,
                                                                                 sortDescriptors: [NSSortDescriptor(key: "name",
                                                                                                                ascending: true)])
        self.sectionNameKeyPath = "country"
        
        scheduleDownload()
    }
    
    @objc func download() {
        filesDownloader.downloadAndSaveAllFiles { [weak self] in
            self?.downloadCallback?()
        }
    }
    
    // Download new data every hour
    func scheduleDownload() {
        timer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(download), userInfo: nil, repeats: true)
    }
    
    // Invalidate timer
    override func prepareToDestroy() {
        timer?.invalidate()
    }
}
