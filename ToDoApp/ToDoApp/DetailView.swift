import SwiftUI
import SwiftData

struct DetailView: View {
    @Bindable var item: Item
    
    
    @State var todo: String
    @State var todoDetails: String
    @State var endDate: Date
    
    @Environment(\.modelContext) private var modelContext
    
    init(item: Item) {
        self.item = item
        _todo = State(initialValue: item.todo)
        _todoDetails = State(initialValue: item.todoDetails)
        _endDate = State(initialValue: item.endDate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("할 일",
                      text: $todo
            )
            .border(.secondary)
            
            TextField("상세설명",
                      text: $todoDetails,
                      axis: .vertical
            )
            .lineLimit(1...20)
            .border(.secondary)
            
            DatePicker(selection: $endDate) {
                Text("기한")
            }
            .border(.secondary)
            
            Button(action: {
                updateItem()
            }, label: {
                Text("저장하기")
            })
            .border(.blue)
            
            Text("\(item.todoId)")
        }
        .padding(.vertical, 4)
    }
    
    
    
    
    private func updateItem() {
        withAnimation {
            item.todo = todo
            item.todoDetails = todoDetails
            item.endDate = endDate
            
            do {
                try modelContext.save()
            } catch {
                print("Error saving updated item: \(error)")
            }
        }
    }
}
