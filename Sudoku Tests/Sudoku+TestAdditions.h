//
//  Sudoku+TestAdditions.h
//  Sudoku
//
//  Created by Ankh on 14.04.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "Sudoku.h"

@class SudokuGroup;
@interface Sudoku (TestAdditions)

- (void) initWithStringContents:(NSString *)contents;
- (BOOL) group:(SudokuGroup *)group equalsTo:(NSArray *)numbers;

@end
