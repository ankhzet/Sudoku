//
//  MainViewController.h
//  Sudoku
//
//  Created by Ankh on 17.04.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Sudoku;
@interface MainViewController : NSViewController
@property (weak) IBOutlet NSCollectionView *collectionViewSudoku;
@property (weak) IBOutlet NSArrayController *arrayController;
@property (nonatomic) Sudoku *sudoku;
@property (nonatomic, copy) NSMutableArray *sudokuArray;

@end
