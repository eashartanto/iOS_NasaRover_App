//
//  APIViewController.swift
//  NasaDaily
//
//  Created by Andreas Hartanto on 2023-02-06.
//

import Foundation

class ApiViewController: ObservableObject {
    @Published var marsPhotos = [MarsPhoto]()
    let roverSelectedIndex = 0
    let apiKey = "Js1cM2PqI9h77ejQxnFsjie1tWf3TRA3Po7Fbiug"
    
    init() {
        fetchMarsPhotos(date:Date(), roverSelectedIndex: roverSelectedIndex)
    }
    
    func fetchMarsPhotos(date: Date,roverSelectedIndex: Int) {
        //date formater
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        //rover name
        let rovers = ["curiosity", "opportunity", "spirit"]
        let roverSelectedIndex =  (roverSelectedIndex)
        
        //combined url
        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rovers[roverSelectedIndex])/photos?earth_date=\(formattedDate)&api_key=\(apiKey)"
        
        print(rovers[roverSelectedIndex])
        print(formattedDate)
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                    print("Error fetching data: \(error!.localizedDescription)")
                    return
                }
            
            guard let data = data else { return }

            do {
                let marsPhotos = try JSONDecoder().decode(NasaPhoto.self, from: data)
                
                DispatchQueue.main.async {
                    self.marsPhotos = marsPhotos.photos
                }
            } catch let error {
                print("Error decoding data: \(error.localizedDescription)")
        
            }
        }.resume()
    }
}
