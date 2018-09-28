//
//  TextFilesTools.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

class FilesTools {
    
    func cutFromTextLine(TextLine: String, From: Int, To: Int) -> String {
        let from = TextLine.index(TextLine.startIndex, offsetBy: From)
        let to = TextLine.index(TextLine.startIndex, offsetBy: To)
        let cutText = TextLine[from..<to]
        return String(cutText)
    }
    
    func getTextFromFile(from directoryPath: String, fileType fileExtention: String) -> [(FileName: String, Content: [String])] {
        
        guard ifDirectoryExists(at: directoryPath) else {
            fatalError("No such directory at patch <\(directoryPath)>")
        }
        
        switch fileExtention {
        case "csv":
            return getTextFromCSV(path:directoryPath)
        default:
            print("Can't handle file format!")
        }
        
        return []
    }
}



extension FilesTools {
    
    func ifDirectoryExists(at path: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
    }
    
    func getTextFromCSV(path: String) -> [(FileName: String, Content: [String])] {
        var csvFiles = [(FileName: String, Content: [String])]()
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            for fileName in files {
                if fileName.hasSuffix("csv") {
                    let content = try String(contentsOfFile: path+"/\(fileName)", encoding: String.Encoding.utf8).components(separatedBy: "\n")
                    var csvFile = (FileName: String(), Content: [String]())
                    csvFile.FileName = fileName
                    csvFile.Content.append(contentsOf: content)
                    csvFiles.append(csvFile)
                }
            }
        } catch {
            fatalError("No files wihle searching for .csv extention in directory")
        }
        return csvFiles
    }
}
