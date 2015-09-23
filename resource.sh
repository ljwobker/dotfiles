# create a directory for output

basedir="/home/ljw/bfwork/memUsage/"

# reference for later  ;)
# sed -e "s/foo/bar/" infile > outfile    # replaces foo with bar in "infile" and writes to "outfile"
# sed -e "/matchme/s/foo/bar/"     # replaces foo with bar in lines that have "matchme"

# if the user gives us an argument, use that as the destination directory, otherwise make one up 
# using a pretty date string.
if [ -n "$1" ] ; then
    dest=$basedir$1
else
    date=`date +%Y%m%d-%H%M%S`
    dest=$basedir$date
fi
rm -rf $dest
mkdir $dest


# copy p4source to directory
cd ~/bfwork/p4factory/targets/switch/
echo "copying p4 source files to $dest"
cp -ar p4src $dest 
cd -

# run graphs 
rm -rf  ~/bfwork/p4factory/targets/switch/graphs/
mkdir ~/bfwork/p4factory/targets/switch/graphs
cd ~/bfwork/p4factory/targets/switch/graphs
echo "running p4c-graphs, logging to $dest/graphs.log"
time p4c-graphs ../p4src/switch.p4  &> $dest/graphs.log &
cd -


# run build
rm -rf ~/bfwork/p4factory/targets/switch/tmp/
mkdir ~/bfwork/p4factory/targets/switch/tmp
cd ~/bfwork/p4factory/targets/switch/tmp
echo "running tofino table fit, logging to $dest/build.log"

time python ../../../submodules/p4c-tofino/p4c_tofino/shell.py ../p4src/switch.p4 --pa-no-backtracking -D__TARGET_TOFINO__ --no-encode --placement-order ingress_before_egress --verbose 2  &> $dest/build.log

#time python ../../../submodules/p4c-tofino/p4c_tofino/shell.py ../p4src/switch.p4 --device_model ~/bfwork/tofino_12_stage_device_model_11_sram_columns.json  --pa-no-backtracking -D__TARGET_TOFINO__ --no-encode --placement-order ingress_before_egress --verbose 2  &> $dest/build.log

#time python ../../../submodules/p4c-tofino/p4c_tofino/shell.py ../p4src/switch.p4 --pa-no-backtracking -D__TARGET_TOFINO__ --no-encode --placement-order ingress_before_egress --verbose 2  &> $dest/build.log
tail -5 $dest/build.log

cd -

# copy all html files to directory
cd ~/bfwork/p4factory/targets/switch/tmp
echo "copying HTML and log files to $dest"
cp *.log $dest
cp *.html $dest
cd -

# copy all graph files to directory
cd ~/bfwork/p4factory/targets/switch/graphs
echo "copying graph files to $dest"
cp *.png $dest
cd -

