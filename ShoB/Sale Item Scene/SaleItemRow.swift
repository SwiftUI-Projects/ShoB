//
//  SaleItemRow.swift
//  ShoB
//
//  Created by Dara Beng on 7/4/19.
//  Copyright © 2019 Dara Beng. All rights reserved.
//

import SwiftUI


/// A view that displays sale item in a list row.
struct SaleItemRow: View {
    
    /// The source item to view or update.
    @ObservedObject var saleItem: SaleItem
    
    /// Triggered when the update button is tapped.
    var onSave: (SaleItem) -> Void
    
    @State private var saleItemModel = SaleItemForm.Model()
    
    @State private var navigationState = NavigationStateHandler()
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationLink(destination: saleItemDetailView, isActive: $navigationState.isPushed) { // row content
            HStack {
                Text(saleItem.name)
                Spacer()
                Text(verbatim: "\(Currency(saleItem.price))")
            }
        }
    }
    
    
    // MARK: - Body Component
    
    var saleItemDetailView: some View {
        SaleItemDetailView(saleItem: saleItem, model: $saleItemModel, onSave: {
            self.onSave(self.saleItem)
        })
        .onAppear { // assign the item to the model.
            // DEVELOPER NOTE:
            // Do the assignment here for now until finding a better place for the assignment
            self.saleItemModel = .init(item: self.saleItem)
            
            // discard changes if user does not tap update button
            self.navigationState.onPopped = {
                guard self.saleItem.hasChanges, let context = self.saleItem.managedObjectContext else { return }
                context.rollback()
            }
        }
    }
}


#if DEBUG
struct SaleItemRow_Previews : PreviewProvider {
    static let cud = CUDDataSource<SaleItem>(context: CoreDataStack.current.mainContext)
    static let saleItem = SaleItem(context: cud.sourceContext)
    static var previews: some View {
        SaleItemRow(saleItem: saleItem, onSave: { _ in })
    }
}
#endif
