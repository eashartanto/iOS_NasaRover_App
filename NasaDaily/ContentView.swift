//
//  ContentView.swift
//  NasaDaily
//
//  Created by Andreas Hartanto on 2023-02-05.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    private var rovers_name = ["Curiosity","Opportunity","Spirit"]
    @State private var  roverSelectedIndex = 0
    @State private var  photoSelectedIndex = 0
    @State private var photos = [NasaPhoto]()
    @State private var selectedDate = Date()
    
    @ObservedObject var marsPhotos = ApiViewController()
    
    var body: some View {
        NavigationView {
            Form {
                //Section for Rovers
                Section {
                    Picker(selection: $roverSelectedIndex, label: Text("Select Rover")) {
                        ForEach(0 ..< rovers_name.count) {
                            Text(self.rovers_name[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .onChange(of: self.roverSelectedIndex) { (index) in
                            self.marsPhotos.fetchMarsPhotos(date: selectedDate, roverSelectedIndex: index)
                        }
                }
                
                //Section for Date
                Section {
                    DatePicker(selection: $selectedDate, displayedComponents: .date) {
                        Text("Selected Date: ")
                    }.onChange(of: selectedDate) { (value) in
                        self.marsPhotos.fetchMarsPhotos(date: value, roverSelectedIndex: roverSelectedIndex)
                    }
                }
                //Section for image index
                Section{
                    Text("Number of Photos: \(marsPhotos.marsPhotos.count)")
                    Picker(selection: $photoSelectedIndex, label: Text("Select a Photo: ")) {
                        ForEach(0..<marsPhotos.marsPhotos.count, id: \.self) { index in
                            Text("\(self.marsPhotos.marsPhotos[index].id)").tag("\(self.marsPhotos.marsPhotos[index].id)")
                        }
                    }
                    
                }
                
                // Section to show the selected image
                Section{
                    if photoSelectedIndex >= 0 && photoSelectedIndex < marsPhotos.marsPhotos.count {
                        Section {
                            if let url = URL(string: marsPhotos.marsPhotos[photoSelectedIndex].img_src) {
                                ImageView(url: url)
                            } else {
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            }
                        }
                    } else {
                        Section {
                            Text("No image selected")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationBarTitle("NASA Daily Pictures")
            
            
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

//function for imageUrl
struct ImageView: View {
    let url: URL
    
    var body: some View {
        ImageViewContainer(imageURL: url)
    }
}

struct ImageViewContainer: View {
    @ObservedObject private var imageLoader = ImageLoader()
    var image: UIImage? {
        return imageLoader.image
    }
    
    init(imageURL: URL) {
        imageLoader.loadImage(with: imageURL)
    }
    
    var body: some View {
        Image(uiImage: image ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    func loadImage(with url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
