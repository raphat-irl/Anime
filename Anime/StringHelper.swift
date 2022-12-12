//
//  StringHelper.swift
//  Anime
//
//  Created by MacbookAir M1 FoodStory on 7/12/2565 BE.
//

import Foundation

extension String {
    func trim() -> String
{
    return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
}
    
func percentEncoding() -> String {
    return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
      }
}
