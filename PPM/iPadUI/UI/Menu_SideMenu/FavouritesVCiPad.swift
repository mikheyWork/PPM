import UIKit
import GTProgressBar

class FavouritesVCiPad: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var progressBar: GTProgressBar!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    //test
    var carsDictionary = [String: [String]]()
    var carSectionTitles = [String]()
    var cars = [String]()
    var state = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var name = ""
    var name2 = ""
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData ), name: NSNotification.Name("Star"), object: nil)
        
        progressView.isHidden = true
        super.viewDidLoad()
        checkState()
        for i in appDelegate.parents {
            if cars.contains(i.name!) == false {
                cars.append(i.name!)
            }
            
        }
        
        for car in cars {
            let carKey = String(car.prefix(1))
            if var carValues = carsDictionary[carKey] {
                carValues.append(car)
                carsDictionary[carKey] = carValues
            } else {
                carsDictionary[carKey] = [car]
            }
        }
        
        // 2
        carSectionTitles = [String](carsDictionary.keys)
        carSectionTitles = carSectionTitles.sorted(by: { $0 < $1 })
        rangeChar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        print("name2 \(name2)")
        if appDelegate.curentPdfRef.contains(where: {$0.title == name2}) == false {
            state = false
            checkState()
            progressView.isHidden = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.reloadData()
        checkState()
    }
    
    @objc func updateData() {
        self.tableView.reloadData()
    }
    
    //nameLbl char range
    fileprivate func rangeChar() {
        let attributedString = nameLbl.attributedText as! NSMutableAttributedString
        attributedString.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: 3.0, range: NSMakeRange(0, attributedString.length))
        nameLbl.attributedText = attributedString
    }
    
    func checkState() {
        if state == true {
            self.view.backgroundColor = UIColor.white
            imgView.image = nil
            webView.isHidden = false
        } else {
            self.view.backgroundColor = UIColor(red: 234/255, green: 34/255, blue: 37/255, alpha: 1)
            imgView.image = UIImage(named: "CEPIA Splash 5")
            webView.isHidden = true
        }
        
    }
    
    func progressShow() {
        var progress: Float = 0.0
        self.progressBar.progress = 0
        // Do the time critical stuff asynchronously
        DispatchQueue.global(qos: .background).async {
            repeat {
                progress += 0.075
                Thread.sleep(forTimeInterval: 0.25)
                DispatchQueue.main.async(flags: .barrier) {
                    
                    self.progressBar.animateTo(progress: CGFloat(progress))
                }
                // time progress
            } while progress < 1.0
            DispatchQueue.main.async {
                self.progressView.isHidden = true
            }
        }
    }
    
    @IBAction func backTo(_ sender: Any) {
        if name != "" {
            performSegue(withIdentifier: "showFSFav", sender: name)
        }
    }
    @IBAction func backBut(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func menuBut(_ sender: Any) {
        //sideMenu
    }
    
}

extension FavouritesVCiPad {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell7", for: indexPath) as! FavorTVCell
        let current = appDelegate.favourites[indexPath.row]
        cell.prodLbl.text = current
        if appDelegate.favourites.contains(where: {$0 == cell.prodLbl.text}) {
            cell.starBut.setImage(UIImage(named: "star_active"), for: .normal)
        } else {
            cell.starBut.setImage(UIImage(named: "star"), for: .normal)
        }
        
        if cell.prodLbl.text == name2 {
            cell.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var text = " "
        let cell = tableView.cellForRow(at: indexPath) as! FavorTVCell
        if cell.prodLbl.text != nil {
            text = cell.prodLbl.text!
        }
        name2 = text
        if appDelegate.childs.contains(where: {$0.name == text}) {
            performSegue(withIdentifier: "showFavourVital", sender: text)
        } else {
            name = text
            let pdfName = PDFDownloader.shared.addPercent(fromString: text)
            progressView.isHidden = false
            progressShow()
            read(nameFile: pdfName)
            state = true
            checkState()
//            tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavourVital" {
            let name = sender as! String
            let vs = segue.destination as! VitalStatVCiPad
            vs.name = name
            
            let arr = appDelegate.childs.filter({$0.name == name})
            
            vs.parentID = arr.first?.parent
        }
        if segue.identifier == "showFSFav" {
            let name = sender as! String
            let vs = segue.destination as! FavouriteFSVC
            vs.name = name
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
    
}
