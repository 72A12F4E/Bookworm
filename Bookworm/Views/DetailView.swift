//
//  DetailView.swift
//  Bookworm
//
//  Created by Blake McAnally on 1/28/21.
//

import CoreData
import SwiftUI

private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM dd, yyyy"
    return formatter
}()

struct DetailView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingDeleteAlert = false
    
    let book: Book

    var dateText: String {
        guard let date = book.date else {
            return "Unknown Date"
        }
        return formatter.string(from: date)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)

                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)

                Text(dateText)
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text(self.book.review ?? "No review")
                    .padding()

                RatingView(rating: .constant(self.book.rating))
                    .font(.largeTitle)

                Spacer()
            }
            
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete book"),
                message: Text("Are you sure?"),
                primaryButton: .destructive(Text("Delete")) {
                    self.deleteBook()
                },
                secondaryButton: .cancel()
            )
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }, label: {
            Image(systemName: "trash")
        }))
    }
    
    private func deleteBook() {
        moc.delete(book)
        try? self.moc.save()
        presentationMode.wrappedValue.dismiss()
    }
}
