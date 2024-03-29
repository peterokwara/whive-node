<p align="center">
  <a href="https://github.com/peterokwara/whive-node">
    <img src="assets\whiveio+logo+100.png" alt="Whive Node" >
  </a>
  <h3 align="center">Whive Node</h3>

  <p align="center">
    A set of scripts to run a whive node. <br>
   You can read more about this project here https://www.whive.io/. <br>
    <br>
    </p>
</p>

> **NB** This code is unnoficial code. Make sure you understand how the scripts work before running it.

## Table of contents
- [Prerequisites](#Prerequisites)
- [Instructions](#Instructions)
- [Operations](#Operations)
- [Backup](#Backup)
- [License](#License)

## Prerequisites

Ensure you have git installed. You can install it by running

```console
sudo apt-get install -y git
```

## Instructions

Ensure that git is installed. Clone the repo by running

```console
git clone https://github.com/peterokwara/whive-node.git
```

Once it is cloned, you can enter the directory by running

```console
cd whive-node
```

Make the `whive-node.sh` bash script executable by running

```console
chmod +x ./whive_node.sh
```

And run the script by running

```console
./whive_node.sh quickstart
```

## Operations

To resume local mining, you can run

```console
./whive_node.sh start
```

To run a node that joins an existing pool, you can run

```console
./whive_node.sh pool
```

To stop, you can run

```console
./whive_node.sh stop
```

To check your balance, you can run

```console
./whive_node.sh balance
```

Password is the value stored in the whive configuration file.

## Backup

Performing a backup is a very important procedure to do. SD cards for raspberry pi normally crash, stop working, some are faulty. It's a good procedure to back up. The good thing is that the backup procedure only needs to be done once.

Insert a flash drive to your raspberry pi. Determine the path where the flash drive was mounted by running

```console
lsblk
```

Most likely it will show up in the /dev/sdb1 directory. To mount the flash disk, run: 

```console
sudo mount /dev/sda1 /mnt
```

Then copy the wallet file to the flash drive by running

```console
sudo cp ~/.whive/wallet.dat /mnt/
```

You can confirm that the wallet.dat file has been copied over

```console
sudo ls /mnt/
```

Once you have confirmed the file has been copied over, you can now unmout by running

```console
sudo umount /mnt/
```

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details
