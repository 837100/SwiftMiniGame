//
//  ContentView.swift
//  CoreDataDemo
//
//  Created by SG on 1/16/25.
//
/// 이 뷰는 제품을 추가, 삭제, 검색할 수 있는 메인 인터페이스를 제공합니다. CoreData를 사용하여 데이터를 영구적으로 저장하고, SwiftUI의 다양한 기능을 활용하여 사용자 인터페이스를 구성합니다.

import SwiftUI
import CoreData

/// 제품 이름과 수량을 저장할 상태 변수들을 선언합니다.
/// @State를 사용하여 값이 변경되면 뷰가 자동으로 업데이트되게 합니다.
struct ContentView: View {
    @State var name: String = ""
    @State var quantity: String = ""
    
    /// 환경 값으로 설정한 CoreData의 관리 컨텍스트를 환경 값으로 가져옵니다.
    @Environment(\.managedObjectContext) private var viewContext
    
    
    /// CoreData에서 모든 Product 엔티티를 가져오는 요청을 정의합니다.
    @FetchRequest(entity: Product.entity(), sortDescriptors: [] )
    
    /// FetchedResults는 요청 결과를 자동으로 업데이트하는 배열 같은 타입입니다.
    private var products: FetchedResults<Product>
    
    var body: some View {
        NavigationStack {
            VStack {
                /// 사용자가 제품 이름과 수량을 입력할 수 있는 텍스트 필드들입니다
                TextField("Product name", text: $name)
                TextField("Product quantity", text: $quantity)
                
                
                HStack {
                    /// 새 제품을 추가하는 버튼입니다.
                    Button(action: {
                        addProduct()
                    }, label: {
                        Text("Add")
                    })
                    Spacer()
                    
                    /// ResultsView로 이동하는 네비게이션 링크입니다.
                    /// 현재 입력된 이름으로 제품을 검색합니다.
                    NavigationLink(destination: ResultsView(name: name, viewContext: viewContext)){
                        Text("Find")
                    }
                    Spacer()
                    
                    /// 입력 필드를 초기화하는 버튼입니다.
                    Button(action: {
                        name = ""
                        quantity = ""
                    }, label: {
                        Text("Clear")
                    })
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                
                
                /// 저장된 모든 제품을 리스트로 표시합니다.
                List {
                    ForEach(products) { product in
                        HStack {
                            Text(product.name ?? "Not found")
                            Spacer()
                            Text(product.quantity ?? "Not found")
                        }
                    }
                    /// 각 항목은 스와이프로 삭제할 수 있습니다.
                    .onDelete(perform: deleteItems)
                    
                }
                .navigationTitle("Product Database")
            }
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
        }
    }
    
    /// 새 제품을 CoreData에 추가하는 함수입니다.
    private func addProduct() {
        /// withAnimation으로 애니메이션 효과를 추가합니다.
        withAnimation{
            let newProduct = Product(context: viewContext)
            newProduct.name = name
            newProduct.quantity = quantity
            saveContext()
        }
    }
    
    
    ///  선택된 제품들을 삭제하는 함수입니다.
    /// IndexSet을 받아서 해당 인덱스의 제품들을 삭제합니다.
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                offset in
                products[offset]
            }.forEach({
                element in
                viewContext.delete(element)})
            saveContext()
        }
    }
    /// CoreData의 변경사항을 저장하는 함수입니다.
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            
        }
    }
}

/// SwiftUI 프리뷰를 설정합니다.
/// 프리뷰용 CoreData 컨텍스트를 사용합니다.
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
