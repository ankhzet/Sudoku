//
//  SudokuCell.h
//  Sudoku
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UNUSED_CELL 0

@class Sudoku;
@interface SudokuCell : NSObject

@property (nonatomic, readonly) Sudoku *sudoku;
@property (nonatomic) NSUInteger number;
@property (nonatomic, readonly) NSUInteger x;
@property (nonatomic, readonly) NSUInteger y;

+ (instancetype) cellForSudoku:(Sudoku *)sudoku atX:(NSUInteger)x andY:(NSUInteger)y;

@end
