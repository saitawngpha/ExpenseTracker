//
//  ContentView.swift
//  ExpendTracker
//
//  Created by Steve Pha on 1/26/23.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @EnvironmentObject var transactionListVM : TransactionListViewModel
    var demoData :[Double] = [ 8, 2, 4, 6, 12, 9, 2]
    
    var body: some View {
        NavigationView{
            
            ScrollView{
                VStack(alignment: .leading, spacing: 24){
                    //MARK: Title
                    Text("Overviews")
                        .font(.title2)
                        .bold()
                    
                    //MARK: Line Chart
                    let data = transactionListVM.accumulateTransactions()
                    if !data.isEmpty {
                        let totalExpense = data.last?.1 ?? 0
                        CardView {
                            VStack(alignment: .leading){
                                ChartLabel(totalExpense.formatted(.currency(code: "USD")), type: .title, format: "$%.02f")
                                LineChart()
                            }//end vstack
                            .background(Color.systemBackground)
                        }
                        .data(data)
                        .chartStyle(ChartStyle(backgroundColor: Color.systemBackground, foregroundColor: ColorGradient(Color.icon.opacity(0.4), Color.icon)))
                        .frame(height: 300)
                    }
                    
                    
                    //MARK: Transaction List
                    RecentTransactionList()
                }//end vstack
                .padding()
                .frame(maxWidth: .infinity)
            }//end scrollview
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                //MARK: notification Icon
                ToolbarItem{
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                }
            }
        }//end nav
        .navigationViewStyle(.stack)
        .accentColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let transactionListVM : TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    
    static var previews: some View {
        Group {
            ContentView()
        }
        .environmentObject(transactionListVM)
    }
}
