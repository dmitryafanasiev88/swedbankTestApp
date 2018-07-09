import Foundation

class FilesDownloader {
    
    private var sharedCookie: String {
        get {
            let cookieDict = ["Swedbank-Embedded": "iphone-app"]
            let cookieHeader = (cookieDict.flatMap({ (key, value) -> String in
                return "\(key)=\(value)"
            }) as Array).joined(separator: ",")
            return cookieHeader
        }
    }
    
    func downloadFile(_ urlString: String, completion: @escaping ([TerminalData]?) -> (Void)) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(self.sharedCookie, forHTTPHeaderField: "cookie")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            do {
                let articlesData: [TerminalData] = try JSONDecoder().decode([TerminalData].self, from: data)
                DispatchQueue.main.async {
                    completion(articlesData)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func downloadAndSaveAllFiles(completion: @escaping () -> (Void)) {
        let countries: [Country] = [.Estonia, .Latvia, .Lithuania]
        let group = DispatchGroup()
        for country in countries {
            group.enter()
            downloadFile(country.downloadURL) { dataArray in
                guard let terminalsData = dataArray else {
                    group.leave()
                    return
                }
                AppDelegate.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
                    
                    // Create Regions set, coming from this request
                    var regions: Set<String> = Set()
                    var ids: Set<String> = Set()
                    
                    // Create Terminals
                    for terminalData in terminalsData {
                        let id = terminalData.getId()
                        let terminal = Terminal.terminalWithIdOrNewTerminalInContext(id, context: backgroundContext)
                        terminal.customizeWithData(terminalData)
                        terminal.country = country.rawValue
                        if let r = terminalData.r {
                            regions.insert(r)
                        }
                        ids.insert(id)
                    }
                    
                    print("Regions saved: \(regions.count) for \(country.rawValue)")
                    print("Terminals downloaded: \(terminalsData.count), saved: \(ids.count) for \(country.rawValue)")
                    
                    // Create Regions
                    for r in regions {
                        let region = Region.regionWithNameOrNewRegionInContext(r, context: backgroundContext)
                        region.country = country.rawValue
                    }
                    
                    do {
                        try backgroundContext.save()
                    } catch {
                        let nserror = error as NSError
                        print(nserror.userInfo)
                        fatalError("Unresolved error saving BG Context \(nserror), \(nserror.userInfo)")
                    }
                    
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
}

// Struct for serializing response
struct TerminalData: Codable {
    var n : String
    var a : String?
    var r : String?
    var t: Int?
    var lat: Double?
    var lon: Double?
    var av: String?
    var i: String?
    var ncash: Bool?
    var cs: Bool?
}

// Some instances of TerminalData, received from the server
// have similar data inside
// thats why I generate <id> to prevent saving that kind of data twice
extension TerminalData {

    func getId() -> String {
        let result = "undefined"
        guard let lat = lat, let lon = lon else {
            return result
        }
        return "\(lat);\(lon)"
    }
}

