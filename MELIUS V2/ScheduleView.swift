import SwiftUI

struct ScheduleView: View {
    @State private var tasks: [Task] = Task.loadFromDefaults()
    
    @State private var streak: Int = UserDefaults.standard.integer(forKey: "streak")

    var body: some View {
        VStack {
            HStack {
                Text("Schedule")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.title)
                    Text("Streak: \(streak)")
                        .font(.title2)
                        .bold()
                }
            }
            .padding()

            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(sortedTasks()) { task in
                        HStack {
                            Text("\(task.date): \(task.description)")
                                .foregroundColor(task.completed == true ? .gray : .primary)
                                .strikethrough(task.completed == true)
                            Spacer()
                            if task.completed == nil {
                                Button(action: {
                                    markTaskComplete(task: task)
                                }) {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundColor(.green)
                                }
                                Button(action: {
                                    markTaskIncomplete(task: task)
                                }) {
                                    Image(systemName: "xmark.circle")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding()
                        .background(taskBackground(task: task))
                        .padding(.horizontal)
                    }
                }
            }
            .frame(maxHeight: .infinity)
            Spacer()
        }
        .onAppear {
            tasks = Task.loadFromDefaults()
        }
    }

    func sortedTasks() -> [Task] {
        let unmarkedTasks = tasks.filter { $0.completed == nil }
        let completedTasks = tasks.filter { $0.completed == true }
        let incompleteTasks = tasks.filter { $0.completed == false }
        
        let sortedCompletedTasks = completedTasks.sorted {
            guard let date1 = dateFormatter.date(from: $0.date),
                  let date2 = dateFormatter.date(from: $1.date) else { return false }
            return date1 > date2
        }
        
        let sortedIncompleteTasks = incompleteTasks.sorted {
            guard let date1 = dateFormatter.date(from: $0.date),
                  let date2 = dateFormatter.date(from: $1.date) else { return false }
            return date1 > date2
        }

        return unmarkedTasks + sortedCompletedTasks + sortedIncompleteTasks
    }


    func markTaskComplete(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].completed = true
            streak += 1
            saveData()
        }
    }

    func markTaskIncomplete(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].completed = false
            streak = 0
            saveData()
        }
    }


    func taskBackground(task: Task) -> Color {
        if task.completed == true {
            return Color.green.opacity(0.3)
        } else if task.completed == false {
            return Color.red.opacity(0.3)
        }
        return Color.clear
    }

    func saveData() {
        UserDefaults.standard.set(streak, forKey: "streak")

        if let encodedTasks = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: "tasks")
        }
    }


    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}


struct Task: Identifiable, Codable {
    let id: UUID
    let date: String
    let description: String
    var completed: Bool?
    
    static func loadFromDefaults() -> [Task] {
        if let savedData = UserDefaults.standard.data(forKey: "tasks"),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedData) {
            return decodedTasks
        } else {
            return [
                Task(id: UUID(), date: "5/10/24", description: "Meditate for 15 Minutes", completed: nil),
                Task(id: UUID(), date: "5/11/24", description: "Compliment someone", completed: nil),
                Task(id: UUID(), date: "5/12/24", description: "Learn to say hello in Spanish", completed: nil)
            ]
        }
    }
}

