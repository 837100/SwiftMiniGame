//
//  ResultsView.swift
//  CoreDataDemo
//
//  Created by SG on 1/16/25.
//
/// NSManagedObjectContext 설명
/// NSManagedObjectContext는 CoreData에서 가장 중요한 요소 중 하나입니다:
///
/// 데이터베이스와의 상호작용을 관리하는 "작업 공간"입니다
/// 객체의 생성, 저장, 삭제 등을 추적하고 관리합니다
/// 변경사항을 메모리에서 관리하고, save()가 호출될 때 실제 저장소에 반영합니다
/// 여러 컨텍스트를 사용해 백그라운드 작업과 메인 스레드 작업을 분리할 수 있습니다
///
/// NSFetchRequest 설명
/// NSFetchRequest는 CoreData에서 데이터를 검색하기 위한 요청 객체입니다:
///
/// 어떤 엔티티에서 데이터를 가져올지 지정합니다
/// predicate를 통해 검색 조건을 설정할 수 있습니다
/// sortDescriptors로 정렬 방식을 지정할 수 있습니다
/// fetchLimit으로 가져올 데이터의 수를 제한할 수 있습니다
/// 데이터베이스 쿼리와 비슷한 역할을 하지만 객체 지향적인 방식으로 작성됩니다



//이 코드는 CoreData에서 제품을 검색하고 그 결과를 리스트로 표시하는 기능을 구현한 것입니다. 사용자가 입력한 이름을 포함하는 모든 제품을 찾아서 보여줍니다.
import SwiftUI
import CoreData


/// SwiftUI의 View 프로토콜을 따르는 검색 결과를 보여주는 뷰입니다.
struct ResultsView: View {
    
    /// name: 검색할 제품 이름
    /// viewContext: CoreData와 상호작용하기 위한 컨텍스트
    var name: String
    var viewContext: NSManagedObjectContext
    
    /// 검색된 Product 배열을 저장하는 상태 변수입니다.
    /// @State로 선언되어 값이 변경되면 뷰가 자동으로 업데이트됩니다.
    @State var matches: [Product]?
    
    var body: some View {
        VStack {
            
            /// 검색된 제품들을 리스트로 표시합니다.
            /// 각 제품의 이름과 수량을 가로로 배치합니다.
            /// ?? []는 matches가 nil일 경우 빈 배열을 사용합니다.
            List {
                ForEach(matches ?? []) { match in
                    HStack {
                        Text(match.name ?? "Not found")
                        Spacer()
                        Text(match.quantity ?? "Not found")
                    }
                }
            }
            .navigationTitle("Results")
        }
        
        /// 뷰가 나타날 때 실행되는 비동기 작업입니다.
        /// CoreData에서 데이터를 가져오는 검색 요청을 설정하고 실행합니다.
        /// predicate를 사용해 이름에 특정 문자열이 포함된 제품만 검색합니다.
        .task {
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.entity = Product.entity()
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@", name)
            
            matches = try? viewContext.fetch(fetchRequest)
        }
    }
}

//#Preview {
//    ResultsView()
//}
