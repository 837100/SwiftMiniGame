import SwiftUI
import SwiftData


struct ContentView: View {
    
    @State var todo: String = ""
    @State var endDate: Date = Date()
    @State var todoDetails: String = ""
    @State var importance: Int = 0
    
    let options = ["낮음", "중간", "높음"]
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        

        NavigationStack {
          
            VStack {
                Spacer()

                TextField("오늘의 할 일을 적어주세요", text: $todo)
                    .border(.secondary)
                
                TextField("상세 설명을 적어주세요", text: $todoDetails)
                    .border(.secondary)
    
                DatePicker(selection: $endDate) {
                    Text("기한은 언제까지인가요?")
                }
                .border(.secondary)
                
                HStack {
                    Text("중요도를 선택해주세요 : \(options[importance])")
                    Picker("중요도", selection: $importance) {
                        ForEach(0..<options.count, id: \.self) { index in
                            Text(options[index]).tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .onChange(of: importance, initial: false) {
                        importance = importance
                    }
                }
                .border(.secondary)
                
                HStack {
                    
                    Button(action: {
                        todo = ""
                        todoDetails = ""
                    }, label: {
                        Text("지우기")
                    })
                    .border(.blue)
                    
                    Spacer()
                    NavigationLink  {
                        SearchView(
                            todo: todo,
                            endDate: endDate,
                            importance: importance
                        )
                    } label: {
                        Text("검색")
                    }
                    .border(.blue)
                    Spacer()
                    Button(action: {
                        addItem()
                    }, label: {
                        Text("할 일 추가")
                    })
                    .border(.blue)
           
                } // end of HStack
                
                
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            DetailView(item: item)
                            
                        } label: {
                            HStack {
                                Toggle("", isOn: Binding(
                                    get: {item.isToggled},
                                    set: { newValue in
                                        withAnimation {
                                            item.isToggled = newValue
                                        }
                                    }
                                ))
                                    .labelsHidden()
                                Text(item.todo)
                                 
                                Spacer()
                                Text(dateFormatString(date: item.endDate))
                                Text("\(item.todoId)")
                            }
                            .foregroundStyle(item.isToggled ? .gray : .black)
                        }
                    }
                    .onDelete(perform: deleteItems)
                    
                } // end of List
                
            } // end of VStack
            .navigationTitle("할 일 리스트")
        } // end of NavigationStack

    } // end of body view
    
    		
    
   
    private func addItem() {
        withAnimation {
            let newItem = Item(todo: todo, endDate: endDate, todoId: UUID(), todoDetails: todoDetails, importance: importance)
            modelContext.insert(newItem)
        }
    } // end of addItem
    
    

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    } // end of deleteItems
    
    
    
    func dateFormatString(date: Date?) -> String {
        guard let date = date else { return "날짜 없음"}
        let formatter = DateFormatter()
        formatter.dateFormat = "HH월 dd일 HH:mm 까지"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    

   

} // end of ContentView




#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
