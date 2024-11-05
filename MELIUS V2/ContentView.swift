import SwiftUI

struct MainView: View {
    @State private var quote: String = ""

    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    Button(action: {
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .padding(.leading, 10)
                    }
                    Spacer()
                    
                    Text("MELius")
                        .font(.largeTitle)
                        .bold()

                    Spacer()
                    Image(systemName: "person.circle")
                        .font(.title)
                        .padding(.trailing, 10)
                }
                .padding(.top, 20)
                
                Spacer()
                
                Text(quote)
                    .onAppear(perform: fetchQuote)
                    .font(.subheadline)
                    .padding(.bottom, 20)

                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        NavigationLink(destination: MedidateView()) {
                            GridButton(title: "Meditate", systemImage: "figure.mind.and.body", color: Color.red)
                        }
                        
                        NavigationLink(destination: LearnView()) {
                            GridButton(title: "Learn", systemImage: "book", color: Color.blue)
                        }
                    }
                    HStack(spacing: 20) {
                        NavigationLink(destination: LifeView()) {
                            GridButton(title: "Life", systemImage: "heart", color: Color.green)
                        }
                        
                        NavigationLink(destination: FitnessView()) {
                            GridButton(title: "Fitness", systemImage: "figure.walk", color: Color.yellow)
                        }
                    }
                }
                .padding()
                
                NavigationLink(destination: ScheduleView()) {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Schedule")
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                }
                .padding(.top, 20)
                
                Spacer()
                
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
    }
    func fetchQuote() {
        let url = URL(string: "https://zenquotes.io/api/random")!

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let json = try? JSONDecoder().decode([Quote].self, from: data) {
                DispatchQueue.main.async {
                    quote = "\"\(json[0].q)\" - \(json[0].a)"
                }
            }
        }.resume()
    }
    struct Quote: Codable {
        let q: String
        let a: String
    }

}

struct GridButton: View {
    var title: String
    var systemImage: String
    var color: Color
    
    var body: some View {
        VStack {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .padding()
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
        }
        .frame(width: 150, height: 150)
        .background(color.opacity(0.1))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    MainView()
}
