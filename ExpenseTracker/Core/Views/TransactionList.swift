//
//  TransactionList.swift
//  ExpendTracker
//
//  Created by Steve Pha on 1/27/23.
//

import SwiftUI

struct TransactionList: View {
    @EnvironmentObject var transactionListVM : TransactionListViewModel
    var body: some View {
        VStack{
            List{
                //MARK: Transaction Group
                ForEach(Array(transactionListVM.groupTransactionsByMonth()), id: \.key) { month, transactions in
                    Section{
                        ForEach(transactions){ transaction in
                            TransactionRow(transaction: transaction)
                        }
                    } header: {
                        //MARK: Transaction Month
                         Text(month)
                    }
                    .listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }//end vstack
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TransactionList_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            NavigationView{
        TransactionList()
            }
            
        }
    }
}
