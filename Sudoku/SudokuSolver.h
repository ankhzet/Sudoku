//
//  SudokuSolver.h
//  Sudoku
//
//  Created by Ankh on 14.04.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Sudoku;
@interface SudokuSolver : NSObject

@property (nonatomic, readonly) Sudoku *sudoku;

+ (instancetype) solverForSudoku:(Sudoku *)sudoku;

- (void) solve;

- (BOOL) isSolved;

@end
