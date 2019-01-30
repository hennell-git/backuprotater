# backuprotater
Bash Script to backup a folder to a zip, keeping a specificed number of copies.


## Useage

Backup source folder to destination folder:

````backuprotater.sh "/sourcefolder" "/destination"````

This has a default rotate count of 10 files. If it finds more than 10 files in `/destination` folder it will delete the oldest files until there are only 10 in total.
*Note:* The script keeps a `latest.zip` file for quick finding of the latest version. *This is included in the rotation count*. (i.e. you will have 9 unique backups,plus the latest as a duplicate)

### Specifing rotation count
Use the `-p` option to specify a differnt rotation count:

```backuprotater.sh -p 15 "/sourcefolder" "/destination"```

This will keep a max of 15 files in the destination.

## Credits
Based of a script from '[Tony B](http://www.abrandao.com/2014/01/linux-backup-and-rotate-script/)'.
