# Bloom Fertility

An app to track fertility indicators written in Swift.

# Screenshots

![simulator screen shot oct 26 2016 12 05 51 pm](https://cloud.githubusercontent.com/assets/10137025/19734208/ac80e478-9b74-11e6-9830-8de5d2f05d7d.png)

Users can input their fertility inputs in just one screen rather than clicking through multiple screens in competitor apps.

![simulator screen shot oct 26 2016 11 49 27 am](https://cloud.githubusercontent.com/assets/10137025/19733560/5493bf26-9b72-11e6-9435-310b553db527.png)

![simulator screen shot oct 26 2016 12 10 15 pm](https://cloud.githubusercontent.com/assets/10137025/19734328/2c9200a2-9b75-11e6-943c-35c9d1e5d0cd.png)

# App Structure

The app uses a tabbed view controller to hold two views--Home and Your Cycles.  The home view is a UITableView that employs horizontal selection of fertility inputs patterned after the Clear Todo App.  User input is saved using NSCoding and NSKeyedArchiver because neither the amount nor the complexity of the data warrants a database.  The Your Cycles view (not shown because under construction) displays user input arranged by cycle.  Each cycle is a UITableViewCell and within that cell is a collection view whose cells are the days of the cycle.  
