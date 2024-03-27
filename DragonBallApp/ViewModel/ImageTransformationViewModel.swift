//
//  ImageTransformationViewModel.swift
//  DragonBallApp
//
//  Created by Marco Alonso on 26/03/24.
//

import SwiftUI
import Photos

class ImageTransformationViewModel: ObservableObject {
    
    @Published var downloadedImage: UIImage? = nil
    @Published var showAlert = false
    @Published var data: Data?
    
    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error al descargar la imagen: \(error?.localizedDescription ?? "")")
                return
            }
            
            DispatchQueue.main.async {
                self.data = data
                self.downloadedImage = UIImage(data: data)
            }
        }.resume()
    }
    
    func saveImageToPhotosLibrary(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Error al convertir la imagen en datos")
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: imageData, options: nil)
                }) { success, error in
                    if let error = error {
                        print("Error al guardar la imagen en la biblioteca de Fotos: \(error)")
                    } else {
                        print("Imagen guardada correctamente")
                        self.showAlert = true
                    }
                }
            } else {
                print("Acceso a la biblioteca de fotos denegado")
            }
        }
    }
    
}
