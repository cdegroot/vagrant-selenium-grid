vagrant-selenium-grid
=====================

If you have Vagrant installed, this will create a 1-node Selenium Grid for you. It's useful for quick local testing, 
for example when figuring out the invocation of a test suite for a CI environment. 

After "vagrant up" you will have a single-node grid on http://172.16.202.120:4444/. The node advertises 5 firefox (actually
iceweasel) instances. A VNC server runs on :1 so you can follow a test, the password for the session is "123qwe". 
No warranties of any kind :)

Legal
=====

Written in 2013 by Cees de Groot <cg@cdegroot.com>

This software is in the public domain. Please see the file
UNLICENSE for details.

