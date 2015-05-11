# LJ's bash functions...

function noipv6 ()
{
  echo "Disabling ipv6 as requested, sire!"
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
  sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
}

function githammer ()
{
  cdp4
  git fetch origin master
  git reset --hard FETCH_HEAD
  git submodule update --init
  cd submodules/p4c-behavioral && sudo python setup.py install && cd - 
}

function runlg ()
{
# if the virtual ethernet interfaces aren't set up yet, run the setup script
  if [ ! -d /sys/class/net/veth8 ]; then 
    sudo ~/bfwork/p4factory/tools/veth_setup.sh 
  fi
  if [ -f ./behavioral-model ] ; then
    sudo ./behavioral-model || reset
  else
    echo "Exiting -- ./behavioral-model executable not found in this directory..."
  fi
}

function p4update ()
{


  if [ ! -d ./submodules ]; then
    echo "No submodules directory here... exiting"
  else

    for dir in p4c-graphs p4c-tofino p4c-behavioral p4-hlir ; do
      cd submodules/$dir
      sudo python setup.py install &> /tmp/$dir-update.log &
      cd -
    done
  echo "done"
  fi

}


  
