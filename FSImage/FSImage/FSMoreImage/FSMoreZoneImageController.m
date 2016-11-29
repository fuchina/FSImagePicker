//
//  FSMoreZoneImageController.m
//  FSImage
//
//  Created by fudon on 2016/10/11.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSMoreZoneImageController.h"
#import "FSImagePicker.h"
#import "FSIPModel.h"
#import "FSMoreZoneImageCell.h"
#import "FSAllImageController.h"
#import "FSImagePickerController.h"

@interface FSMoreZoneImageController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSDictionary       *allImages;
@property (nonatomic,strong) NSArray            *allKeys;

@end

@implementation FSMoreZoneImageController

#if DEBUG
- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
#endif

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"照片";
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(bbiRightAction)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    
    FSImagePickerController *ip = (FSImagePickerController *)self.navigationController;
    _allImages = ip.picker.allThumbnails;
    _allKeys = [_allImages allKeys];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allKeys.count;
}

- (FSMoreZoneImageCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MoreZoneImageCell";
    FSMoreZoneImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FSMoreZoneImageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NSString *key = [_allKeys objectAtIndex:indexPath.row];
    NSArray *array = [_allImages objectForKey:key];
    if (array.count) {
        FSIPModel *model = array[array.count - 1];
        cell.model = model;
    }
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ (%@)",key,@(array.count)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [_allKeys objectAtIndex:indexPath.row];
    NSArray *array = [_allImages objectForKey:key];

    FSAllImageController *moreImageController = [[FSAllImageController alloc] init];
    moreImageController.dataSource = array;
    [self.navigationController pushViewController:moreImageController animated:YES];
}

- (void)bbiRightAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
