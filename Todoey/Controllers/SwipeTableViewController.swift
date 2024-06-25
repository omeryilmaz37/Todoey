//
//  SwipeTableViewController.swift
//
//  Todoey
//
//  Created by Ömer Yılmaz on 5.06.2024.
//

import UIKit
import SwipeCellKit

// SwipeTableViewController, table view controller'dan miras alır ve SwipeTableViewCellDelegate protokolünü uygular.
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0 // Tablo satırlarının yüksekliğini ayarlar.
    }
    
    // TableView Datasource Methods
    
    // Tablo hücrelerini oluşturur. Hücreleri yeniden kullanılabilir hale getirir ve SwipeTableViewCell olarak tür dönüştürür, ardından hücreye delegasyon görevini atar
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Yeniden kullanılabilir bir hücre alır ve SwipeTableViewCell olarak tür dönüştürür.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self // Hücreye delegasyon görevini atar.
        
        return cell // Hücreyi döndürür.
    }
    
    // Hücrede sağa kaydırma işlemi için düzenleme aksiyonlarını tanımlar.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil } // Sadece sağa kaydırma için aksiyon döndürür.
        
        // Silme aksiyonunu oluşturur.
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath) // Modeli günceller.
            
        }
        deleteAction.image = UIImage(named: "delete-icon") // Silme ikonu ekler.
        return [deleteAction] // Silme aksiyonunu döndürür.
    }
    
    // Kaydırma aksiyonlarının seçeneklerini ayarlar. Genişleme stilini yıkıcı olarak belirler.
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions() // Swipe seçeneklerini oluşturur.
        options.expansionStyle = .destructive // Genişleme stilini yıkıcı olarak ayarlar.
        
        return options // Seçenekleri döndürür.
    }
    
    // Modeli güncellemek için bir placeholder fonksiyon. Alt sınıflar tarafından geçersiz kılınacak.
    func updateModel(at indexPath: IndexPath) {
    }
}
