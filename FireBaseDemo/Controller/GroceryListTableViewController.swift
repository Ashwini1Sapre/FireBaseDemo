//
//  GroceryListTableViewController.swift
//  FireBaseDemo
//
//  Created by Knoxpo MacBook Pro on 02/01/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
class GroceryListTableViewController: UITableViewController {

  // MARK: Constants
  let listToUsers = "ListToUsers"
    var bgImage: UIImageView?
    var uploadedImageURL : String! = nil
  
  // MARK: Properties
    let rootRef = Database.database().reference()
  var items: [GorasayItem] = []
  var user: User!
  var userCountBarButtonItem: UIBarButtonItem!
  let ref = Database.database().reference(withPath: "grocery-items")
   // let itemsRef = Database.database().reference().child("grocery-items")
   // let itemchild = itemsRef.child("milk")
    
  let usersRef = Database.database().reference(withPath: "online")
    
    
    
    
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    
    userCountBarButtonItem = UIBarButtonItem(title: "1",
                                             style: .plain,
                                             target: self,
                                             action: #selector(userCountButtonDidTouch))
    userCountBarButtonItem.tintColor = UIColor.white
    navigationItem.leftBarButtonItem = userCountBarButtonItem
   /*
    ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
      var newItems: [GorasayItem] = []
      for child in snapshot.children {
        if let snapshot = child as? DataSnapshot,
          let groceryItem = GorasayItem(snapshot: snapshot) {
          newItems.append(groceryItem)
        }
      }*/
      
        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [GorasayItem] = []
            for child in snapshot.children{
                
                if let snapshot = child as? DataSnapshot,
                   let grocryItem = GorasayItem(snapshot: snapshot)
                {
                    newItems.append(grocryItem)
                    
                }
                
            }
            
            
            
            
       
        
        
        
      self.items = newItems
      self.tableView.reloadData()
    })
    
    Auth.auth().addStateDidChangeListener { auth, user in
      guard let user = user else { return }
      self.user = User(authData: user)
      
      let currentUserRef = self.usersRef.child(self.user.uid)
      currentUserRef.setValue(self.user.email)
      currentUserRef.onDisconnectRemoveValue()
    }
    
    
    
    
usersRef.observe(.value, with: { snapshot in
      if snapshot.exists() {
        self.userCountBarButtonItem?.title = snapshot.childrenCount.description
      } else {
        self.userCountBarButtonItem?.title = "0"
      }
    })
    
    
   
   
    
   
    
    
    
  }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.upladimageOnCloude()
        
    }
  
  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let groceryItem = items[indexPath.row]
    
    cell.textLabel?.text = groceryItem.name
    cell.detailTextLabel?.text = groceryItem.addByUser
   // cell.imageView?.image =
    
    upladimageOnCloude()
    let storageref = Storage.storage().reference().child("images/1.png")
        storageref.downloadURL { (imgurl, er) in
            let imagedata = try? Data.init(contentsOf: imgurl!)
            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)!/2
            cell.imageView?.image = UIImage.init(data: imagedata!)
        }
        
        
        
    toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
    
    return cell
    
  
    
    
    
    
    
    
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let groceryItem = items[indexPath.row]
      groceryItem.ref?.removeValue()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    let groceryItem = items[indexPath.row]
    let toggledCompletion = !groceryItem.completed
    toggleCellCheckbox(cell, isCompleted: toggledCompletion)
    performSegue(withIdentifier: listToUsers, sender: nil)
    groceryItem.ref?.updateChildValues([
      "completed": toggledCompletion
      ])
    
  }
  
  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
    if !isCompleted {
      cell.accessoryType = .none
      cell.textLabel?.textColor = .black
      cell.detailTextLabel?.textColor = .black
        
     
        
    } else {
   
        cell.accessoryType = .checkmark
        cell.textLabel?.textColor = .gray
        cell.detailTextLabel?.textColor = .red
    }
    
    
    
    
    
  }
  
    
    
    
    
    
  // MARK: Add Item
  @IBAction func addButtonDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Grocery Item",
                                  message: "Add an Item",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
      guard let textField = alert.textFields?.first,
        let text = textField.text else { return }
      
        
        print(self.user.email)
        
        //self.upladimageOnCloude()//

      let groceryItem = GorasayItem(name: text,
                                    addByUser: self.user.email,
                                    completed: false, imageurl: self.uploadedImageURL)

      let groceryItemRef = self.ref.child(text.lowercased())
      
      groceryItemRef.setValue(groceryItem.toAnyObject())
        
        
        
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel)
    
    alert.addTextField()
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
    
 
        
        
        
        
        
        
  
    
      
    
  }
    
    func upladimageOnCloude() {
    
        
        
         
        
        var storageref = Storage.storage().reference()
        
        
      if  let image = UIImage(named: "1.png"){
            
        let data = image.pngData()
        print("data \(String(describing: data)))")
        
        
        let metadata = StorageMetadata()
        
        metadata.contentType = "images/png"
        storageref = storageref.child("images/1.png")
        let uploadTask = storageref.putData(data!, metadata: metadata)
        
        //let urrl = metadata?.downloadURL()?.absoluteString!
        
        
        
        //get downloadurl of image which upload in firebase
        storageref.downloadURL(completion: { (url, error) in
            self.uploadedImageURL = url?.absoluteString
            print(self.uploadedImageURL!)
            
            
            self.tableView.reloadData()
            
            
        })
                                
                                // Get the image url and assign to photoUrl for the current user and update
        
        
        
        
       
        
        uploadTask.observe(.resume) { snapshot in
        }
        uploadTask.observe(.pause) { snapshot in
            
            
        }
        uploadTask.observe(.progress) { snapshot in
            let  precentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            
            print("uplad percentage = \(precentComplete)")
            
            uploadTask.observe(.success) { snapshot in
                
                print("image upladed sucessfully")
          
                
                
                
            }
            uploadTask.observe(.failure) { snapshot in
                
                
                if  let  error = snapshot.error as NSError? {
                    
                    switch(StorageErrorCode(rawValue: error.code))
                    {
                    
                    case .unauthorized:
                        break
                    
                    case .invalidArgument:
                        break
                        
                    case .unknown:
                        break
                    
                    case .cancelled:
                        break
                        
                    default:
                        break
                        
                    
                    
                    }
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
                
            }
            
            
            
            
            
        }
        
            
            
            
            
            
        }
        
        
        
        
        
        
        
    }
    
    
  
    func downloadimageFromcloude()
    {
        var storageref = Storage.storage().reference()
        storageref = storageref.child("images/1.png")
        
        let downloadtask = storageref.getData(maxSize: 5 * 1024 * 1024) { data, snapshot in
            
          let image = UIImage(data: data!)
            
            
            self.bgImage = UIImageView(image: image)
            self.bgImage!.frame =  CGRect(x: 70, y: 20, width: 200, height: 200)
            
            self.view.addSubview(self.bgImage!)
            
            
            
            
        }
        downloadtask.observe(.resume) { snapshot in
            
            
            
        }
        
        downloadtask.observe(.pause) { snapshot in
            
            
            
        }
        
    downloadtask.observe(.progress) { snapshot in
        
        
        let percentcompleted = 100 * Double(snapshot.progress!.completedUnitCount) /
            Double(snapshot.progress!.totalUnitCount)
        
        print("persent completed \(percentcompleted)")
        
        
        
    }

    downloadtask.observe(.success) { snapshot in
        
        print("downoad successfuly")
        
        
    }
        
    downloadtask.observe(.failure) { snapshot in
        
        if let error = snapshot.error as NSError?{
            
            switch (StorageErrorCode(rawValue: error.code)) {
            case .unknown:
                break;
                
                
            case .unauthorized:
                break;
                
            case .cancelled:
                break;
            
            
                
            default:
                break;
            }
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
        
        
        
        
    }
    
    
    
    
    func deleteTask()
    {
        
        var storageRef = Storage.storage().reference()
        storageRef = storageRef.child("images/1.png")
        
        storageRef.delete { error in
            if let error = error{
                
                print("error is \(error)")
                
            }
            else{
                
                print("delete image successfuly")
            }
            
            
            
            
        }
        
        
        
        
    }
    
    
    
  @objc func userCountButtonDidTouch() {
    performSegue(withIdentifier: listToUsers, sender: nil)
  }
}
