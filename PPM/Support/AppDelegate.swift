import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import Firebase
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var showDisc =  UserDefaults.standard.bool(forKey: "DiscAlert")
    var allCateg: [CategoryEnt] = []
    var parents: [CategoryEnt] = []
    var childs: [CategoryEnt] = []
    var favourites: [String] = []
    
    var favouritesStart: [String] = []
    var model: String!
    var subscribtion = false
    var pdfArray2 = [String]()
    
    var references = [ReferEnt]()
    var referencesParent = [ReferEnt]()
    var referencesChild = [ReferEnt]()
    var fileLocalURLDict = [String:String]()
    
    var curentPdf = [PdfDocumentInfo]()
    var networkPdf = [PdfDocumentInfo]()
    
    var curentPdfRef = [PdfDocumentInfoRef]()
    var networkPdfRef = [PdfDocumentInfoRef]()
    
    var productsDocCount: CGFloat! = 0.0
    var refsDocCount: CGFloat! = 0.0
    var allCountDoc: CGFloat! = 0.0
    var models = [CategoryEnt]()
    
    var networkProd = [String]()
    var networkRef = [String]()
    
    var closeCheckData = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DispatchQueue.global(qos: .userInteractive).async {
            if Reachability.isConnectedToNetwork() {
                self.checkSub(id: "mikhey.PPM.Genius3.Subscription", sharedSecret: "523764ba89824292bc45e96ae17f1137")
            }
        }
        self.check()
        
        //        reqPdf()
        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true
        model = UIDevice.current.modelName
        
        
        subscribtion = UserDefaults.standard.bool(forKey: "subscribe2")
        
        
        
        //test
        if UserDefaults.standard.bool(forKey: "disclaimer2") != nil {
            showDisc = UserDefaults.standard.bool(forKey: "disclaimer2")
        }
        
        if UserDefaults.standard.array(forKey: "savedPDF") != nil {
            pdfArray2 = UserDefaults.standard.array(forKey: "savedPDF") as! [String]
        }
        
        if UserDefaults.standard.dictionary(forKey: "dictinSaved") != nil {
            fileLocalURLDict = UserDefaults.standard.dictionary(forKey: "dictinSaved") as! [String : String]
        }
        
        if UserDefaults.standard.array(forKey: "favorArr") != nil {
            favourites = UserDefaults.standard.array(forKey: "favorArr") as! [String]
        } else {
            print("favor is empty")
        }
        
        if UserDefaults.standard.object(forKey: "networkPdf") != nil {
            let decoded  = UserDefaults.standard.object(forKey: "networkPdf") as! Data
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [PdfDocumentInfo]
            networkPdf = decodedTeams
        }
        if UserDefaults.standard.object(forKey: "curentPdf") != nil {
            let decoded  = UserDefaults.standard.object(forKey: "curentPdf") as! Data
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [PdfDocumentInfo]
            curentPdf = decodedTeams
        }
        if UserDefaults.standard.object(forKey: "networkPdfRef") != nil {
            let decoded2  = UserDefaults.standard.object(forKey: "networkPdfRef") as! Data
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded2) as! [PdfDocumentInfoRef]
            networkPdfRef = decodedTeams
        } else {
            print("dont workl")
        }
        
        if UserDefaults.standard.object(forKey: "curentPdfRef") != nil {
            let decoded  = UserDefaults.standard.object(forKey: "curentPdfRef") as! Data
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [PdfDocumentInfoRef]
            curentPdfRef = decodedTeams
        } else {
            print("dont workl2")
        }
        
//        delete data(core data)
//                removeDataFrom(entity: "CategoryEnt")
//        CategoryEnt
//        if need
        Thread.sleep(forTimeInterval: 1.0)
        
        
        //if need delete file
        //        removeFile(name: " ")
        
        
        return true
    }
    
    
    func removeFile(name: String) {
        //remove file
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let removeFile = dir.appendingPathComponent("\(name).pdf")
            let fileManager = FileManager.default
            do{
                try fileManager.removeItem(at: removeFile)
            }catch{
                print("cant remove file…")
            }
        }
    }
    
    func removeDataFrom(entity: String) {
        // create the delete request for the specified entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        // get reference to the persistent container
        let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        // perform the delete
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    @objc func check() {
        if Reachability.isConnectedToNetwork() == true {
            removeDataFrom(entity: "CategoryEnt")
            removeDataFrom(entity: "ReferEnt")
            filter()
            req(page: 1)
            reqRef(page: 1)
            reqProductsDocCount(page: 1)
            reqRefsDocCount(page: 1)
            filter()
        } else {
            fetchCoreData()
                        fetchCoreDataRef()
            filter()
        }
    }
    
    func reqProductsDocCount(page: Int) {
        let url = URL(string: "https://ppm.customertests.com/wp-json/wp/v2/posts?page=\(page)&per_page=100")
        guard url != nil else {
            return
        }
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { [weak self] (response) in
            
            let json = JSON(response.result.value!)
            let resaults = json[].arrayValue
            guard resaults.isEmpty == false else {
                print("page is empty")
                return
            }
            if resaults.count == 100 {
                print("page is full, page is \(page)")
                self!.reqProductsDocCount(page: page + 1)
            } else {
                print("not full page")
            }
            self?.productsDocCount += CGFloat(resaults.count)
        }
    }
    
    func reqRefsDocCount(page: Int) {
        let url = URL(string: "http://ppm.customertests.com/wp-json/wp/v2/reference?page=\(page)&per_page=100")
        guard url != nil else {
            return
        }
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { [weak self] (response) in
            
            let json = JSON(response.result.value!)
            let resaults = json[].arrayValue
            guard resaults.isEmpty == false else {
                print("page is empty")
                return
            }
            if resaults.count == 100 {
                print("page is full, page is \(page)")
                self!.reqRefsDocCount(page: page + 1)
            } else {
                print("not full page")
            }
            self?.refsDocCount += CGFloat(resaults.count)
        }
    }
    
    func reqRef(page: Int) {
        let url = URL(string: "http://ppm.customertests.com/wp-json/wp/v2/reference?page=\(page)&per_page=100")
        guard url != nil else {
            return
        }
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            let json = JSON(response.result.value!)
            let resaults = json[].arrayValue
            guard resaults.isEmpty == false else {
                print("page is empty")
                return
            }
            if resaults.count == 100 {
                print("page is full, page is \(page)")
                self.reqRef(page: page + 1)
            } else {
                print("not full page")
            }
            for resault in resaults {
                var name = resault["title"]["rendered"].stringValue
                if name.contains("&#038;") {
                    name = PDFDownloader.shared.addAmper(fromString: name)
                }
                 self.networkRef.append(name)
                let a = self.references.filter{$0.name == name}
                if a.isEmpty == false {
                    for i in a {
                        if i.parent == 0 {
                            if self.referencesParent.contains(where: {$0.name == i.name}) == false {
                                self.referencesParent.append(i)
                            }
                        } else {
                            if self.referencesChild.contains(where: {$0.name == i.name}) == false {
                                self.referencesChild.append(i)
                            }
                        }
                    }
                } else {
                   
                    self.saveRefer(name: name,
                                   id: resault["id"].intValue,
                                   parent: resault["parent"].intValue,
                                   description: resault["acf"]["description"].stringValue)
                }
            }
        }
    }
    
    @objc func req(page: Int) {
        let url = URL(string: "http://ppm.customertests.com/wp-json/wp/v2/categories?page=\(page)&per_page=100")
        guard url != nil else {
            return
        }
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            let json = JSON(response.result.value!)
            let resaults = json[].arrayValue
            guard resaults.isEmpty == false else {
                print("page is empty")
                return
            }
            if resaults.count == 100 {
                print("page is full, page is \(page)")
                self.req(page: page + 1)
            } else {
                print("not full page")
            }
            for resault in resaults {
                let name = resault["name"].stringValue
                self.networkProd.append(name)
                let a = self.allCateg.filter{$0.name == name}
                if a.isEmpty == false {
                } else {
                    
                    self.saveCategories(name: name,
                                        id: resault["id"].intValue,
                                        parent: resault["parent"].intValue)
                }
                
            }
        }
    }
    
    //MARK: -save catigories
    func saveCategories(name: String, id: Int, parent: Int) {
        
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CategoryEnt", in: context)
        let categObject = NSManagedObject(entity: entity!, insertInto: context) as! CategoryEnt
        categObject.id = Int64(id)
        categObject.parent = Int64(parent)
        categObject.name = name
        
        if context.hasChanges {
            do {
                
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        if categObject.parent == 0 {
            parents.append(categObject)
        } else {
            childs.append(categObject)
        }
    }
    
    func saveRefer(name: String, id: Int, parent: Int, description: String) {
        
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ReferEnt", in: context)
        let categObject = NSManagedObject(entity: entity!, insertInto: context) as! ReferEnt
        categObject.id = Int64(id)
        categObject.parent = Int64(parent)
        categObject.name = name
        categObject.description2 = description
        
        if context.hasChanges {
            do {
                
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        if categObject.parent == 0 {
            referencesParent.append(categObject)
        } else {
            referencesChild.append(categObject)
        }
    }
    
    func fetchCoreData() {
        let context = persistentContainer.viewContext
        let fetchReq: NSFetchRequest<CategoryEnt> = CategoryEnt.fetchRequest()
        
        do {
            allCateg = try context.fetch(fetchReq)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func filter() {
        for i in allCateg {
            if i.parent == 0 {
                parents.append(i)
            } else {
                childs.append(i)
            }
        }
    }
    
    
    func resetAllRecords(in entity : String) // entity = Your_Entity_Name
    {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
        }
    }
    
    func deleteFromCoreData(id: Int64) {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CategoryEnt> = CategoryEnt.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "id==\(id)")
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            if networkProd.contains(where: {$0 == obj.name}) == false {
                print("obj.name \(obj.name)")
                            context.delete(obj)
            }
        }
        
        do {
            try context.save() // <- remember to put this :)
        } catch {
            // Do something... fatalerror
        }
    }
    
    func deleteFromCoreDataRef(id: Int64) {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ReferEnt> = ReferEnt.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "id==\(id)")
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            if networkRef.contains(where: {$0 == obj.name}) == false {
              print("obj.name \(obj.name)")
                            context.delete(obj)
            }
        }
        
        do {
            try context.save() // <- remember to put this :)
        } catch {
            // Do something... fatalerror
        }
    }
    
    
    
    func fetchCoreDataRef() {
        let context = persistentContainer.viewContext
        let fetchReq: NSFetchRequest<ReferEnt> = ReferEnt.fetchRequest()
        
        do {
            references = try context.fetch(fetchReq)
        } catch {
            print(error.localizedDescription)
        }
        filter2()
    }
    
    func filter2() {
        for i in references {
            
            if i.parent == 0 {
                referencesParent.append(i)
            } else {
                referencesChild.append(i)
            }
        }
    }
    
    //check sub
    func checkSub(id: String, sharedSecret: String) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: id,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    self.subscribtion = true
                    DispatchQueue.main.async {
                        print("subso purchased is \(self.subscribtion)")
                        if self.closeCheckData == false {
                            NotificationCenter.default.post(name: NSNotification.Name("CheckSub"), object: nil)
                        }
                    }
                    
                    print("\(id) is valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    //релиз
                    self.subscribtion = false
                    //                    self.subscribtion = false
                    print("\(id) is expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    //релиз
                    self.subscribtion = false
                    //                    self.subscribtion = false
                    print("The user has never purchased \(id)")
                }
                
            case .error(let error):
                //релиз
                self.subscribtion = false
                //                    self.subscribtion = false
                print("Receipt verification failed: \(error)")
            }
            NotificationCenter.default.post(name: NSNotification.Name("CheckSub"), object: nil)
            print("subs is \(self.subscribtion)")
            UserDefaults.standard.set(self.subscribtion, forKey: "subscribe2")
            
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
