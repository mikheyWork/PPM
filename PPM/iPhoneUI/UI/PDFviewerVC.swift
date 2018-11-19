import UIKit
import GTProgressBar
import Alamofire
import Firebase


class PDFviewerVC: UIViewController {
    
    
    @IBOutlet weak var starBut: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressA: GTProgressBar!
    @IBOutlet weak var subView: UIView!
    
    
    //fire
    var user: UserModel!
    var ref: DatabaseReference!
    var favor = Array<Favor>()
    
    var nameVC = " -_- 2"
    var name = " "
    var isHiden = false
    var downloadProgress: Double!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var name2 = PDFDownloader.shared.addPercent(fromString: name)
        
        if name.contains("Info") {
            name = String(name.dropLast(4))
        } else if name.contains("Alert") {
            name = String(name.dropLast(5))
        } else {
            
        }
        
    progressShow()
        checkStar()
        checkSub()
        
        read(nameFile: name2)
        
        
        //fire
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserModel(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("favor")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        progressA.progress = 0.0
    }
    
    func progressShow() {
        var progress: Float = 0.0
        self.progressA.progress = 0
        // Do the time critical stuff asynchronously
        DispatchQueue.global(qos: .background).async {
            repeat {
                progress += 0.075
                Thread.sleep(forTimeInterval: 0.25)
                DispatchQueue.main.async(flags: .barrier) {
                    
                    self.progressA.animateTo(progress: CGFloat(progress))
                }
                // time progress
            } while progress < 1.0
            DispatchQueue.main.async {
                self.subView.isHidden = true
            }
        }
    }
    

    func read(nameFile: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("\(nameFile).pdf")
            //reading
            let request = URLRequest(url: fileURL)
            self.webView.loadRequest(request)
        }
    }
    
    func checkSub() {
        if isHiden == true {
            subView.isHidden = true
        } else {
            subView.isHidden = false
        }
    }

    
    func checkStar() {
        if appDelegate.favourites.contains(where: {$0 == name}) {
            starBut.setImage(UIImage(named: "star_active"), for: .normal)
        } else {
            starBut.setImage(UIImage(named: "star"), for: .normal)
        }
    }
    
    @IBAction func backBut(_ sender: Any) {
        switch nameVC {
            
        case "VitalStatVC":
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: VitalStatVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            
        case "ReferencesVC2":
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: ReferencesVC2.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        default:
            navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func menuBut(_ sender: Any) {
        //sideMenu
    }
    
    @IBAction func starBut(_ sender: Any) {
        if self.appDelegate.curentPdf.contains(where: {$0.model_name == name}) == true || self.appDelegate.curentPdfRef.contains(where: {$0.title == name}) == true || self.appDelegate.curentPdf.contains(where: {$0.model_number == name}) == true {
            if appDelegate.favourites.contains(where: { $0 == name }) {
                appDelegate.favourites = appDelegate.favourites.filter({$0 != name})
                if appDelegate.favourites.isEmpty == true {
                    ref.removeValue()
                } else {
                    var arrayFav = [String]()
                    for fav in appDelegate.favourites {
                        arrayFav.append(fav)
                    }
                    UserDefaults.standard.set(arrayFav, forKey: "favorArr")
                    let favor = Favor(favArray: arrayFav, userId: user.uid)
                    let favorRef = self.ref.child("title")
                    favorRef.setValue(["favor": favor.favArray ,"userId": favor.userId])
                }
                
            } else {
                
                let element = appDelegate.childs.filter({$0.name == name})
                var nameElement = element.first?.name
                if nameElement == "" || nameElement == nil  {
                    let element2 = appDelegate.referencesChild.filter(({$0.name == name}))
                    nameElement = element2.first?.name
                }
                appDelegate.favourites.append(nameElement!)
                var arrayFav = [String]()
                if appDelegate.favourites.isEmpty == false {
                    for fav in appDelegate.favourites {
                        arrayFav.append(fav)
                    }
                }
                UserDefaults.standard.set(arrayFav, forKey: "favorArr")
                let favor = Favor(favArray: arrayFav, userId: user.uid)
                let favorRef = self.ref.child("title")
                favorRef.setValue(["favor": favor.favArray ,"userId": favor.userId])
            }
        }
        checkStar()
    }
    
}
