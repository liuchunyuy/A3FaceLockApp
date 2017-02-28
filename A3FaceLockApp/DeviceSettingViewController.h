//
//  DeviceSettingViewController.h
//  iOSSample
//
//  Created by mini2 on 5/30/13.
//  Copyright (c) 2013 wulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Device.h"
#include "wulianSDK.h"

@interface DeviceSettingViewController : UIViewController
{
    CGateway *m_pGateway;
    CString strAreaID;
}

@property CDevice *m_pDevice;
@property (retain, nonatomic) IBOutlet UIButton *doneBtn;
@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;
@property (retain, nonatomic) IBOutlet UIButton *showEPBtn;
@property (retain, nonatomic) IBOutlet UIView *epView;
@property (retain, nonatomic) IBOutlet UITextField *mainName;
@property (retain, nonatomic) IBOutlet UITextField *epName1;
@property (retain, nonatomic) IBOutlet UITextField *epName2;
@property (retain, nonatomic) IBOutlet UITextField *epName3;
@property (retain, nonatomic) IBOutlet UITextField *epName4;
@property (retain, nonatomic) IBOutlet UITextField *categoryTF;
@property (retain, nonatomic) IBOutlet UITableView *theTableView;
@property (retain, nonatomic) IBOutlet UILabel *epLab1;
@property (retain, nonatomic) IBOutlet UILabel *epLab2;
@property (retain, nonatomic) IBOutlet UILabel *epLab3;
@property (retain, nonatomic) IBOutlet UILabel *epLab4;
@property (strong, nonatomic) IBOutlet UILabel *nameTIitleLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameTextFieldPutin;
@property (strong, nonatomic) IBOutlet UILabel *titleLbel;

- (void)setM_pGateway:(CGateway *)pGateway;
- (CGateway*)m_pGateway;

-(IBAction)done;
-(IBAction)cancel;
- (IBAction)showEP:(id)sender;

@end
