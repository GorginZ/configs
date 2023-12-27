# Fresh 2013 Thinkpad T440P Debian install

This is my runsheet for the steps I took to set up a new 2013 t440p I was gifted for Christmas with Debian 12.4.0 . I'm noting what I did incase I run into errors or for future reference for what to or not to do.

### Particulars:
- The new machine: 2013 Thinkpad t440p
  - target OS: Debian 12.4.0, network install
- Method: [booting from USB stick](https://www.debian.org/releases/stable/amd64/ch05s01.en.html#usb-boot-x86)
  - USB prepared with simple ```diskutil``` and ```dd``` commands on 2021 macbook pro (m1) running Montery 12.5


I have 2021 MacBook Pro (m1 chip) on Montery 12.5 so I looked into [UNetbootin](https://unetbootin.github.io/) but ran into the issue raised [here](https://github.com/unetbootin/unetbootin/issues/286) where the program prompts for password. I read the issue and decided to go another way, which would be to just download the ISO and copy it across to the USB, this is what I recommend and would do in future because it's so simple.  

## Identify the appropriate ISO for your machine and download it 

##### Architecture
I'll need AMD64 because that's the CPU architecture I've got.

##### Installation type

I'm doing a *network install*, where the base entire OS is installed and remaining packages are pulled down. I will have a ethernet connection as internet connectivity is a requirement. This is recommended because the ISO itself is smaller. 

### Download the ISO:

See: [debian docs on Network install from a minimal cd](https://www.debian.org/CD/netinst/#netinst-stable) download for amd64 arch.


## prepare boot media

##### Copy the ISO it over to USB

Simple as:
- Debian docs on how to do this on MacOS: https://www.debian.org/CD/faq/#write-usb

I alo read this OSX daily [how-to](https://osxdaily.com/2015/06/05/copy-iso-to-usb-drive-mac-os-x-command/) which works with some modifications to commands. It's from 2015 so probably with new OSX releases there are some differences to be accounted for. This was too easy and worked great. 


#### Identify your USB with diskutil and confirm 100% you have the right device to target

Make sure I'm definitely targetting the correct device...
>IMPORTANT: triple check because this will get wiped

So I take a look at what I have (usb plugged in)


```bash
➜  list
/dev/disk0 (internal):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                         500.3 GB   disk0
   1:             Apple_APFS_ISC                         524.3 MB   disk0s1
   2:                 Apple_APFS Container disk3         494.4 GB   disk0s2
   3:        Apple_APFS_Recovery                         5.4 GB     disk0s3

/dev/disk3 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +494.4 GB   disk3
                                 Physical Store disk0s2
   1:                APFS Volume Macintosh HD            23.4 GB    disk3s1
   2:              APFS Snapshot com.apple.os.update-... 23.4 GB    disk3s1s1
   3:                APFS Volume Preboot                 532.5 MB   disk3s2
   4:                APFS Volume Recovery                1.6 GB     disk3s3
   5:                APFS Volume Data                    275.6 GB   disk3s5
   6:                APFS Volume VM                      5.4 GB     disk3s6

/dev/disk4 (disk image):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        +29.4 MB    disk4
   1:                 Apple_APFS Container disk5         29.4 MB    disk4s1

/dev/disk5 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +29.4 MB    disk5
                                 Physical Store disk4s1
   1:                APFS Volume UNetbootin              17.2 MB    disk5s1

/dev/disk6 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *8.0 GB     disk6
   1:
```

I'm quite sure it's the last one (My machine says it can't read the usb, but I know it's 8GB)

I unplug it to see if it goes away...

```bash
➜  my-cluster diskutil list
/dev/disk0 (internal):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                         500.3 GB   disk0
   1:             Apple_APFS_ISC                         524.3 MB   disk0s1
   2:                 Apple_APFS Container disk3         494.4 GB   disk0s2
   3:        Apple_APFS_Recovery                         5.4 GB     disk0s3

/dev/disk3 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +494.4 GB   disk3
                                 Physical Store disk0s2
   1:                APFS Volume Macintosh HD            23.4 GB    disk3s1
   2:              APFS Snapshot com.apple.os.update-... 23.4 GB    disk3s1s1
   3:                APFS Volume Preboot                 532.5 MB   disk3s2
   4:                APFS Volume Recovery                1.6 GB     disk3s3
   5:                APFS Volume Data                    275.5 GB   disk3s5
   6:                APFS Volume VM                      5.4 GB     disk3s6

/dev/disk4 (disk image):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        +29.4 MB    disk4
   1:                 Apple_APFS Container disk5         29.4 MB    disk4s1

/dev/disk5 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +29.4 MB    disk5
                                 Physical Store disk4s1
   1:                APFS Volume UNetbootin              17.2 MB    disk5s1

```

and it's gone, so I'm now confident that I want to target ```disk6``` 

#### Copy over the ISO

I'll just check on my iso, about to craft command with this path ofc:

```bash
➜ ls ~/Downloads/debian-12.4.0-amd64-netinst.iso
/Users/georgialeng/Downloads/debian-12.4.0-amd64-netinst.iso
```

unmount the disk

```
➜  my-cluster diskutil unmount /dev/disk6s2
disk6s2 was already unmounted
```

prep my command, double-checking, looks good.
```
➜  #sudo dd if=/Users/georgialeng/Downloads/debian-12.4.0-amd64-netinst.iso of=/dev/rdisk6 status=progress bs=1m
```
Looks good lets run it:

```
➜  sudo dd if=/Users/georgialeng/Downloads/debian-12.4.0-amd64-netinst.iso of=/dev/rdisk6 status=progress bs=1m
  655360000 bytes (655 MB, 625 MiB) transferred 136.155s, 4813 kB/s
628+0 records in
628+0 records out
658505728 bytes transferred in 136.804316 secs (4813486 bytes/sec)
➜  echo $?
0
```
eject:

```
➜  diskutil eject /dev/disk6
Disk /dev/disk6 ejected
```

This is ready to go.

## Plug it into thinkpad


You get an option for graphical install etc. proceed with installation however you choose, it's all simple.

hostname I did: ```debianpadgorg``` (why did I do this, idk we have a few thinkpads what if idk I just thought I'd make it more identifiable but in hindsight kinda dumb.)

domain: ```.local``` is best practice for pc installs apparently.

PW management: I set entries in my password manager. 


---
bloopers:


I accidentally repartitioned the usb because I'm an idiot and thinkpad had no hard drive:

on macos I look to confirm this.
```
diskutil list
```
Yep! hah.
```
...
/dev/disk6 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *8.0 GB     disk6
   1:                      Linux                         7.0 GB     disk6s1
   2:                 Linux_Swap                         1.0 GB     disk6s5

```

---
Resources mentioned above in one place:

https://www.debian.org/CD/faq/#write-usb

https://www.debian.org/CD/netinst/#netinst-stable

https://www.debian.org/releases/stable/amd64/ch05s01.en.html#usb-boot-x86

https://osxdaily.com/2015/06/05/copy-iso-to-usb-drive-mac-os-x-command/