#!/bin/bash

clean () {
  rm -f _test_check_distro.sh
  rm -rf _test_bin/
}

mkdir -p _test_bin

cat > _test_check_distro.sh << EOF
#!/bin/bash
print_status() {
  echo \$1
}
$(sed -n '/#-check-distro-#/,/#-check-distro-#/p' setup)
echo type=\$DIST_TYPE version=\$DIST_VERSION arch=\$DIST_ARCH url=\$RELEASE_URL
EOF

chmod 744 _test_check_distro.sh

testCheckDistro () {
  local release=$1
  local uname=$2
  local exptype=$3
  local expversion=$4
  local exparch=$5
  local relurl=$6

  echo "echo '${release}'" > _test_bin/rpm
  chmod 755 _test_bin/rpm
  echo "echo ${uname}" > _test_bin/uname
  chmod 755 _test_bin/uname

  _result=$(PATH=_test_bin/:${PATH} ./_test_check_distro.sh)
  local result=$_result

  if [[ $? -ne 0 ]]; then
    echo -e "\033[1m\033[31mFAIL\033[39m\033[22m: $release $uname (exec)"
    return
  fi

  local expected="type=${exptype} version=${expversion} arch=${exparch} url=${relurl}"

  if [ "X${result}" != "X${expected}" ]; then
    echo -e "\033[1m\033[31mFAIL\033[39m\033[22m: $release $uname (match)"
  echo $result
    return
  else
    echo -e "\033[1m\033[32mPASS\033[39m\033[22m: $release $uname"
  fi

}


##               release                                           uname   exptype  expversion  exparch  relurl
testCheckDistro  fedora-release-19-8.noarch                        i686    fc       19          i386     https://rpm.nodesource.com/pub/fc/19/i386/nodesource-release-fc19-1.noarch.rpm
testCheckDistro  fedora-release-19-8.noarch                        x86_64  fc       19          x86_64   https://rpm.nodesource.com/pub/fc/19/x86_64/nodesource-release-fc19-1.noarch.rpm
testCheckDistro  fedora-release-20-3.noarch                        i686    fc       20          i386     https://rpm.nodesource.com/pub/fc/20/i386/nodesource-release-fc20-1.noarch.rpm
testCheckDistro  fedora-release-20-3.noarch                        x86_64  fc       20          x86_64   https://rpm.nodesource.com/pub/fc/20/x86_64/nodesource-release-fc20-1.noarch.rpm

testCheckDistro  centos-release-5-8.el5.centos                     i686    el       5           i386     https://rpm.nodesource.com/pub/el/5/i386/nodesource-release-5-1.noarch.rpm
testCheckDistro  centos-release-5-10.el5.centos                    x86_64  el       5           x86_64   https://rpm.nodesource.com/pub/el/5/x86_64/nodesource-release-5-1.noarch.rpm
testCheckDistro  centos-release-6-5.el6.centos.11.2.i686           i686    el       6           i386     https://rpm.nodesource.com/pub/el/6/i386/nodesource-release-6-1.noarch.rpm
testCheckDistro  centos-release-6-5.el6.centos.11.2.x86_64         x86_64  el       6           x86_64   https://rpm.nodesource.com/pub/el/6/x86_64/nodesource-release-6-1.noarch.rpm
testCheckDistro  centos-release-7-0.1406.el7.centos.2.5.x86_64     x86_64  el       7           x86_64   https://rpm.nodesource.com/pub/el/7/x86_64/nodesource-release-7-1.noarch.rpm

testCheckDistro  redhat-release-5Server-5.10.0.4                   x86_64  el       5           x86_64   https://rpm.nodesource.com/pub/el/5/x86_64/nodesource-release-5-1.noarch.rpm
testCheckDistro  redhat-release-server-6Server-6.5.0.1.el6.x86_64  x86_64  el       6           x86_64   https://rpm.nodesource.com/pub/el/6/x86_64/nodesource-release-6-1.noarch.rpm
testCheckDistro  redhat-release-server-7.0-1.el7.x86_64            x86_64  el       7           x86_64   https://rpm.nodesource.com/pub/el/7/x86_64/nodesource-release-7-1.noarch.rpm

clean

exit 0