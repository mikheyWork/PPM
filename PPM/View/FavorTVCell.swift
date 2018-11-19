import UIKit
import Firebase

class FavorTVCell: UITableViewCell {
    
    
    //fire
    var user: UserModel!
    var ref: DatabaseReference!
    var favor = Array<Favor>()
    var starActive = true
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var prodLbl: UILabel!
    
    @IBOutlet weak var starBut: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //fire
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserModel(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("favor")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func checkStar() {
        if appDelegate.favourites.contains(where: {$0 == prodLbl.text}) {
            //            print(cell.prodLbl.text)
            starBut.setImage(UIImage(named: "star_active"), for: .normal)
        } else {
            //            print("problam")
            starBut.setImage(UIImage(named: "star"), for: .normal)
        }
    }
    
    func checkBut() {
        if starActive == true {
            starBut.setImage(UIImage(named: "star_active"), for: .normal)
            
        } else {
            starBut.setImage(UIImage(named: "star"), for: .normal)
        }
    }
    
    
    @IBAction func starTaped(_ sender: Any) {
        
        print("cellStart taped")
        print("name is \(prodLbl.text!)")
        
        
        let name = prodLbl.text
        
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
        NotificationCenter.default.post(name: NSNotification.Name("Star"), object: nil)
    }
}
