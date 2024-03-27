//
//  ImageTransformationView.swift
//  DragonBallApp
//
//  Created by Marco Alonso on 19/03/24.
//

import SwiftUI
import Photos

struct ImageTransformationView: View {
    
    @StateObject var viewModel = ImageTransformationViewModel()
    @Binding var urlImage: String
    @State private var isShowingActivityView = false
    
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            .blue,
                            .white
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .edgesIgnoringSafeArea(.all)
            
                ImageCharacterView(url: urlImage, width: SizeConstants.cardWidth, heigh: SizeConstants.cardHeigth)
                
            
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {
                        if let image = viewModel.downloadedImage {
                            vibrateOnTap()
                            viewModel.saveImageToPhotosLibrary(image)
                        }
                    }, label: {
                        Image(systemName: "square.and.arrow.down")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .background {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 48, height: 48)
                                    .shadow(radius: 6)
                            }
                    })
                    
                    
                    Spacer()
                    
                    Button(action: {
                        vibrateOnTap()
                        isShowingActivityView = true
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .background {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 48, height: 48)
                                    .shadow(radius: 6)
                            }
                    })
                }
                .padding(.horizontal, 32)
                
            }
            
        }
        .onAppear {
            viewModel.downloadImage(from: URL(string: urlImage)!)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Imagen guardada"), message: Text("La imagen se guardó correctamente en la galería de fotos"), dismissButton: .default(Text("Aceptar")))
        }
        .sheet(isPresented: $isShowingActivityView, content: {
            if (viewModel.data != nil) {
                ActivityView(activityItems: [UIImage(data: viewModel.data!)!])
            }
        })
    }
    //    MARK: - Functions
    func vibrateOnTap() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

#Preview {
    ImageTransformationView(urlImage: .constant(MockData.dbCharacters[0].image))
}


struct SizeConstants {
    static var cardWidth: CGFloat {
       UIScreen.main.bounds.width - 20
   }
   
    static var cardHeigth: CGFloat {
       UIScreen.main.bounds.height / 1.45
   }
}

