//
//  SudokuViewItem.h
//  Sudoku
//
//  Created by Ankh on 17.04.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SudokuViewItem : NSCollectionViewItem <NSTextFieldDelegate>

@property (weak) IBOutlet NSTextFieldCell *textFieldNumberCell;

- (void)setRepresentedObject:(id)object;

@end
