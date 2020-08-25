//
//  ChatViewController.swift
//  Flash Chat iOS13
//

//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
     
    let db = Firestore.firestore()
    var messages: [Messages] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
     navigationItem.hidesBackButton = true
        title = K.appName
        tableView.dataSource = self


        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
 loadMessages()
    }
    
    
//    ...................gettingDataFromFirebase..................
    
    
    func loadMessages(){
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener() { (querySnapshot, err) in
                self.messages = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if   let document = querySnapshot?.documents{
                for doc in document {
                    let data = doc.data()
                    if   let sender  = data[(K.FStore.senderField)] as? String , let body = data[(K.FStore.bodyField)] as? String
                         {
                            
                            let newMessages = Messages(Sender: sender, Body: body)
                            self.messages.append(newMessages)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                            
                    }
                }
                }
            }
        }
        
    }
    
    
    
    
    
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
//      ............  addingDataToFirebase .................
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            
        db.collection(K.FStore.collectionName).addDocument(data: [
            K.FStore.senderField : messageSender,
            K.FStore.bodyField: messageBody,
            K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                
                if let e = error{
                    print(e.localizedDescription)
                }
                else{
                    
                    DispatchQueue.main.async {
                        
                           self.messageTextfield.text = ""
                        }

                     print("successful")
                    }
                    
                   
                    
                }
                
        
        
        
    }
    }
    
    
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
}


extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
       let message =   messages[indexPath.row]
        cell.messageLabel?.text = message.Body
        
//        messageFromCurrentUser
        
        if message.Sender == Auth.auth().currentUser?.email{
            cell.meAvatarImage.isHidden = false
            cell.youAvatarImage.isHidden =  true
            cell.MessageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            }
//        messageFromOtherUser
        else{
            cell.youAvatarImage.isHidden = false
            cell.meAvatarImage.isHidden = true
            cell.MessageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
    }
    
    
}
