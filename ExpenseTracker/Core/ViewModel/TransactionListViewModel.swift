//
//  TransactionListViewModel.swift
//  ExpendTracker
//
//  Created by Steve Pha on 1/26/23.
//

import Foundation
import Combine
//import Collections


typealias TransactionGroup = [String: [Transaction]]
//typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]

final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        getTransactions()
    }
    
    func getTransactions() {
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching transactions: ", error.localizedDescription)
                    
                case .finished:
                    print("Finishded fetching transactions")
                }
                //weak self release memory leaks
            } receiveValue: {[weak self] results in
                self?.transactions = results
//                dump(self?.transactions)
            }
        
            .store(in: &cancellables)
    }
    
    func groupTransactionsByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:]/*return empty dictionary*/}
        let groupTransactions = TransactionGroup(grouping: transactions, by: {$0.month})
        return groupTransactions
    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        print("accumulateTransactions")
        guard !transactions.isEmpty else {return [] }
        
        let today = "02/17/2022".dateParsed() // Date() for real production
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print("dataInterval: \(dateInterval)")
        //to sum the number from all days
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24){
            let dailyExpense = transactions.filter({$0.dateParsed == date && $0.isExpense})
            let dailyTotal = dailyExpense.reduce( 0) {$0 - $1.signedAmount}
            
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            cumulativeSum.append((date.formatted(), sum))
            print(date.formatted(), "daily total: \(dailyTotal)", "sum: \(sum)")
        }
     return cumulativeSum
    }
}

