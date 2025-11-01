//
//  ContentView.swift
//  MyCamera
//
//  Created by Takayama on 2025/10/31.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State var captureImage: UIImage? = nil
    
    @State var isShowSheet = false
    
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            if let captureImage {
                Image(uiImage: captureImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Spacer()
            
            Button {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラは利用できます")
                    isShowSheet.toggle()
                }
                else {
                    print("カメラは利用できません")
                }
            }label: {
                Text("カメラを起動する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
            .sheet(isPresented: $isShowSheet) {
                ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
            }
            
            PhotosPicker(selection: $photoPickerSelectedImage, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()){
                Text("フォトライブラリから選択する。")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .padding()
            }
            .onChange(of: photoPickerSelectedImage) { photoPickerItem in
                if let photoPickerItem {
                    photoPickerItem.loadTransferable(type: Data.self) { result in
                                                                          switch result {
                    case .success(let data):
                        if let data {
                            captureImage = UIImage(data: data)
                        }
                    case .failure:
                        return
                    }
                    }
                }
            }
            
            if let captureImage {
                // captureImageから共有する画像を生成する
                let shareImage = Image(uiImage: captureImage)
                // 共有シート
                ShareLink(item: shareImage, subject: nil, message: nil,
                          preview: SharePreview("Photo", image: shareImage)) {
                    // テキスト表示
                    Text("SNSに投稿する")
                    // 横幅いっぱい
                        .frame(maxWidth: .infinity)
                    // 高さ50ポイント指定
                        .frame(height: 50)
                    // 背景を青色に指定
                        .background(Color.blue)
                    // 文字色を白色に指定
                        .foregroundColor(Color.white)
                    // 上下左右に余白を追加
                        .padding()
                } // ShareLinkここまで
            } // アンラップここまで
        }
    }
}

#Preview {
    ContentView()
}
