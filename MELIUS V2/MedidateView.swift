import SwiftUI


struct MedidateView: View {
    @State private var meditationTasks = [
        "10-Minute Meditation",
        "Breathing Exercise",
        "Mindfulness Meditation",
        "Body Scan Meditation"
    ]
    
    @State private var tasks: [Task] = Task.loadFromDefaults()
    
    @State private var taskAddedMessage: String? = nil
    
    let resources = [
        "Calm Meditation Guide",
        "Breathing Techniques",
        "Mindfulness Practices",
        "Body Relaxation Audio"
    ]

    var body: some View {
        VStack {
            Text("Meditate")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            ScrollView {
                VStack {
                    ForEach(meditationTasks, id: \.self) { task in
                        HStack {
                            Text(task)
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                addTaskToSchedule(taskName: task)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.black)
                                    .font(.title)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 2))
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Resources")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        ForEach(resources, id: \.self) { resource in
                            HStack {
                                Image(systemName: "link.circle")
                                    .foregroundColor(.green)
                                    .font(.title)
                                Text(resource)
                            }
                            .padding()
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()
            
            if let message = taskAddedMessage {
                Text(message)
                    .foregroundColor(.green)
                    .padding(.bottom, 10)
                    .transition(.opacity)
            }

            HStack {
                Spacer()
                Button(action: {
                }) {
                    Image(systemName: "house.fill")
                        .font(.title)
                }
                Spacer()
                Button(action: {
                }) {
                    Image(systemName: "person.fill")
                        .font(.title)
                }
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .padding()
    }


    func addTaskToSchedule(taskName: String) {
        let todayDate = formattedTodayDate()
        
        if tasks.contains(where: { $0.description == taskName && $0.date == todayDate }) {
            taskAddedMessage = "Task '\(taskName)' already added!"
            scheduleMessageDisappearance()
            return
        }

        let newTask = Task(id: UUID(), date: todayDate, description: taskName, completed: nil)
        tasks.append(newTask)
        saveTasks()

        taskAddedMessage = "Task '\(taskName)' added to schedule!"
        scheduleMessageDisappearance()
    }

    func formattedTodayDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: Date())
    }

    func scheduleMessageDisappearance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                taskAddedMessage = nil
            }
        }
    }

    func saveTasks() {
        if let encodedTasks = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: "tasks")
        }
    }
}

//struct GridButton: View {
//    var title: String
//    var systemImage: String
//    var color: Color
//    
//    var body: some View {
//        VStack {
//            Image(systemName: systemImage)
//                .font(.largeTitle)
//                .padding()
//            Text(title)
//                .font(.headline)
//                .fontWeight(.bold)
//        }
//        .frame(width: 150, height: 150)
//        .background(color.opacity(0.1))
//        .cornerRadius(15)
//        .shadow(radius: 5)
//    }
//}
