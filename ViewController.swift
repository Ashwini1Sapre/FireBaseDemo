//
//  ViewController.swift
//  FireBaseDemo
//
//  Created by Knoxpo MacBook Pro on 02/01/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
class ViewController: UIViewController {

    var ref: DatabaseReference!
    
    var bgImage: UIImageView?
    
    let image: UIImage! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      //  let ref = Database.database().reference(withPath: "grocery-items")
        ref = Database.database().reference()
        
        self.ref.child("user_id").setValue(123456)
        
        self.ref.child("user_id").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if let id = snapshot.value as? Int{
                print("value from database,\(id)")
                
            }
            
            
            
            
            
            
        })
        
    
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
       upladimageOnCloude()
        
       // downloadImageFromCloud()
        //deleteFromCloude()//
    }
    
    
    
    
 func upladimageOnCloude()
 {
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
                                    let uploadedImageURL = url?.absoluteString
        print(uploadedImageURL!)
        
        
        
        
        
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
    
    
 
    
   
    
    func downloadImageFromCloud()
    {
        
        var storageref = Storage.storage().reference()
        
        storageref = storageref.child("images/1.png")
        
        let downloadtask = storageref.getData(maxSize: 5 * 1024 * 1024 ) { data,snapshot in
            
            
                let image = UIImage(data: data!)
                print("image download successfuly \(image!)")
                
                self.bgImage = UIImageView(image: image)
                self.bgImage!.frame =  CGRect(x: 70, y: 20, width: 200, height: 200)
                
                self.view.addSubview(self.bgImage!)
            
            
               
//
//            let downloadURL = snapshot.data?.downloadUrl?.absolulateString
//
//                let dbRef = self.ref.child("myFiles/myFile")
//                  dbRef.setValue(downloadURL)
                
                
                
            
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
    
    
    func deleteFromCloude()
    {
        var storageref = Storage.storage().reference()
        
        storageref = storageref.child("images/1.png")
        
           storageref.delete { error in
            
            if let error = error {
                
                
                
            }
            else{
                
                
               print ("image deleted succesfully")
                
            }
            
            
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
        
        
        
        
        
        
    
   
    
    
}


