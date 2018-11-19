import Foundation
import UIKit
import StoreKit
import Firebase

class IAPService: NSObject {
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private override init() { }
    static let shared = IAPService()
    
    var state: String!
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    var user: UserModel!
    
    func getProducts() {
        let products: Set = [IAPProd.autoRenewingSubs.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self as SKProductsRequestDelegate
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProd) {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return }
        
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchase() {
        print("restore purachases")
        paymentQueue.restoreCompletedTransactions()
    }
    
    
}


extension IAPService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in response.products {
            print("product.localizedTitle is \(product.localizedTitle)")
        }
    }
    
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status())
            print(transaction.payment.productIdentifier)
            
            
            
            switch transaction.transactionState {
            case .purchasing:
                state = "purchasing"
                break
            case .restored:
//                appDelegate.subscribtion = true
                state = "restored"
                print("restored free acc")
                UserDefaults.standard.set(appDelegate.subscribtion, forKey: "subscribe2")
                queue.finishTransaction(transaction)
            case .purchased:
                appDelegate.subscribtion = true
                state = "purchased"
                print("purchased free acc")
                if appDelegate.closeCheckData == false {
                NotificationCenter.default.post(name: NSNotification.Name("Check"), object: nil)
                }
                //fire
               
            default:
                state = "error"
                queue.finishTransaction(transaction)
            }
        }
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserModel(user: currentUser)
        let refSub  = Database.database().reference(withPath: "users").child((self.user.uid)).child("subscription")
        refSub.setValue(["subscription": self.appDelegate.subscribtion])
        UserDefaults.standard.set(appDelegate.subscribtion, forKey: "subscribe2")
    }
    
    
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return  "restored"
        }
    }
}
