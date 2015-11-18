//
//  MainTableViewCell.h
//  XBYL
//
//  Created by 罗娇 on 15/7/25.
//  Copyright (c) 2015年 罗娇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *onlineImageView;
@property (weak, nonatomic) IBOutlet UILabel *nextNoLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *identifNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *xueyaLabel1;

@property (weak, nonatomic) IBOutlet UILabel *xueyaLabel2;
@property (weak, nonatomic) IBOutlet UILabel *xinlvLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailvLabel;
@property (weak, nonatomic) IBOutlet UILabel *xueyangLabel;
@property (weak, nonatomic) IBOutlet UILabel *huxiLabel;

@property (weak, nonatomic) IBOutlet UIButton *armBtn;

@end
