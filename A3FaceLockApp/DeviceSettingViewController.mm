//
//  DeviceSettingViewController.m
//  iOSSample
//
//  Created by mini2 on 5/30/13.
//  Copyright (c) 2013 wulian. All rights reserved.
//

#import "DeviceSettingViewController.h"

@interface DeviceSettingViewController ()<UIGestureRecognizerDelegate>

@end

@implementation DeviceSettingViewController
@synthesize m_pDevice,doneBtn,cancelBtn,showEPBtn,epView,mainName,epName1,epName2,epName3,epName4,categoryTF,theTableView,epLab1,epLab2,epLab3,epLab4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setM_pGateway:(CGateway *)pGateway
{
    m_pGateway = pGateway;
}

- (CGateway*)m_pGateway
{
    return m_pGateway;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    doneBtn.frame = CGRectMake(37,tempWindow.frame.size.height/2,116,30);
    cancelBtn.frame = CGRectMake(168,tempWindow.frame.size.height/2,116,30);
    _nameTIitleLabel.frame = CGRectMake(SCREEN_WIDTH/3/2, 120, 2*(SCREEN_WIDTH/3)/4, 40);
    _nameTextFieldPutin.frame = CGRectMake(SCREEN_WIDTH/3/2+2*(SCREEN_WIDTH/3)/4, 120, 2*3*(SCREEN_WIDTH/3)/4, 40);
    _nameTextFieldPutin.clearButtonMode = UITextFieldViewModeAlways;
    self.navigationItem.title = @"修改设备名字";
    _titleLbel.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
    _titleLbel.hidden = YES;
    theTableView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    mainName.text = [NSString stringWithUTF8String:m_pDevice->m_strName.c_str()];

}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.nameTextField resignFirstResponder];
}

-(IBAction)done{
    
    if (_nameTextFieldPutin.text.length == 0) {
        [MBManager showBriefMessage:@"不要偷懒，新名字不能为空哦 o(>﹏<)o" InView:self.view];
        return;
    }
    std::map<CString, CEPData>::iterator iter = m_pDevice->m_map_ep_data.begin();
    sendSetDevMsg(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(), 2, m_pDevice->m_strID.c_str(), m_pDevice->m_strType.c_str(), iter->first.c_str(), iter->second.m_strEPType.c_str(), [_nameTextFieldPutin.text UTF8String], [categoryTF.text UTF8String], strAreaID.c_str(), 0, 0);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showEP:(id)sender
{
    UIButton *newBtn = (UIButton*)sender;
    if(newBtn.selected)
    {
        epView.hidden = YES;
        [showEPBtn setImage:[UIImage imageNamed:@"detail2"] forState:UIControlStateNormal];
    }
    else
    {
        epView.hidden = NO;
        [showEPBtn setImage:[UIImage imageNamed:@"detail1"] forState:UIControlStateNormal];
    }
    newBtn.selected = !newBtn.selected;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_map_id_str_area[m_pGateway->m_strID].size()+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"Not in the area";
        if(strAreaID == "")
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        ITER_MAP_STR_AREA  iter = m_map_id_str_area[m_pGateway->m_strID].begin();
        std::advance(iter, indexPath.row-1);
        cell.textLabel.text = [NSString stringWithUTF8String:iter->second->m_strName.c_str()];
        if (iter->second->m_strID == strAreaID)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        strAreaID = "";
    }
    else
    {
        ITER_MAP_STR_AREA  iter = m_map_id_str_area[m_pGateway->m_strID].begin();
        std::advance(iter, indexPath.row-1);
        strAreaID = iter->second->m_strID;
    }
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidUnload {
//    [self setDoneBtn:nil];
//    [self setCancelBtn:nil];
//    [self setShowEPBtn:nil];
//    [self setEpView:nil];
//    [self setMainName:nil];
//    [self setEpName1:nil];
//    [self setEpName2:nil];
//    [self setEpName3:nil];
//    [self setEpName4:nil];
//    [self setCategoryTF:nil];
//    [self setTheTableView:nil];
//    [self setEpLab1:nil];
//    [self setEpLab2:nil];
//    [self setEpLab3:nil];
//    [self setEpLab4:nil];
//    [super viewDidUnload];
//}
@end
