//
//  ImagePickerView.swift
//  MyCamera
//
//  Created by Takayama on 2025/10/31.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var isShowSheet: Bool
    
    @Binding var captureImage: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView){
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.captureImage = originalImage
            }
            parent.isShowSheet.toggle()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShowSheet.toggle()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let myImagePickerController = UIImagePickerController()
        myImagePickerController.sourceType = .camera
        myImagePickerController.delegate = context.coordinator
        return myImagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //処理なし
    }
}
