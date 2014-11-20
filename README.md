#Wrench - The SRCDS Manager

A small, robust and complete SRCDS manager for TF2 server instances. This tool manages multiple instances of TF2 servers using symbolic links of a master install. 

![valve](http://www.carolinagamessummit.com/content/files/valve.jpg)

##Installation
To work with this tool, simply clone this repository into your home directory. Then edit the following files 

* `master/tf2_ds.txt`
* `copy/wrench.config`

with your absolute path to your home directory. For example, `tf2_ds.tx` may look something like this:

```bash
login anonymous
force_install_dir /home/tf2_user/master/tf2
app_update 232250
quit
```

Next, install an instance of TF2 into the `master` folder

```bash
cd $HOME/master;
wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz;
tar xzf steamcmd_linux.tar.gz;
chmod +x steamcmd.sh;
./steamcmd.sh +runscript tf2_ds.txt
```

Next you can install Sourcemod/Metamod into master/tf2/tf/addons. If you do not plan to install sourcemod, ensure to make the following changes.

```bash
rm -rf $HOME/copy/tf/addons;
```

##Adding an instance of TF2
To add an instance of tf2, simply copy the folder `copy` and rename it to something else. You can then edit `wrench.config` for startup options and other cfg files located in the `tf/cfg` directory.

For example:

```bash
cp $HOME/config $HOME/turbine
vi $HOME/turbine/wrench.config
```
Here we successfully created an instance of TF2 called `turbine`, and modified its startup parameters in `wrench.config`

##Starting an instance of TF2
To start your newly installed instances of TF2, simply use the wrench.pl script.

```bash
perl wrench.pl --start turbine
```
Will start the instance of TF2 called `turbine`. 

```bash
perl wrench.pl --start all
```
Will start all available instances of TF2

##Determining instance status

```bash 
perl wrench.pl --status turbine
```
This will determine the status of `turbine` (if it is running or not)

```bash
perl wrench.pl --list
```
Will return the status of all instances

##Removing an instance of TF2
Removing an instance of TF2 is harmless, requires no work.
Simply delete the folder of the instance you would like to remove

```bash
rm -rf $HOME/turbine;
```
This will remove the instance called `turbine`

##Accessing console of instance
GNU Screen is used as a terminal multiplexer for running multiple instances of TF2. To access the console of an instance is simple.

```bash
screen -r turbine
```

This will attach the screen session of the instance called `turbine`