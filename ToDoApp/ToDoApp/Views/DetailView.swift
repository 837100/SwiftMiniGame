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
            Text("중요도: \(importToStrig(item.importance))")
            
            Text("할 일 상태: \(item.isToggled)")
            Text("\(item.todoId)")
        }
        Button(action: {
            updateItem()
        }, label: {
            Text("저장하기")
        })
        .border(.blue)
        
        .padding(.vertical, 4)
    }
    
    
    func importToStrig(_ importance: Int) -> String {
        switch importance {
        case 1: "중간"
        case 2: "높음"
        default: "낮음"
        }
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
