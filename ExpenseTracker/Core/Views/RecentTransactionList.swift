//
//  RecentTransactionList.swift
//  ExpendTracker
//
//  Created by Steve Pha on 1/27/23.
//

import SwiftUI

struct RecentTransactionList: View {
    @EnvironmentObject var transactionListVM : TransactionListViewModel
    
    var body: some View {
        VStack{
            HStack{
                //MARK: Header Title
                Text("Recents Transactions")
                    .bold()
                
                Spacer()
                
                //MARK: Header Link
                NavigationLink {
                    TransactionList()
                } label: {
                    HStack(spacing: 4){
                        Text("See All")
                        Image(systemName: "chevron.right")
                    }//end hstack
                    .foregroundColor(Color.text)
                }

            }//end hstack
            .padding(.top)
            
            //MARK: Recent Transaction List
            ForEach(Array(transactionListVM.transactions.prefix(5).enumerated()), id:\.element){ index, transaction in
                TransactionRow(transaction: transaction)
                Divider()
                    .opacity(index == 4 ? 0 : 1)
            }
        }//end vstack
        .padding()
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct RecentTransactionList_Previews: PreviewProvider {
    static let transactionListVM : TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    
    static var previews: some View {
        RecentTransactionList()
            .environmentObject(transactionListVM)
    }
}
