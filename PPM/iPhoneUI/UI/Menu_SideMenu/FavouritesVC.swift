import UIKit

class FavouritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var carsDictionary = [String: [String]]()
    var carSectionTitles = [String]()
    var cars = [String]()
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateData ), name: NSNotification.Name("Star"), object: nil)
        
        for i in appDelegate.favourites {
            if cars.contains(i) == false {
                cars.append(i)
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

        carSectionTitles = [String](carsDictionary.keys)
        carSectionTitles = carSectionTitles.sorted(by: { $0 < $1 })
        rangeChar()
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        self.tableView.reloadData()
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

    
    @IBAction func backBut(_ sender: Any) {
    navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBut(_ sender: Any) {
        //sideMenu
    }
    
    @IBAction func starTaped(_ sender: Any) {
        self.tableView.reloadData()
    }
}

extension FavouritesVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell7", for: indexPath) as! FavorTVCell
        let current = appDelegate.favourites[indexPath.row]
        cell.prodLbl.text = current
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        if appDelegate.favourites.contains(where: {$0 == cell.prodLbl.text}) {
            cell.starBut.setImage(UIImage(named: "star_active"), for: .normal)
        } else {
            cell.starBut.setImage(UIImage(named: "star"), for: .normal)
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var text = " "
        let cell = tableView.cellForRow(at: indexPath) as! FavorTVCell
        if cell.prodLbl.text != nil {
            text = cell.prodLbl.text!
        }
        
        if appDelegate.childs.contains(where: {$0.name == text }) {
           performSegue(withIdentifier: "showFavourVital", sender: text)
        } else {
            performSegue(withIdentifier: "showFavRefer", sender: text)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavourVital" {
            let name = sender as! String
            let vs = segue.destination as! VitalStatVC
            vs.name = name
            
        }
        
        if segue.identifier == "showFavRefer" {
            let name = sender as! String
            let vs = segue.destination as! PDFviewerVC
            vs.name = name
            
            
        }
    }
}
