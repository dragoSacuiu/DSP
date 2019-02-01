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
    
    func getTextFromFile(from directoryPath: String, fileType fileExtention: String) -> [(FileName: String, Content: String)] {
        
        guard ifDirectoryExists(at: directoryPath) else {
            fatalError("No such directory at patch <\(directoryPath)>")
        }
        
        switch fileExtention {
        case "csv":
            return getTextFromCSVFiles(path:directoryPath)
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
    
    func emptyTextFile(path: String) {
        let emptyString = ""
        do {
            try emptyString.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
        } catch  {
            fatalError("No file to empty!")
        }
    }
    
    func getTextFromCSVFiles(path: String) -> [(FileName: String, Content: String)] {
        var csvFiles = [(FileName: String, Content: String)]()
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            for fileName in files {
                if fileName.hasSuffix("csv") {
                    let filePath = path+"/\(fileName)"
                    let file = FileHandle(forReadingAtPath: filePath)
                    
                    if file != nil {
                        let content = file?.readDataToEndOfFile()
                        emptyTextFile(path: filePath)
                        file?.closeFile()
                        let textContent = String(data: content!, encoding: String.Encoding.utf8)
                        let csvFile = (FileName: fileName, Content: textContent)
                        csvFiles.append(csvFile as! (FileName: String, Content: String))
                    }
                }
            }
        } catch {
            fatalError("No files wihle searching for .csv extention in directory")
        }
        return csvFiles
    }
    func replaceCharInString(string: String, charToBeReplaced: String, with char: String) -> String{
        let modeifiedString = string.replacingOccurrences(of: charToBeReplaced, with: char, options: String.CompareOptions.literal , range: nil)
        return modeifiedString
    }
}
